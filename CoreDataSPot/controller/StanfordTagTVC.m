//
//  StanfordTagTVC.m
//  CoreDataSPot
//
//  Created by Daniela on 3/8/13.
//  Copyright (c) 2013 Pyrogusto. All rights reserved.
//

#import "StanfordTagTVC.h"
#import "CoreDataHelper.h"
#import "Photo.h"
#import "FlickerPhotoSync.h"
#import "NetworkIndicatorHelper.h"

@interface StanfordTagTVC ()

typedef void (^LoadDataCallBackBlock)(void);
@property(strong,nonatomic) UIActivityIndicatorView *activityIndicatorView;
@property(readwrite,nonatomic) BOOL isReloading;
@end

@implementation StanfordTagTVC

- (void) viewDidLoad{
    [super viewDidLoad];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"Pull To Load New Data"];
    [refreshControl addTarget:self
                       action:@selector(refresh)
             forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    [self.refreshControl beginRefreshing];
    [self loadModelDataWithCompleteHandler:^{
        if([self.tagList count]==0){
            [self refresh];
        }else{
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        }
    }];
}

# pragma mark - UITableView Delegate

- (void) refresh {
    if(!self.isReloading){ // prevent duplicated refreshing
        [self.refreshControl beginRefreshing];
        [self showBusyIndicator];
        self.isReloading = YES;
        dispatch_async(dispatch_queue_create("edu.stanford", DISPATCH_QUEUE_SERIAL), ^{
            [FlickerPhotoSync syncWithCompletionHandler:^{
                [[CoreDataHelper sharedInstance] executeBlock:^(NSManagedObjectContext *context) {
                    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
                    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"tagName" ascending:YES selector:@selector(caseInsensitiveCompare:)]];
                    NSError *error;
                    self.tagList = [context executeFetchRequest:request error:&error];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //update the table view's Model to the new data, reloadData if necessary // and let the user know the refresh is over (stop spinner)
                        [self.tableView reloadData];
                        [self.refreshControl endRefreshing];
                        [self hideBusyIndicator];
                        self.isReloading = NO;
                    });
                }];
            }];
        });
    }
}

- (void)loadModelDataWithCompleteHandler:(LoadDataCallBackBlock)callBackBlock{
    [[CoreDataHelper sharedInstance] executeBlock:^(NSManagedObjectContext *context) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
        request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"tagName" ascending:YES ]];
        NSError *error;
        self.tagList = [context executeFetchRequest:request error:&error];
        callBackBlock();
    }];
}

- (UIActivityIndicatorView*) activityIndicatorView{
    if(_activityIndicatorView == nil){
        _activityIndicatorView =
        [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [_activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    }
    return _activityIndicatorView;
}

- (void)showBusyIndicator{
    [NetworkIndicatorHelper setNetworkActivityIndicatorVisible:YES];
}

- (void)hideBusyIndicator{
    [NetworkIndicatorHelper setNetworkActivityIndicatorVisible:NO];
}
@end
