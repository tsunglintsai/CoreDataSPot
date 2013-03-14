//
//  RecentPhoto.h
//  CoreDataSPot
//
//  Created by Henry on 3/14/13.
//  Copyright (c) 2013 Pyrogusto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo;

@interface RecentPhoto : NSManagedObject

@property (nonatomic, retain) NSDate * viewTime;
@property (nonatomic, retain) Photo *photo;

@end
