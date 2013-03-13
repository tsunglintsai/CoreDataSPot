//
//  PhotoTagMap+Create.m
//  CoreDataSPot
//
//  Created by Daniela on 3/12/13.
//  Copyright (c) 2013 Pyrogusto. All rights reserved.
//

#import "PhotoTagMap+Create.h"
#import "Photo.h"
#import "Tag.h"
#import "PhotoTagMap.h"

@implementation PhotoTagMap (Create)
+ (PhotoTagMap *)PhotoTagMapWithPhoto:(Photo *) photo withTag:(Tag*)tag
               inManagedObjectContext:(NSManagedObjectContext *)context{
    PhotoTagMap *photoTagMap = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"PhotoTagMap"];
    request.predicate = [NSPredicate predicateWithFormat:@"(tag.tagName = %@) AND ( photo.photoId = %@)", tag.tagName, photo.photoId];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    if (!matches || ([matches count] > 1)) {
        // handle error
        NSLog(@"ERROR:more than one match");
    } else if (![matches count]) {
        photoTagMap = [NSEntityDescription insertNewObjectForEntityForName:@"PhotoTagMap" inManagedObjectContext:context];
        photoTagMap.photo = photo;
        photoTagMap.tag = tag;
        //NSLog(@"create new PhotoTagMap entry in database");
    } else {
        photoTagMap = [matches lastObject];
        //NSLog(@"found PhotoTagMap entry in database");
    }
    if(error){
        NSLog(@"ERROR:%@",[error description]);
    }
    return photoTagMap;
}


@end
