//
//  RecentPhotos.h
//  CoreDataSPot
//
//  Created by Daniela on 3/7/13.
//  Copyright (c) 2013 Pyrogusto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo;

@interface RecentPhotos : NSManagedObject

@property (nonatomic, retain) NSOrderedSet *list;
@end

@interface RecentPhotos (CoreDataGeneratedAccessors)

- (void)insertObject:(Photo *)value inListAtIndex:(NSUInteger)idx;
- (void)removeObjectFromListAtIndex:(NSUInteger)idx;
- (void)insertList:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeListAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInListAtIndex:(NSUInteger)idx withObject:(Photo *)value;
- (void)replaceListAtIndexes:(NSIndexSet *)indexes withList:(NSArray *)values;
- (void)addListObject:(Photo *)value;
- (void)removeListObject:(Photo *)value;
- (void)addList:(NSOrderedSet *)values;
- (void)removeList:(NSOrderedSet *)values;
@end
