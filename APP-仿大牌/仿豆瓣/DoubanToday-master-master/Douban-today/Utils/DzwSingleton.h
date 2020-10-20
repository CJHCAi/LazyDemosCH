//
//  DzwSingleton.h
//  Douban-today
//
//  Created by dzw on 2018/10/26.
//  Copyright © 2018 dzw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainTabbarViewController.h"
@interface DzwSingleton : NSObject

@property (nonatomic, strong) MainTabbarViewController *tabBarVC;
@property (nonatomic, copy) NSString *currentCity;
+ (DzwSingleton *)sharedInstance;

@end
