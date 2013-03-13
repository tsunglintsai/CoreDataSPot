//
//  PhotoTagMap.h
//  CoreDataSPot
//
//  Created by Daniela on 3/13/13.
//  Copyright (c) 2013 Pyrogusto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo, Tag;

@interface PhotoTagMap : NSManagedObject

@property (nonatomic, retain) Photo *photo;
@property (nonatomic, retain) Tag *tag;

@end
