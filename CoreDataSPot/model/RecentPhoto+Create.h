//
//  RecentPhoto+Create.h
//  CoreDataSPot
//
//  Created by Henry on 3/9/13.
//  Copyright (c) 2013 Pyrogusto. All rights reserved.
//

#import "RecentPhoto.h"

@interface RecentPhoto (Create)
+ (RecentPhoto*) addPhoto:(Photo*) photo
inManagedObjectContext:(NSManagedObjectContext *)context;
@end
