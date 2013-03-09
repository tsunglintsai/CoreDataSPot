//
//  Photo+Create.h
//  CoreDataSPot
//
//  Created by Daniela on 3/7/13.
//  Copyright (c) 2013 Pyrogusto. All rights reserved.
//

#import "Photo.h"

@interface Photo (Create)
+ (Photo *)photoFlickrPhoto:(NSDictionary *)flickrPhoto
   inManagedObjectContext:(NSManagedObjectContext *)context;
@end
