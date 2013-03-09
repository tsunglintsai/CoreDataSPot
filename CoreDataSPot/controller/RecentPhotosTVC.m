//
//  RecentPhotosTVC.m
//  CoreDataSPot
//
//  Created by Daniela on 3/8/13.
//  Copyright (c) 2013 Pyrogusto. All rights reserved.
//

#import "RecentPhotosTVC.h"
#import "RecentPhotos+Create.h"
#import "CoreDataHelper.h"

@interface RecentPhotosTVC ()

@end

@implementation RecentPhotosTVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[CoreDataHelper sharedInstance]executeBlock:^(NSManagedObjectContext *context) {
        self.photos = [[[RecentPhotos recentPhotosInManagedObjectContext:context]list]array];
    }];
}

@end
