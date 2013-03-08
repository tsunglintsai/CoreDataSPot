//
//  Photo.h
//  CoreDataSPot
//
//  Created by Daniela on 3/7/13.
//  Copyright (c) 2013 Pyrogusto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Photo : NSManagedObject

@property (nonatomic, retain) NSData * thumbnail;
@property (nonatomic, retain) NSString * imageMURL;
@property (nonatomic, retain) NSString * photoDescription;
@property (nonatomic, retain) NSNumber * photoId;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSString * imageHURL;

@end
