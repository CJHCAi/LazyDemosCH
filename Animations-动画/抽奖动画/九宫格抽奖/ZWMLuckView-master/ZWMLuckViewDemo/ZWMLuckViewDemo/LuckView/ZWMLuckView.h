//
//  ZWMLuckView.h
//  ZWMLuckViewDemo
//
//  Created by 伟明 on 2017/12/15.
//  Copyright © 2017年 com.zwm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZWMLuckViewDelegate <NSObject>
/// 抽奖停止回调
- (void)luckViewDidStopWithIndex:(NSInteger)index;
@end

@interface ZWMLuckView : UIView
/// 概率数组
@property (nonatomic, strong) NSArray *rateArray;
/// 循环圈数
@property (nonatomic, assign) NSInteger circleCount;
@property (nonatomic, weak) id<ZWMLuckViewDelegate> deleagte;
/**
 frame 九宫格大小
 array 图片数组
 */
- (__kindof ZWMLuckView *)initWithFrame:(CGRect)frame imagesArray:(NSArray *)array;
@end
