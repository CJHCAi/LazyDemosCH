//
//  ZPScrollerScaleView.h
//  ChooseRoleScroller
//
//  Created by admin on 2019/7/31.
//  Copyright © 2019 April. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZPScrollerScaleViewConfig : NSObject

/**自定义pageSize*/
@property (nonatomic, assign) CGSize pageSize;

/**子视图间距*/
@property (nonatomic, assign) CGFloat ItemMaingin;

/**最小缩放比例*/
@property (nonatomic, assign) CGFloat scaleMin;

/**最大缩放比建议为 1 这个值若非必要不要进行修改 影响视图展示导致失真*/
@property (nonatomic, assign) CGFloat scaleMax;


@end

@interface ZPScrollerScaleView : UIView

/**视图数组*/
@property (nonatomic, strong) NSArray<UIView *> * items;

/**默认显示第几个*/
@property (nonatomic, assign) NSInteger defalutIndex;

/**当前下标值*/
@property (nonatomic, assign, readonly) NSInteger currentIndex;

/// 初始化方法
/// @param config 配置参数
- (instancetype)initWithConfig:(ZPScrollerScaleViewConfig *)config;



@end

NS_ASSUME_NONNULL_END
