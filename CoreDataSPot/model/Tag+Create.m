//
//  Tag+Create.m
//  CoreDataSPot
//
//  Created by Daniela on 3/7/13.
//  Copyright (c) 2013 Pyrogusto. All rights reserved.
//

#import "Tag+Create.h"

@implementation Tag (Create)
+ (Tag *)tagWithName:(NSString *)name
inManagedObjectContext:(NSManagedObjectContext *)context{
    Tag *tag = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"tagName" ascending:YES ]];
    request.predicate = [NSPredicate predicateWithFormat:@"tagName = %@", name];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    if (!matches || ([matches count] > 1)) {
        // handle error
        NSLog(@"ERROR:more than one match");
    } else if (![matches count]) {
        tag = [NSEntityDescription insertNewObjectForEntityForName:@"Tag" inManagedObjectContext:context];
        tag.tagName = name;
        //NSLog(@"create new tag entry in database");
    } else {
        tag = [matches lastObject];
        //NSLog(@"found tag entry in database");
    }
    if(error){
        NSLog(@"ERROR:%@",[error description]);
    }
    return tag;
}


@end
