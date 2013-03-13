//
//  FlickerPhotoSync.h
//  CoreDataSPot
//
//  Created by Daniela on 3/7/13.
//  Copyright (c) 2013 Pyrogusto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickerPhotoSync : NSObject

typedef void (^PhotoSyncCallBackBlock)(void);

+(id) sharedInstance;
+(void) syncWithCompletionHandler:(PhotoSyncCallBackBlock)block inMnagedContext:(NSManagedObjectContext*)context;
@end
