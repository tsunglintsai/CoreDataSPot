//
//  PhotoListTVC.m
//  CoreDataSPot
//
//  Created by Daniela on 3/8/13.
//  Copyright (c) 2013 Pyrogusto. All rights reserved.
//

#import "PhotoListTVC.h"
#import "Photo.h"
#import "RecentPhotos+Create.h"
#import "CoreDataHelper.h"

@interface PhotoListTVC ()

@end

@implementation PhotoListTVC

// sets the Model
// reloads the UITableView (since Model is changing)

- (void)setPhotos:(NSArray *)photos{
    _photos = photos;
    [self.tableView reloadData];
}

// hide detail VC in portrait orientation / show it in landscape orientation
- (BOOL) splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return UIInterfaceOrientationIsPortrait(orientation);
}


// lets the UITableView know how many rows it should display
// in this case, just the count of dictionaries in the Model's array

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.photos count];
}

// a helper method that looks in the Model for the photo dictionary at the given row
//  and gets the title out of it

- (NSString *)titleForRow:(NSUInteger)row
{
    return [self.photos[row]title]; // description because could be NSNull
}

// a helper method that looks in the Model for the photo dictionary at the given row
//  and gets the owner of the photo out of it

- (NSString *)subtitleForRow:(NSUInteger)row
{
    return [self.photos[row] subtitle] ; // description because could be NSNull
}

// loads up a table view cell with the title and owner of the photo at the given row in the Model

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Flickr Photo";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    Photo *photo = [self.photos objectAtIndex:indexPath.row];

    // Configure the cell...
    cell.textLabel.text = [[self titleForRow:indexPath.row] capitalizedString];
    cell.detailTextLabel.text = [self subtitleForRow:indexPath.row];
    cell.tag = [photo.photoId intValue];
    if(!photo.thumbnail){ // if haven't downloaded thumbnail, then download it
        dispatch_async(dispatch_queue_create("edu.stanford", DISPATCH_QUEUE_SERIAL), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:photo.imageSURL]];
            [[CoreDataHelper sharedInstance]executeBlock:^(NSManagedObjectContext *context) {
                photo.thumbnail = imageData;
                [context save:nil];
                if(cell.tag == [photo.photoId intValue]){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"match");
                        cell.imageView.image = [UIImage imageWithData:photo.thumbnail];
                    });
                }else{
                    NSLog(@"doesn't match");
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
                    Photo *photo = [self.photos objectAtIndex:indexPath.row];
                    [[CoreDataHelper sharedInstance]executeBlock:^(NSManagedObjectContext *context) {
                        RecentPhotos *recentPhotos = [RecentPhotos recentPhotosInManagedObjectContext:context];
                        [recentPhotos addPhoto:photo];
                        [context save:nil];
                    }];
                    // make a switch between ipad and iphone
                    NSURL *url = [NSURL URLWithString:self.view.window.bounds.size.width > 500 ? photo.imageHURL : photo.imageMURL];
                    [segue.destinationViewController performSelector:@selector(setImageURL:) withObject:url];
                    [segue.destinationViewController setTitle:[[self titleForRow:indexPath.row] capitalizedString]];
                }
            }
        }
    }
    
}
@end
