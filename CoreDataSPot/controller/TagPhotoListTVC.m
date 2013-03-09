//
//  TagPhotoListTVC.m
//  CoreDataSPot
//
//  Created by Henry on 3/9/13.
//  Copyright (c) 2013 Pyrogusto. All rights reserved.
//

#import "TagPhotoListTVC.h"

@interface TagPhotoListTVC ()

@end

@implementation TagPhotoListTVC

- (void)viewDidLoad{
    [super viewDidLoad];
    self.photoListPredicate = [NSPredicate predicateWithFormat:@"tags.tagName CONTAINS %@", self.tag.tagName];
}

- (void)setTag:(Tag *)tag{
    _tag = tag;
}

@end
