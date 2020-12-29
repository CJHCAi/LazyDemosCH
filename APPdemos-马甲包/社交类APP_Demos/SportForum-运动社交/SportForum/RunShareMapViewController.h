//
//  RunShareMapViewController.h
//  SportForum
//
//  Created by liyuan on 7/13/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface RunShareMapViewController : BaseViewController

@property(assign, nonatomic) float longitude;
@property(assign, nonatomic) float latitude;

@property(strong, nonatomic) NSString* strAddress;

@end
