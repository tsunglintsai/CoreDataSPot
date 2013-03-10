//
//  Photo+Create.m
//  CoreDataSPot
//
//  Created by Daniela on 3/7/13.
//  Copyright (c) 2013 Pyrogusto. All rights reserved.
//

#import "Photo+Create.h"
#import "FlickrFetcher.h"
#import "Tag+Create.h"

#define INVALID_TAGS @[@"cs193pspot", @"portrait" , @"landscape" ]

@implementation Photo (Create)

+ (Photo *)photoFlickrPhoto:(NSDictionary *)flickrPhoto
     inManagedObjectContext:(NSManagedObjectContext *)context{
    Photo *photo = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"photoId" ascending:YES ]];
    request.predicate = [NSPredicate predicateWithFormat:@"photoId = %@", [flickrPhoto valueForKeyPath:FLICKR_PHOTO_ID]];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    if (!matches || ([matches count] > 1)) {
        // handle error
        NSLog(@"ERROR:more than one match");
    } else if (![matches count]) {
        photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
        photo.title     = [flickrPhoto valueForKeyPath:FLICKR_PHOTO_TITLE];
        photo.subtitle  = [flickrPhoto valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
        photo.imageMURL = [[FlickrFetcher urlForPhoto:flickrPhoto format:FlickrPhotoFormatLarge]    absoluteString];
        photo.imageHURL = [[FlickrFetcher urlForPhoto:flickrPhoto format:FlickrPhotoFormatOriginal] absoluteString];
        photo.imageSURL = [[FlickrFetcher urlForPhoto:flickrPhoto format:FlickrPhotoFormatSquare]   absoluteString];
        photo.photoId   = [flickrPhoto valueForKeyPath:FLICKR_PHOTO_ID];
        photo.isSoftDeleted = @(NO);
        // assigne photo to tags
        NSArray *tags = [[flickrPhoto valueForKeyPath:FLICKR_TAGS] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        for( NSString *tagString in tags){
            if(![INVALID_TAGS containsObject:tagString]){ // remove those tags
                Tag *tag = [Tag tagWithName:tagString inManagedObjectContext:context];
                [photo addTagsObject:tag];
            }
        }
        //
        Tag *tag = [Tag tagWithName:@"All" inManagedObjectContext:context];
        [photo addTagsObject:tag];
        
    } else {
        photo = [matches lastObject];
        //NSLog(@"found photo entry in database");
    }
    if(error){
        NSLog(@"ERROR:%@",[error description]);
    }
    return photo;
}

@end
