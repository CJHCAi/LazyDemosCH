//
//  ShopHeadDetailView.h
//  IOS_ShopDetail
//
//  Created by 苟应航 on 2018/8/21.
//  Copyright © 2018年 GH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopHeadDetailView : UIView

@property(nonatomic,strong)ShopModel *model;

-(instancetype)initWithFrame:(CGRect)frame countbool:(BOOL)bools;

@end
