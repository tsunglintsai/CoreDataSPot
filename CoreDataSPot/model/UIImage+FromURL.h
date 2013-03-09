//
//  UIImage+FromURL.h
//  SPoT
//
//  Created by Daniela on 2/28/13.
//  Copyright (c) 2013 Pyrogusto Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageFetcher.h"

@interface UIImage (FromURL)
+ (UIImage *)imageFromURL:(NSURL *)url;
+ (UIImage *)imageFromURL:(NSURL *)url WithProgressBlock:(ProgressBlock)block;

@end
