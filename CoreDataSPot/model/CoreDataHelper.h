//
//  CoreDataHelper.h
//  CoreDataSPot
//
//  Created by Daniela on 3/7/13.
//  Copyright (c) 2013 Pyrogusto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataHelper : NSObject

typedef void (^completion_block_t)(NSManagedObjectContext *context);

+(id) sharedInstance;
- (void) executeBlock:(completion_block_t)completionBlock;
- (void) saveDocument;
@end
