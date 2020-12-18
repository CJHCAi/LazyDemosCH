//
//  HomeMenuCell.h
//  meituan
//
//  Created by lujh on 15/6/30.
//  Copyright (c) 2015年 lujh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZMTBtnView.h"

@protocol OnTapBtnViewDelegate <NSObject>
// 轮播图手势点击代理
- (void)OnTapBtnView:(UITapGestureRecognizer *)sender;

@end

@interface HomeMenuCell : UITableViewCell
// 轮播图第一页
@property(nonatomic,strong)UIView *backView1;
// 轮播图第二页
@property(nonatomic,strong)UIView *backView2;
// UIPageControl
@property(nonatomic,strong)UIPageControl *pageControl;
// 图片标题数组
@property(nonatomic,copy)NSMutableArray *menuArray;
// 轮播图手势点击代理
@property(nonatomic,assign)id<OnTapBtnViewDelegate> onTapBtnViewDelegate;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier menuArray:(NSMutableArray *)menuArray;

@end
