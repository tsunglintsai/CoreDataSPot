//
//  TagPhotoListTVC.m
//  CoreDataSPot
//
//  Created by Henry on 3/9/13.
//  Copyright (c) 2013 Pyrogusto. All rights reserved.
//

#import "TagPhotoListTVC.h"
#import "Photo.h"

@interface TagPhotoListTVC ()

@end

@implementation TagPhotoListTVC

- (void)viewDidLoad{
    [super viewDidLoad];
}

- (NSPredicate*)photoListPredicate{
    return [NSPredicate predicateWithFormat:@"(tags.tagName CONTAINS %@) AND (isSoftDeleted == NO)", self.tag.tagName];
}

- (void)setTag:(Tag *)tag{
    _tag = tag;
}

- (NSString*) sectionKeyPath{
    
    return @"title.stringGroupByFirstInitial";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If row is deleted, remove it from the list.
    if (editingStyle == UITableViewCellEditingStyleDelete){
        Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.managedObjectContext performBlock:^{
            photo.isSoftDeleted = @(YES);
        }];
    }
}

#pragma mark - SearchViewControl Delegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    NSInteger searchOption = controller.searchBar.selectedScopeButtonIndex;
    return [self searchDisplayController:controller shouldReloadTableForSearchString:searchString searchScope:searchOption];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    NSString* searchString = controller.searchBar.text;
    return [self searchDisplayController:controller shouldReloadTableForSearchString:searchString searchScope:searchOption];
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView{
    [self.fetchedResultsController.fetchRequest setPredicate:self.photoListPredicate];
    [self performFetch];    
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString*)searchString searchScope:(NSInteger)searchOption {
    NSLog(@"shouldReloadTableForSearchString");
    
    NSPredicate *predicate = nil;
    if ([searchString length]){
        if (searchOption == 0){ // full text, in my implementation.  Other scope button titles are "Author", "Title"
            predicate = [NSPredicate predicateWithFormat:@"(tags.tagName CONTAINS %@) AND (isSoftDeleted == NO) AND (title contains[cd] %@)", self.tag.tagName, searchString];
        } else {
            // docs say keys are case insensitive, but apparently not so.
            predicate =  [NSPredicate predicateWithFormat:@"(tags.tagName CONTAINS %@) AND (isSoftDeleted == NO)", self.tag.tagName];
        }
    }
    [self.fetchedResultsController.fetchRequest setPredicate:predicate];
    [self performFetch];
    
    return YES;
}

@end
