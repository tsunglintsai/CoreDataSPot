//
//  TagTVC.m
//  SPoT
//
//  Created by Henry on 2/24/13.
//  Copyright (c) 2013 Pyrogusto Studio. All rights reserved.
//

#import "TagTVC.h"
#import "Tag.h"
#import "Photo.h"

@interface TagTVC ()
@end

@implementation TagTVC

// The Model for this class.
//
// When it gets set, we create an NSFetchRequest to get all Photographers in the database associated with it.
// Then we hook that NSFetchRequest up to the table view using an NSFetchedResultsController.

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext{
    _managedObjectContext = managedObjectContext;
    if (managedObjectContext) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"tagName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
        request.predicate = nil; // 
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedObjectContext sectionNameKeyPath:@"tagName.stringGroupByFirstInitial" cacheName:nil];
    } else {
        self.fetchedResultsController = nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{    
    static NSString *CellIdentifier = @"TagCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    Tag *tag = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [tag.tagName capitalizedString];
    NSUInteger photoCount = [self photoCount:[tag.photos allObjects]];
    cell.detailTextLabel.text = [@[ @(photoCount) , photoCount > 1 ? @"photos":@"photo"] componentsJoinedByString:@" "];
    return cell;
}

- (NSUInteger) photoCount:(NSArray*) photoList{
    NSUInteger result = 0 ;
    for(Photo *photo in photoList){
        if(photo.isSoftDeleted == @(NO) ){
            result++;
        }
    }
    return result;
}

- (void) awakeFromNib{
    [super awakeFromNib];
    self.splitViewController.delegate = self;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"Push To Photo List"]) {
                if ([segue.destinationViewController respondsToSelector:@selector(setTag:)]) {
                    Tag *tag = [self.fetchedResultsController objectAtIndexPath:indexPath];
                    [segue.destinationViewController performSelector:@selector(setTag:) withObject:tag];
                }
                if ([segue.destinationViewController respondsToSelector:@selector(setManagedObjectContext:)]) {
                    [segue.destinationViewController performSelector:@selector(setManagedObjectContext:) withObject:self.managedObjectContext];
                }
            }
        }
    }
}
@end
