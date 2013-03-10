//
//  Photo.h
//  CoreDataSPot
//
//  Created by Daniela on 3/9/13.
//  Copyright (c) 2013 Pyrogusto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RecentPhoto, Tag;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * imageHURL;
@property (nonatomic, retain) NSString * imageMURL;
@property (nonatomic, retain) NSString * imageSURL;
@property (nonatomic, retain) NSString * photoId;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSData * thumbnail;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * isSoftDeleted;
@property (nonatomic, retain) RecentPhoto *recent;
@property (nonatomic, retain) NSSet *tags;
@end

@interface Photo (CoreDataGeneratedAccessors)

- (void)addTagsObject:(Tag *)value;
- (void)removeTagsObject:(Tag *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

@end
