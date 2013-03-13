//
//  PhotoDeleted+Create.m
//  CoreDataSPot
//
//  Created by Henry on 3/12/13.
//  Copyright (c) 2013 Pyrogusto. All rights reserved.
//

#import "PhotoDeleted+Create.h"

@implementation PhotoDeleted (Create)
+ (PhotoDeleted *)photoDeletedWithId:(NSString *)photoId
              inManagedObjectContext:(NSManagedObjectContext *)context{
    PhotoDeleted *photoDeleted = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"PhotoDeleted"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"photoId" ascending:YES ]];
    request.predicate = [NSPredicate predicateWithFormat:@"photoId = %@", photoId];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    if (!matches || ([matches count] > 1)) {
        // handle error
        NSLog(@"ERROR:more than one match");
    } else if (![matches count]) {
        photoDeleted = [NSEntityDescription insertNewObjectForEntityForName:@"PhotoDeleted" inManagedObjectContext:context];
        photoDeleted.photoId = photoId;
        
    } else {
        photoDeleted = [matches lastObject];
        //NSLog(@"found photo entry in database");
    }
    if(error){
        NSLog(@"ERROR:%@",[error description]);
    }
    return photoDeleted;
}

+ (NSArray*)deletedPhotoIdListInManagedObjectContext:(NSManagedObjectContext *)context{ // array of NSString contains photoId
    NSMutableArray *result = [[NSMutableArray alloc]init];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"PhotoDeleted"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"photoId" ascending:YES ]];
    NSError *error;
    for(PhotoDeleted *photo in [context executeFetchRequest:request error:&error]){
        [result addObject:photo.photoId];
    }
    return [result copy];
}
@end
