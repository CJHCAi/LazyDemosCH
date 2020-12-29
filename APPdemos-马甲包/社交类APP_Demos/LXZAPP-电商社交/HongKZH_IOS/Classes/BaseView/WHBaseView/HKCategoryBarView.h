//
//  HKCategoryBarView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/31.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SelectCategory)(int index);
@interface HKCategoryBarView : UIView
+(instancetype)categoryBarViewWithCategoryArray:(NSArray*)category selectCategory:(SelectCategory)selectCategory;
@property (nonatomic, strong)NSMutableArray *category;
@property (copy, nonatomic) SelectCategory selectCategory;
-(void)setUI;
+(instancetype)categoryBarViewWithCategoryArray:(NSArray*)category selectCategory:(SelectCategory)selectCategory allW:(CGFloat)w;
-(void)setSelectTag:(int)tag;
@end
