//
//  PhotoTagMap+Create.h
//  CoreDataSPot
//
//  Created by Daniela on 3/12/13.
//  Copyright (c) 2013 Pyrogusto. All rights reserved.
//

#import "PhotoTagMap.h"

@interface PhotoTagMap (Create)
+ (PhotoTagMap *)PhotoTagMapWithPhoto:(Photo *) photo withTag:(Tag*)tag
               inManagedObjectContext:(NSManagedObjectContext *)context;
@end
