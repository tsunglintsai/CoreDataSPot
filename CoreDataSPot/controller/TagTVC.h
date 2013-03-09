//
//  TagTVC.h
//  SPoT
//
//  Created by Henry on 2/24/13.
//  Copyright (c) 2013 Pyrogusto Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterViewTVC.h"
//#import "FlickrPhotoTVC.h"

//@interface TagTVC : MasterViewTVC<FlickrPhotoTVCDelegate>
@interface TagTVC : MasterViewTVC
@property (nonatomic,strong) NSArray *tagList; // list of Tag object
@end
