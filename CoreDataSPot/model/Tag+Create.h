//
//  Tag+Create.h
//  CoreDataSPot
//
//  Created by Daniela on 3/7/13.
//  Copyright (c) 2013 Pyrogusto. All rights reserved.
//

#import "Tag.h"

@interface Tag (Create)
+ (Tag *)tagWithName:(NSString *)name
inManagedObjectContext:(NSManagedObjectContext *)context;
@end
