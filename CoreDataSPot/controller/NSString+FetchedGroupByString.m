//
//  NSString+FetchedGroupByString.m
//  CoreDataSPot
//
//  Created by Daniela on 3/9/13.
//  Copyright (c) 2013 Pyrogusto. All rights reserved.
//

#import "NSString+FetchedGroupByString.h"
#import "Photo+Create.h"

@implementation NSString (FetchedGroupByString)
- (NSString *)stringGroupByFirstInitial {
    if (!self.length || self.length == 1)
        return self;
    return [self substringToIndex:1];
}

@end
