//
//  TagPhotoListTVC.h
//  CoreDataSPot
//
//  Created by Henry on 3/9/13.
//  Copyright (c) 2013 Pyrogusto. All rights reserved.
//

#import "PhotoListTVC.h"
#import "Tag.h"

@interface TagPhotoListTVC : PhotoListTVC
@property (nonatomic, strong) Tag *tag;
@end
