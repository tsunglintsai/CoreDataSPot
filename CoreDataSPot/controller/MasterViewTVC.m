//
//  MasterViewTVC.m
//  SPoT
//
//  Created by Henry on 2/25/13.
//  Copyright (c) 2013 Pyrogusto Studio. All rights reserved.
//

#import "MasterViewTVC.h"


@interface MasterViewTVC ()<UITableViewDelegate>

@end

@implementation MasterViewTVC


#pragma mark - UISplitViewControllerDelegate

- (BOOL) splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return UIInterfaceOrientationIsPortrait(orientation);
}

- (void) awakeFromNib
{
    self.splitViewController.delegate = self;
}

- (void) viewDidLoad{
    [super viewDidLoad];
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{   
    barButtonItem.title = @"Photos";
    id detailViewController = [self.splitViewController.viewControllers lastObject];
    if ([detailViewController respondsToSelector:@selector(setSplitViewBarButtonItem:)])
        [detailViewController performSelector:@selector(setSplitViewBarButtonItem:) withObject:barButtonItem];
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    id detailViewController = [self.splitViewController.viewControllers lastObject];
    if ([detailViewController respondsToSelector:@selector(setSplitViewBarButtonItem:)])
        [detailViewController performSelector:@selector(setSplitViewBarButtonItem:) withObject:nil];
}

# pragma mark - Split view: transfer button

- (id)splitViewDetailWithBarButtonItem
{
    id detailViewController = [self.splitViewController.viewControllers lastObject];
    if (![detailViewController respondsToSelector:@selector(setSplitViewBarButtonItem:)] ||
        ![detailViewController respondsToSelector:@selector(splitViewBarButtonItem)]) detailViewController = nil;
    return detailViewController;
}

- (void)transferSplitViewBarButtonItemToViewController:(id)destinationViewController
{
    UIBarButtonItem *splitViewBarButtonItem = [[self splitViewDetailWithBarButtonItem] performSelector:@selector(splitViewBarButtonItem)];
    [[self splitViewDetailWithBarButtonItem] performSelector:@selector(setSplitViewBarButtonItem:) withObject:nil];
    if (splitViewBarButtonItem)
        [destinationViewController performSelector:@selector(setSplitViewBarButtonItem:) withObject:splitViewBarButtonItem];
}


@end
