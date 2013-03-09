//
//  Photo.h
//  CoreDataSPot
//
//  Created by Henry on 3/9/13.
//  Copyright (c) 2013 Pyrogusto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RecentPhoto, Tag;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * imageHURL;
@property (nonatomic, retain) NSString * imageMURL;
@property (nonatomic, retain) NSString * imageSURL;
@property (nonatomic, retain) NSNumber * photoId;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSData * thumbnail;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *tags;
@property (nonatomic, retain) RecentPhoto *recent;
@end

@interface Photo (CoreDataGeneratedAccessors)

- (void)addTagsObject:(Tag *)value;
- (void)removeTagsObject:(Tag *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

@end
