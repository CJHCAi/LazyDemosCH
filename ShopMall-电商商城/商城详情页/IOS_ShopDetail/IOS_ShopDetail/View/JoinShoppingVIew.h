//
//  JoinShoppingVIew.h
//  LD_app_ios_NetWin
//
//  Created by 苟应航 on 2018/7/27.
//  Copyright © 2018年 lddtgroup. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JoinShoppingVIewDelegate <NSObject>

-(void)JoinOrBayAction:(NSInteger)sender count:(NSInteger)count;

@end



@interface JoinShoppingVIew : UIView
@property(nonatomic,assign) id<JoinShoppingVIewDelegate> delegate;
@property(nonatomic,strong)ShopModel *model;

/**
 *  prepaidbool
 *  YES: 预购 订单   NO:直供/仓储
 */
-(instancetype)initWithFrame:(CGRect)frame sender:(NSInteger)sender String:(NSString *)string Backcolor:(UIColor *)backcolor Textcolor:(UIColor *)textcolor prepaidbool:(BOOL)prepaidbool;
@end
