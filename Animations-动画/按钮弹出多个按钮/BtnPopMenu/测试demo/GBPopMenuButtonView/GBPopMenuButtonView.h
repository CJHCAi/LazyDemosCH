//
//  MuneBar.h
//  WKMuneController
//
//  Created by macairwkcao on 16/1/26.
//  Copyright © 2016年 CWK. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_OPTIONS(NSUInteger, GBmenuButtonType){
    GBMenuButtonTypeRadLeft = 0,
    GBMenuButtonTypeRadRight,
    GBMenuButtonTypeLineTop,
    GBMenuButtonTypeLineBottom,
    GBMenuButtonTypeLineLeft,
    GBMenuButtonTypeLineRight,
    GBMenuButtonTypeRoundTop,
    GBMenuButtonTypeRoundBottom,
    GBMenuButtonTypeRoundLeft,
    GBMenuButtonTypeRoundRight,
};

@protocol GBMenuButtonDelegate <NSObject>

@optional
-(void)menuButtonSelectedAtIdex:(NSInteger)index;
@optional
-(void)menuButtonShow;
@optional
-(void)menuButtonHide;

@end


@interface GBPopMenuButtonView : UIView

@property(nonatomic,strong)NSArray *itemsImages;

@property(nonatomic,weak)id <GBMenuButtonDelegate> delegate;

@property(nonatomic,assign)GBmenuButtonType type;

@property(nonatomic,assign)BOOL isShow;

@property(nonatomic,assign)BOOL isMove;

/**
 *  初始化函数
 *
 *  @param itemsImages 图片数组
 *  @param size        尺寸
 *
 */
-(instancetype)initWithItems:(NSArray *)itemsImages size:(CGSize)size type:(GBmenuButtonType)type isMove:(BOOL)isMove;
/**
 *  显示菜单
 */
-(void)showItems;
/**
 *  隐藏菜单
 */
-(void)hideItems;


@property(nonatomic,copy) void (^menuButtonSelectedAtIdex)(NSInteger);
@end
