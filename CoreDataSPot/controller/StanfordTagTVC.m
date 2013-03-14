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
    self.isReloading = YES;
    [[CoreDataHelper sharedInstance] executeBlock:^(NSManagedObjectContext *context) {
        self.managedObjectContext = context;
        
        
        
        self.isReloading = NO;
        if([self.fetchedResultsController.fetchedObjects count] == 0){
            [self refresh];
        }else{
            [self.refreshControl endRefreshing];
        }
    }];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

# pragma mark - UITableView Delegate

- (void) refresh {
    if(!self.isReloading){ // prevent duplicated refreshing
        [self.refreshControl beginRefreshing];
        [self showBusyIndicator];
        self.isReloading = YES;
        dispatch_async(dispatch_queue_create("edu.stanford", DISPATCH_QUEUE_SERIAL), ^{
            [FlickerPhotoSync syncWithCompletionHandler:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.refreshControl endRefreshing];
                    [self hideBusyIndicator];
                    self.isReloading = NO;
                    [self performFetch];
                });
            } inMnagedContext:self.managedObjectContext];
        });
    }
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
