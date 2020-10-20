//
//  ZJLineScaleFlowLayout.h
//  ZJCollectionViewSummary
//
//  Created by James on 2018/6/13.
//  Copyright © 2018年 James. All rights reserved.
//

/**
 项目地址：https://github.com/zhijiaxin/ZJCollectionViewSummary.git
 
 也可以到博客下看看相关介绍
 博客地址：https://www.jianshu.com/p/ff7089782d6c
 
 有什么错误或使用不便的地方可以留言或加我QQ
 
 QQ：1224740397
 */

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, ZJWaterDirection) {
    ZJWaterVertical,//竖直方向布局
    ZJWaterHorizontal//水平方向布局
};

@interface ZJLineScaleFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) ZJWaterDirection lineDirection;

@end
