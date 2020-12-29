//
//  HK_ParameterButton.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/4/20.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HK_ParameterButton : UIButton
@property(nonatomic,strong)NSString *inapp;
@property(nonatomic,assign)NSInteger line;
@property(nonatomic,assign)NSInteger number;
@property(nonatomic,assign)NSString* target_id;
@property(nonatomic,assign)NSString* categoryId;
@property(nonatomic,assign)NSString* title;
@property (nonatomic, assign) BOOL is_share;
@end
