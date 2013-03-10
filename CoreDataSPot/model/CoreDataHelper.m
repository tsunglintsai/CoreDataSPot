//
//  CoreDataHelper.m
//  CoreDataSPot
//
//  Created by Daniela on 3/7/13.
//  Copyright (c) 2013 Pyrogusto. All rights reserved.
//

#import "CoreDataHelper.h"
#import "MyUIManagedDocument.h"

@interface CoreDataHelper()
@property (strong, nonatomic) UIManagedDocument *document;
@end

@implementation CoreDataHelper

+(id) sharedInstance{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc]init];
    });
    return sharedInstance;
}


- (void) executeBlock:(completion_block_t)completionBlock{
    if(self.document && self.document.documentState == UIDocumentStateNormal){ // if document already in normal state execute block directly
        //NSLog(@"document is ready");
        completionBlock(self.document.managedObjectContext);
    }else{ // if document is not open then open it or create it
        NSURL *docURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        docURL = [docURL URLByAppendingPathComponent:@"core data"];
        self.document = [[MyUIManagedDocument alloc] initWithFileURL:docURL];
        if([[NSFileManager defaultManager] fileExistsAtPath:[docURL path]]){
            //NSLog(@"found dataDocument");
            [self.document openWithCompletionHandler:^(BOOL success){
                if(success){
                    if(self.document.documentState == UIDocumentStateNormal){
                        completionBlock(self.document.managedObjectContext);
                    }
                }
                if(!success)NSLog(@"couldn't open document at %@",docURL);
            }];
        }else{
            NSLog(@"dataDocument not found creating one...");
            [self.document saveToURL:docURL forSaveOperation:UIDocumentSaveForCreating completionHandler:
             ^(BOOL success){
                 if(success){
                     if(self.document.documentState == UIDocumentStateNormal){
                         completionBlock(self.document.managedObjectContext);
                     }
                 }
                 if(!success)NSLog(@"couldn't create document at %@",docURL);
             }];
        }
    }
}

-(id)init{
    self = [super init];
    if(self){
    }
    return self;
}




@end
