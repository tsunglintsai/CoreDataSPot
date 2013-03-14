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

+(void) syncWithCompletionHandler:(PhotoSyncCallBackBlock)block inMnagedContext:(NSManagedObjectContext*)context{
    // get flicker photo from internet
    NSArray *photoList = [FlickrFetcher stanfordPhotos];
    [context performBlockAndWait:^{
        for( id photoData in photoList){
            if([photoData isKindOfClass:[NSDictionary class]]){
                [Photo photoFlickrPhoto:photoData inManagedObjectContext:context];
            }
        }
        NSError *error;
        [context save:&error];
        [[CoreDataHelper sharedInstance]saveDocument]; // somehow there is a delay in object saving to store. force context flush data back to store.
        NSLog(@"save called");
        if(error)NSLog(@"%@",error);
    }];
    block();
}


@end
