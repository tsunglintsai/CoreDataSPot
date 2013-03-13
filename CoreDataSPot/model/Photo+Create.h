//
//  Photo+Create.h
//  CoreDataSPot
//
//  Created by Daniela on 3/7/13.
//  Copyright (c) 2013 Pyrogusto. All rights reserved.
//

#import "Photo.h"

#define ALL_PHOTO_TAG_NAME @"All"

@interface Photo (Create)
+ (Photo *)photoFlickrPhoto:(NSDictionary *)flickrPhoto
   inManagedObjectContext:(NSManagedObjectContext *)context;

+ (void)deletePhotoFlickrPhoto:(Photo*)flickrPhoto
     inManagedObjectContext:(NSManagedObjectContext *)context;
@end
