//
//  RecentPhotos+Create.h
//  CoreDataSPot
//
//  Created by Daniela on 3/8/13.
//  Copyright (c) 2013 Pyrogusto. All rights reserved.
//

#import "RecentPhotos.h"

@interface RecentPhotos (Create)
+ (RecentPhotos*) recentPhotosInManagedObjectContext:(NSManagedObjectContext *)context;
- (void) addPhoto:(Photo*)photo;
@end
