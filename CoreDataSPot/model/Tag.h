//
//  Tag.h
//  CoreDataSPot
//
//  Created by Henry on 3/16/13.
//  Copyright (c) 2013 Pyrogusto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo, PhotoTagMap;

@interface Tag : NSManagedObject

@property (nonatomic, retain) NSString * tagName;
@property (nonatomic, retain) NSSet *photos;
@property (nonatomic, retain) NSSet *photoTagMap;
@end

@interface Tag (CoreDataGeneratedAccessors)

- (void)addPhotosObject:(Photo *)value;
- (void)removePhotosObject:(Photo *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

- (void)addPhotoTagMapObject:(PhotoTagMap *)value;
- (void)removePhotoTagMapObject:(PhotoTagMap *)value;
- (void)addPhotoTagMap:(NSSet *)values;
- (void)removePhotoTagMap:(NSSet *)values;

@end
