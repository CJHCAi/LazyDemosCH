//
//  EquipmentChooseViewController.h
//  SportForum
//
//  Created by liyuan on 4/3/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import <UIKit/UIKit.h>

enum
{
    EQUIP_TYPE_SHOES = 0,
    EQUIP_TYPE_SHOES_OTHER = 1,
    EQUIP_TYPE_DEVICE = 2,
    EQUIP_TYPE_DEVICE_OTHER = 3,
    EQUIP_TYPE_APP = 4,
    EQUIP_TYPE_APP_OTHER = 5,
};

@interface EquipmentChooseViewController : UIViewController

@property(nonatomic, assign) NSUInteger nEquipType;

@end
