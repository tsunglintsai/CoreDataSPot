//
//  ImageFetcher.h
//  SPoT
//
//  Created by Daniela on 2/28/13.
//  Copyright (c) 2013 Pyrogusto Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageFetcher : NSObject

typedef void (^ProgressBlock)(long,long);

-(UIImage*)getImageFromURL:(NSURL*)url;
-(UIImage*)getImageFromURL:(NSURL*)url WithProgressBlock:(ProgressBlock)block;

@end
