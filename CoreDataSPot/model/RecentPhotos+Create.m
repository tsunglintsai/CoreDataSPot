//
//  RecentPhotos+Create.m
//  CoreDataSPot
//
//  Created by Daniela on 3/8/13.
//  Copyright (c) 2013 Pyrogusto. All rights reserved.
//

#import "RecentPhotos+Create.h"
#define MAX_RECENT_PHOTO_COUNT 5

@implementation RecentPhotos (Create)
+ (RecentPhotos *) recentPhotosInManagedObjectContext:(NSManagedObjectContext *)context{
    __block RecentPhotos *recentPhotos = nil;
    [context performBlockAndWait:^{
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"RecentPhotos"];
        NSError *error;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        if (!matches || ([matches count] > 1)) {
            // handle error
            NSLog(@"ERROR:more than one match");
        } else if (![matches count]) {
            recentPhotos = [NSEntityDescription insertNewObjectForEntityForName:@"RecentPhotos" inManagedObjectContext:context];
            NSLog(@"create new RecentPhotos entry in database");
        } else {
            recentPhotos = [matches lastObject];
            NSLog(@"found RecentPhotos entry in database");
        }
        if(error){
            NSLog(@"ERROR:%@",[error description]);
        }
    }];
    return recentPhotos;
}

- (void) addPhoto:(Photo*)photo{
    NSMutableArray *recenPhotoList = [[self.list array]mutableCopy];
    if(![recenPhotoList containsObject:photo]){ // don't put duplicated picture
        if([recenPhotoList count] >= MAX_RECENT_PHOTO_COUNT){ // limit number of photo in store
            [recenPhotoList removeObject:[recenPhotoList lastObject]];
        }
    }else{ // if already exist put photo to top of list
        [recenPhotoList removeObject:photo];
    }
    [recenPhotoList insertObject:photo atIndex:0];
    self.list = [NSOrderedSet orderedSetWithArray:[recenPhotoList copy]];
}

@end
