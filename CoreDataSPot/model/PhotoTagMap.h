//
//  PhotoTagMap.h
//  CoreDataSPot
//
//  Created by Henry on 3/14/13.
//  Copyright (c) 2013 Pyrogusto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo, Tag;

@interface PhotoTagMap : NSManagedObject

@property (nonatomic, retain) Photo *photo;
@property (nonatomic, retain) Tag *tag;

@end
