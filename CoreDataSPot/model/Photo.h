//
//  Photo.h
//  CoreDataSPot
//
//  Created by Henry on 3/12/13.
//  Copyright (c) 2013 Pyrogusto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PhotoTagMap, RecentPhoto, Tag;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * imageHURL;
@property (nonatomic, retain) NSString * imageMURL;
@property (nonatomic, retain) NSString * imageSURL;
@property (nonatomic, retain) NSString * photoId;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSData * thumbnail;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *photoTagMap;
@property (nonatomic, retain) RecentPhoto *recent;
@property (nonatomic, retain) NSSet *tags;
@end

@interface Photo (CoreDataGeneratedAccessors)

- (void)addPhotoTagMapObject:(PhotoTagMap *)value;
- (void)removePhotoTagMapObject:(PhotoTagMap *)value;
- (void)addPhotoTagMap:(NSSet *)values;
- (void)removePhotoTagMap:(NSSet *)values;

- (void)addTagsObject:(Tag *)value;
- (void)removeTagsObject:(Tag *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

@end
