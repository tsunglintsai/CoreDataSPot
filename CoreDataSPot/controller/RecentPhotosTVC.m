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
    self.photoListPredicate = [NSPredicate predicateWithFormat:@"recent != nil"];
    self.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"recent.orderNumber" ascending:YES]];
    [[CoreDataHelper sharedInstance]executeBlock:^(NSManagedObjectContext *context) {
        self.managedObjectContext = context;
    }];

}

@end
