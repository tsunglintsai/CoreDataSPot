//
//  PhotoListTVC.m
//  CoreDataSPot
//
//  Created by Daniela on 3/8/13.
//  Copyright (c) 2013 Pyrogusto. All rights reserved.
//

#import "PhotoListTVC.h"
#import "Photo.h"
#import "CoreDataHelper.h"
#import "RecentPhoto+Create.h"

@interface PhotoListTVC ()

@end

@implementation PhotoListTVC

// hide detail VC in portrait orientation / show it in landscape orientation
- (BOOL) splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation{
    return UIInterfaceOrientationIsPortrait(orientation);
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext{
    _managedObjectContext = managedObjectContext;
    if (managedObjectContext) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
        request.sortDescriptors = self.sortDescriptors;
        request.predicate = self.photoListPredicate;
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    } else {
        self.fetchedResultsController = nil;
    }
}

- (NSArray*) sortDescriptors{
    if(!_sortDescriptors){
        _sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    }
    return _sortDescriptors;
}

// loads up a table view cell with the title and owner of the photo at the given row in the Model

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Flickr Photo";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];

    // Configure the cell...
    cell.textLabel.text = photo.title;
    cell.detailTextLabel.text = photo.subtitle;
    cell.tag = [photo.photoId intValue];
    cell.imageView.image = [UIImage imageNamed:@"placeholder.png"]; //set it empty, or it will show resued cell image.
    if(!photo.thumbnail){ // if haven't downloaded thumbnail, then download it
        dispatch_async(dispatch_queue_create("edu.stanford", DISPATCH_QUEUE_SERIAL), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:photo.imageSURL]];
            [self.managedObjectContext performBlock:^{
                photo.thumbnail = imageData;
                if(cell.tag == [photo.photoId intValue]){ // if it doesn't match means cell got reused for other photo
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.imageView.image = [UIImage imageWithData:photo.thumbnail];
                    });
                }
            }];
        });
    }else{
        cell.imageView.image = [UIImage imageWithData:photo.thumbnail];        
    }
    
    return cell;
}

#pragma mark - Segue

// prepares for the "Show Image" segue by seeing if the destination view controller of the segue
//  understands the method "setImageURL:"
// if it does, it sends setImageURL: to the destination view controller with
//  the URL of the photo that was selected in the UITableView as the argument
// also sets the title of the destination view controller to the photo's title
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"Show Image"]) {
                if ([segue.destinationViewController respondsToSelector:@selector(setImageURL:)]) {
                    [self transferSplitViewBarButtonItemToViewController:segue.destinationViewController];
                    Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
                    [self.managedObjectContext performBlockAndWait:^{
                        RecentPhoto *recentPhoto = [RecentPhoto addPhoto:photo inManagedObjectContext:self.managedObjectContext];
                        NSLog(@"%@",recentPhoto);
                        [self.managedObjectContext save:nil];
                    }];
                    // make a switch between ipad and iphone
                    NSURL *url = [NSURL URLWithString: self.view.window.bounds.size.width > 500 ? photo.imageHURL : photo.imageMURL];
                    [segue.destinationViewController performSelector:@selector(setImageURL:) withObject:url];
                    [segue.destinationViewController setTitle:[photo.title capitalizedString]];
                }
            }
        }
    }
    
}
@end
