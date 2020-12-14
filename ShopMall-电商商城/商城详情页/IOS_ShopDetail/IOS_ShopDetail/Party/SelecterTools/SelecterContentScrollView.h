//
//  SelecterContentScrollView.h
//  SelecterTools
//
//  Created by zhao on 16/3/15.
//  Copyright © 2016年 xincheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ScrollPage)(int);

@interface SelecterContentScrollView : UIScrollView

-(void)updateVCViewFromIndex:(NSInteger )index;

-(void)typeScrollview:(NSInteger )index;

-(instancetype)initWithSeleterConditionTitleArr:(NSArray *)vcArr Bool:(BOOL)Bool andBtnBlock:(ScrollPage)page;
-(instancetype)initWithSeleterCondition:(NSArray *)vcArr Bool:(BOOL)Bool andBtnBlock:(ScrollPage)page;

/**
 * 酒仓使用的
 */
-(instancetype)initWithSeleterinitWithSeleterWineWarehouse:(NSArray *)vcArr Bool:(BOOL)Bool andBtnBlock:(ScrollPage)page;

@end
