//
//  ZJCollectionViewRightIndex.h
//  ZJCollectionViewSummary
//
//  Created by James on 2018/5/28.
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

@class ZJCollectionViewRightIndex;

@protocol ZJCollectionViewRightIndexDelegate <NSObject>

/**
 *  触摸到索引时的反应
 *
 *  @param collectionViewIndex 触发的对象
 *  @param index               触发的索引的下标
 *  @param title               触发的索引的文字
 */
-(void)collectionViewIndex:(ZJCollectionViewRightIndex *)collectionViewIndex didselectionAtIndex:(NSInteger)index withTitle:(NSString *)title;

@optional
/**
 *  开始触摸索引
 *
 *  @param collectionViewIndex 触发collectionViewIndexTouchesBegan对象
 */
- (void)collectionViewIndexTouchesBegan:(ZJCollectionViewRightIndex *)collectionViewIndex;


/**
 *  触摸索引结束
 *
 *  @param collectionViewIndex
 */
- (void)collectionViewIndexTouchesEnd:(ZJCollectionViewRightIndex *)collectionViewIndex;

@end

@interface ZJCollectionViewRightIndex : UIView

/**
 *  索引内容数组
 */
@property (nonatomic, strong)NSArray *titleIndexes;

/**
 设置索引字母的颜色
 */
@property (nonatomic, strong) UIColor *color;
/**
 选中索引之后是否在屏幕中显示所选的值
 YES显示，NO不显示
 */
@property (nonatomic, assign) BOOL isSelectVisible;

@property (nonatomic, weak)id<ZJCollectionViewRightIndexDelegate>collectionDelegate;

@end
