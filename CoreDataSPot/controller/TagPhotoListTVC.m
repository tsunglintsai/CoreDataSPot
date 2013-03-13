//
//  TagPhotoListTVC.m
//  CoreDataSPot
//
//  Created by Henry on 3/9/13.
//  Copyright (c) 2013 Pyrogusto. All rights reserved.
//

#import "TagPhotoListTVC.h"
#import "Photo.h"
#import "Photo+Create.h"
#import "PhotoTagMap.h"

@interface TagPhotoListTVC ()

@end

@implementation TagPhotoListTVC

- (void)viewDidLoad{
    [super viewDidLoad];
}

- (NSPredicate*)photoListPredicate{
    return [self.tag.tagName isEqualToString:ALL_PHOTO_TAG_NAME] ?
    [NSPredicate predicateWithFormat:@"photo != nil"] :
    [NSPredicate predicateWithFormat:@"tags.tagName CONTAINS %@", self.tag.tagName] ;
}

-(NSString*) entityName{
    return [self.tag.tagName isEqualToString:ALL_PHOTO_TAG_NAME] ? @"PhotoTagMap" : @"Photo";
}

- (NSArray*) sortDescriptors{
    return [self.tag.tagName isEqualToString:ALL_PHOTO_TAG_NAME] ?
    @[[NSSortDescriptor sortDescriptorWithKey:@"tag.tagName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]] :
    @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]] ;
}

- (void)setTag:(Tag *)tag{
    _tag = tag;
}

- (NSString*) sectionKeyPath{
    return [self.tag.tagName isEqualToString:ALL_PHOTO_TAG_NAME] ? @"tag.tagName" : @"title.stringGroupByFirstInitial";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        Photo *photo = [self getPhotoFromEntity:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        [self.managedObjectContext performBlock:^{ // perform soft delete
            [Photo deletePhotoFlickrPhoto:photo inManagedObjectContext:self.managedObjectContext];
            NSError *error;
            [self.managedObjectContext save:&error];
            if(error){
                NSLog(@"%@",error);
            }
        }];
    }
}

-(NSPredicate*)searchPredicateWithSeachString:(NSString*)searchString{
    return [self.tag.tagName isEqualToString:ALL_PHOTO_TAG_NAME] ?
    [NSPredicate predicateWithFormat:@"(photo.subtitle CONTAINS[cd] %@) OR (photo.title contains[cd] %@)", searchString , searchString] :
    [NSPredicate predicateWithFormat:@"(tags.tagName CONTAINS[cd] %@)  AND (title contains[cd] %@)", self.tag.tagName, searchString] ;
}

-(Photo*) getPhotoFromEntity:(NSManagedObject*)entity{
    Photo *result;
    if([entity isKindOfClass:[Photo class]]){
        result = (Photo*) entity;
    }else if([entity isKindOfClass:[PhotoTagMap class]]){
        PhotoTagMap *photoTagMap = (PhotoTagMap*)entity;
        result = photoTagMap.photo;
    }
    return result;
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
    NSPredicate *predicate = nil;
    if ([searchString length]){
        predicate = [self searchPredicateWithSeachString:searchString];
    }
    [self.fetchedResultsController.fetchRequest setPredicate:predicate];
    [self performFetch];
    
    return YES;
}

@end
