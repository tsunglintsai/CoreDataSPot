//
//  RecentPhoto+Create.m
//  CoreDataSPot
//
//  Created by Henry on 3/9/13.
//  Copyright (c) 2013 Pyrogusto. All rights reserved.
//

#import "RecentPhoto+Create.h"
#import "Photo.h"
#import "PhotoDeleted+Create.h"

#define MAX_RECENT_PHOTO_COUNT 5

@implementation RecentPhoto (Create)

+ (RecentPhoto*) addPhoto:(Photo*) photo
     inManagedObjectContext:(NSManagedObjectContext *)context{

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"RecentPhoto"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"orderNumber" ascending:YES ]];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    NSMutableArray *recenPhotoList = [matches mutableCopy];
    
    // if photo already exist remove it.
    for(RecentPhoto *recentPhoto in recenPhotoList){
        if([recentPhoto.photo.photoId isEqual:photo.photoId]){
            [recenPhotoList removeObject:recentPhoto];
            [context deleteObject:recentPhoto];
            break;
        }
    }
    // if number exceed max number remove last one
    if([recenPhotoList count] >= MAX_RECENT_PHOTO_COUNT){ // limit number of photo in store
        RecentPhoto *recentPhoto = [recenPhotoList lastObject];
        [recenPhotoList removeObject:recentPhoto];
        [context deleteObject:recentPhoto];
    }
    // add photo to top
    RecentPhoto *recentPhoto = [NSEntityDescription insertNewObjectForEntityForName:@"RecentPhoto" inManagedObjectContext:context];
    recentPhoto.photo = photo;
    recentPhoto.orderNumber = @(1);
    [recenPhotoList insertObject:recentPhoto atIndex:0];
    // re-assgin index
    int count = 1;
    for(RecentPhoto *recentPhoto in recenPhotoList){
        recentPhoto.orderNumber = @(count++);
    }
    return recentPhoto;
}
@end
