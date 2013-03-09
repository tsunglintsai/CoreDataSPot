//
//  MasterViewTVC.h
//  SPoT
//
//  Created by Henry on 2/25/13.
//  Copyright (c) 2013 Pyrogusto Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"

@interface MasterViewTVC : CoreDataTableViewController<UISplitViewControllerDelegate>
- (void)transferSplitViewBarButtonItemToViewController:(id)destinationViewController;
@end
