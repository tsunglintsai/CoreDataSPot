//
//  PhotoListTVC.h
//  CoreDataSPot
//
//  Created by Daniela on 3/8/13.
//  Copyright (c) 2013 Pyrogusto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterViewTVC.h"

@interface PhotoListTVC : MasterViewTVC
// The Model for this class.
// Essentially specifies the database to look in to find all Photographers to display in this table.
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSPredicate *photoListPredicate; // predicate to filter photo needed
@property (nonatomic, strong) NSArray *sortDescriptors; // array of NSSortDescriptor describing how photo been sorted
@property (nonatomic, strong) NSString *sectionKeyPath;
@property (nonatomic, strong) NSString *entityName;
@property (nonatomic) NSUInteger fetchLimit;
@end
