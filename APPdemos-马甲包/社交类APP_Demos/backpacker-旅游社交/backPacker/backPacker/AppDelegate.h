//
//  AppDelegate.h
//  backPacker
//
//  Created by 聂 亚杰 on 13-5-23.
//  Copyright (c) 2013年 聂 亚杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    BMKMapManager *_mapManager;
}
@property (strong, nonatomic) UIWindow *window;

@end
