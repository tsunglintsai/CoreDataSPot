//
//  RecentPhoto.h
//  CoreDataSPot
//
//  Created by Daniela on 3/9/13.
//  Copyright (c) 2013 Pyrogusto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo;

@interface RecentPhoto : NSManagedObject

@property (nonatomic, retain) NSNumber * orderNumber;
@property (nonatomic, retain) Photo *photo;

@end
