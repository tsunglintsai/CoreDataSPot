//
//  ImageViewController.m
//  Shutterbug
//
//  Created by CS193p Instructor.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "ImageViewController.h"
#import "NetworkIndicatorHelper.h"
#import "UIImage+FromURL.h"
#import "ImageFetcher.h"

@interface ImageViewController () <UIScrollViewDelegate,NSURLConnectionDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *titleBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *splitViewBarButtonItem;
@property (strong,nonatomic) UIBarButtonItem * busyIndicatorBarButton;
@property (strong,nonatomic) UIBarButtonItem *flexibleSpaceBeforeBusyIndicatorBarButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UIProgressView *downloadProgressBar;
@property (weak, nonatomic) IBOutlet UILabel *downloadInfoLabel;

//test
@property (strong, nonatomic, ) NSMutableData *responseData; //stores the image data as it's being downloaded
@property (readwrite,nonatomic) long imageFileSize; //'expected' file size in bytes
@property (strong, nonatomic) NSURLConnection *connection; //the asynchronous network connection that you can send messages to
@end

@implementation ImageViewController
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;
// resets the image whenever the URL changes

- (void)setImageURL:(NSURL *)imageURL{
    _imageURL = imageURL;
    [self resetImage];
}

// fetches the data from the URL
// turns it into an image
// adjusts the scroll view's content size to fit the image
// sets the image as the image view's image
- (void)resetImage
{
    if (self.scrollView && self.imageURL!= nil) {
        [self setIsShowBusyIndicator:YES];
        self.scrollView.contentSize = CGSizeZero;
        self.imageView.image = nil;
        [self showBusyIndicator];
        dispatch_queue_t q = dispatch_queue_create("table view loading queue", NULL); dispatch_async(q, ^{
            //do something to get new data for this table view (which presumably takes time)
            UIImage *image = [UIImage imageFromURL:self.imageURL WithProgressBlock:^(long downloadedSize,long totatlSize){
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.downloadProgressBar.progress = [@(downloadedSize)floatValue] / [@(totatlSize)floatValue];
                    self.downloadInfoLabel.text = [@[ @(downloadedSize/1024), @"/", @(totatlSize/1024),@"KB"] componentsJoinedByString:@" "];
                });
            }];
            NSString *url = [self.imageURL description];
            dispatch_async(dispatch_get_main_queue(), ^{
                //update the table view's Model to the new data, reloadData if necessary // and let the user know the refresh is over (stop spinner)
                if (image && [url isEqualToString:url]) {
                    self.scrollView.zoomScale = 1.0;
                    self.scrollView.contentSize = image.size;
                    self.imageView.image = image;
                    self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
                }
                [self hideBusyIndicator];
                [self makeImageFitInScrollView];
            });
        });
    }
}

-(void)makeImageFitInScrollView{
    if(self.imageView.image){
        // make image fill whole screen
        self.scrollView.zoomScale = 1.0;
        self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
        float xScale = self.scrollView.bounds.size.width/self.imageView.image.size.width;
        float yScale = self.scrollView.bounds.size.height/self.imageView.image.size.height;
        CGRect zoomToRect;
        float xOffset = 0;
        float yOffset = 0;
        if(yScale > xScale){
            xOffset = (self.imageView.bounds.size.width * yScale - self.scrollView.bounds.size.width )/2;
            zoomToRect = CGRectMake(0, 0, 0, self.imageView.image.size.height);
        }else{
            yOffset = (self.imageView.bounds.size.height * xScale - self.scrollView.bounds.size.height )/2;
            zoomToRect = CGRectMake(0, 0, self.imageView.image.size.width, 0);
        }
        [self.scrollView zoomToRect:zoomToRect animated:false];
        self.scrollView.contentOffset = CGPointMake(xOffset , yOffset );
    }
}

// lazy instantiation

- (UIImageView *)imageView
{
    if (!_imageView) _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    return _imageView;
}

// returns the view which will be zoomed when the user pinches
// in this case, it is the image view, obviously
// (there are no other subviews of the scroll view in its content area)
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    [self.scrollView addSubview:self.imageView];
    self.scrollView.minimumZoomScale = 0.2;
    self.scrollView.maximumZoomScale = 5.0;
    self.scrollView.delegate = self;
    [self resetImage];
    self.titleBarButtonItem.title = self.title;
    self.splitViewBarButtonItem = self.splitViewBarButtonItem;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self makeImageFitInScrollView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem{
    NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
    if (_splitViewBarButtonItem) [toolbarItems removeObject:_splitViewBarButtonItem];
    if (splitViewBarButtonItem) [toolbarItems insertObject:splitViewBarButtonItem atIndex:0];
    self.toolbar.items = toolbarItems;
    _splitViewBarButtonItem = splitViewBarButtonItem;
}

- (UIBarButtonItem*) flexibleSpaceBeforeBusyIndicatorBarButton{
    if(_flexibleSpaceBeforeBusyIndicatorBarButton == nil){
        _flexibleSpaceBeforeBusyIndicatorBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    }
    return _flexibleSpaceBeforeBusyIndicatorBarButton;
}

- (void) setActivityIndicatorView:(UIActivityIndicatorView *)activityIndicatorView{
    _activityIndicatorView = activityIndicatorView;
    _activityIndicatorView.hidesWhenStopped = YES;
}

- (void)showBusyIndicator{
    self.downloadProgressBar.hidden = NO;
    self.downloadInfoLabel.hidden = NO;
    [self.activityIndicatorView startAnimating];
    [NetworkIndicatorHelper setNetworkActivityIndicatorVisible:YES];
}

- (void)hideBusyIndicator{
    self.downloadProgressBar.hidden = YES;
    self.downloadInfoLabel.hidden = YES;
    [self.activityIndicatorView stopAnimating];
    [NetworkIndicatorHelper setNetworkActivityIndicatorVisible:NO];
}

@end
