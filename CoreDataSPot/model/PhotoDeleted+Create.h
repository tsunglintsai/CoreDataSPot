//
//  PhotoDeleted+Create.h
//  CoreDataSPot
//
//  Created by Henry on 3/12/13.
//  Copyright (c) 2013 Pyrogusto. All rights reserved.
//

#import "PhotoDeleted.h"

@interface PhotoDeleted (Create)
+ (PhotoDeleted *)photoDeletedWithId:(NSString *)photoId inManagedObjectContext:(NSManagedObjectContext *)context;
+ (NSArray*)deletedPhotoIdListInManagedObjectContext:(NSManagedObjectContext *)context; // array of NSString contains photoId
@end
