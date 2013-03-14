//
//  RecentPhotosTVC.m
//  CoreDataSPot
//
//  Created by Daniela on 3/8/13.
//  Copyright (c) 2013 Pyrogusto. All rights reserved.
//

#import "RecentPhotosTVC.h"
#import "CoreDataHelper.h"

@interface RecentPhotosTVC ()

@end

@implementation RecentPhotosTVC
-(void)viewDidLoad{
    [super viewDidLoad];
    [[CoreDataHelper sharedInstance]executeBlock:^(NSManagedObjectContext *context) {
        self.managedObjectContext = context;
        [self performFetch];
    }];	
}

- (NSPredicate*)photoListPredicate{
    return [NSPredicate predicateWithFormat:@"lastView != nil"] ;
}

- (NSArray*) sortDescriptors{
    return @[[NSSortDescriptor sortDescriptorWithKey:@"lastView" ascending:NO]];
}

- (NSString*) sectionKeyPath{
    return nil;
}

- (NSUInteger)fetchLimit{
    return 5;
}
@end
