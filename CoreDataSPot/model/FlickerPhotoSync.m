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
        [context performBlockAndWait:^{
            NSNumberFormatter *f = [[NSNumberFormatter alloc]init];
            [f setNumberStyle:NSNumberFormatterNoStyle];
            for( id photoData in [FlickrFetcher stanfordPhotos]){
                if([photoData isKindOfClass:[NSDictionary class]]){
                    [Photo photoFlickrPhoto:photoData inManagedObjectContext:context];
                }
            }
            [context save:nil];
        }];
        block();
    }];
}


@end
