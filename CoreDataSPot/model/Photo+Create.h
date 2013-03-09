//
//  Photo+Create.h
//  CoreDataSPot
//
//  Created by Daniela on 3/7/13.
//  Copyright (c) 2013 Pyrogusto. All rights reserved.
//

#import "Photo.h"

@interface Photo (Create)
+ (Photo *)photoWithTitle:(NSString *)title
                 subtitle:(NSString*)subtitle
                imageMURL:(NSString*)imageMURL
                imageHURL:(NSString*)imageHURL
                imageSURL:(NSString*)imageSURL
                  photoId:(NSNumber*)photoId
   inManagedObjectContext:(NSManagedObjectContext *)context;
@end
