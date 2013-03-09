//
//  Photo+Create.m
//  CoreDataSPot
//
//  Created by Daniela on 3/7/13.
//  Copyright (c) 2013 Pyrogusto. All rights reserved.
//

#import "Photo+Create.h"

@implementation Photo (Create)
+ (Photo *)photoWithTitle:(NSString *)title
                 subtitle:(NSString*)subtitle
                imageMURL:(NSString*)imageMURL
                imageHURL:(NSString*)imageHURL
                imageSURL:(NSString*)imageSURL
                  photoId:(NSNumber*)photoId
   inManagedObjectContext:(NSManagedObjectContext *)context{
    __block Photo *photo = nil;
    
    [context performBlockAndWait:^{
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
        request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"photoId" ascending:YES ]];
        request.predicate = [NSPredicate predicateWithFormat:@"photoId = %@", photoId];
        NSError *error;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        if (!matches || ([matches count] > 1)) {
            // handle error
            NSLog(@"ERROR:more than one match");
        } else if (![matches count]) {
            photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
            photo.title = title;
            photo.subtitle = subtitle;
            photo.imageMURL = imageMURL;
            photo.imageHURL = imageHURL;
            photo.imageSURL = imageSURL;
            photo.photoId = photoId;
            //NSLog(@"create new photo entry in database");
        } else {
            photo = [matches lastObject];
            //NSLog(@"found photo entry in database");
        }
        if(error){
            NSLog(@"ERROR:%@",[error description]);
        }
    }];
    return photo;
}
@end
