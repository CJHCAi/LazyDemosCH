//
//  EquipmentEditViewController.h
//  SportForum
//
//  Created by liyuan on 4/3/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

enum
{
    EQUIP_TYPE_EDIT_SHOES = 0,
    EQUIP_TYPE_EDIT_DEVICE = 1,
    EQUIP_TYPE_EDIT_APP = 2,
};

@interface EquipmentEditViewController : BaseViewController

@property(nonatomic, copy) NSString* strTitle;
@property(nonatomic, assign) NSUInteger nEquipType;
@property(nonatomic, copy) NSString* strEquipName;

@end
