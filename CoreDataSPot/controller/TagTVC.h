//
//  TagTVC.h
//  SPoT
//
//  Created by Henry on 2/24/13.
//  Copyright (c) 2013 Pyrogusto Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterViewTVC.h"

@interface TagTVC : MasterViewTVC

// The Model for this class.
// Essentially specifies the database to look in to find all Photographers to display in this table.
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end
