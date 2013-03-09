//
//  FlickerPhotoSync.m
//  CoreDataSPot
//
//  Created by Daniela on 3/7/13.
//  Copyright (c) 2013 Pyrogusto. All rights reserved.
//

#import "FlickerPhotoSync.h"
#import "CoreDataHelper.h"
#import "FlickrFetcher.h"
#import "Tag+Create.h"
#import "Photo+Create.h"

@interface FlickerPhotoSync()
@property (strong,nonatomic) NSArray *invalidTags;
@end

#define INVALID_TAGS @[@"cs193pspot", @"portrait" , @"landscape" ]

@implementation FlickerPhotoSync

+(id) sharedInstance{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc]init];
    });
    return sharedInstance;
}

+(void) syncWithCompletionHandler:(PhotoSyncCallBackBlock)block{
    // get flicker photo from internet
    [[CoreDataHelper sharedInstance]executeBlock:^(NSManagedObjectContext *context) {
        NSNumberFormatter *f = [[NSNumberFormatter alloc]init];
        [f setNumberStyle:NSNumberFormatterNoStyle];
        for( id photoData in [FlickrFetcher stanfordPhotos]){
            if([photoData isKindOfClass:[NSDictionary class]]){

                NSDictionary *photoDataDictionary = photoData;
                Photo *photo = [Photo photoWithTitle:[photoDataDictionary valueForKeyPath:FLICKR_PHOTO_TITLE]
                                            subtitle:[photoDataDictionary valueForKeyPath:FLICKR_PHOTO_DESCRIPTION]
                                           imageMURL:[[FlickrFetcher urlForPhoto:photoData format:FlickrPhotoFormatLarge] absoluteString]
                                           imageHURL:[[FlickrFetcher urlForPhoto:photoData format:FlickrPhotoFormatOriginal] absoluteString]
                                           imageSURL:[[FlickrFetcher urlForPhoto:photoData format:FlickrPhotoFormatSquare] absoluteString]
                                             photoId:[f numberFromString:[photoDataDictionary valueForKeyPath:FLICKR_PHOTO_ID]]
                              inManagedObjectContext:context];
                // assigne photo to tags
                NSArray *tags = [[photoDataDictionary valueForKeyPath:FLICKR_TAGS] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                for( NSString *tagString in tags){
                    if(![INVALID_TAGS containsObject:tagString]){ // remove those tags
                        Tag *tag = [Tag tagWithName:tagString inManagedObjectContext:context];
                        [photo addTagsObject:tag];
                    }
                }
            }
        }
        [context performBlockAndWait:^{
            [context save:nil];
        }];
        block();
    }];
}


@end
