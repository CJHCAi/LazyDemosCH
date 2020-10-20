//
//  SXTMainTopView.h
//  bjsxt-inke
//
//  Created by 大欢 on 16/9/2.
//  Copyright © 2016年 大欢. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MainTopBlock)(NSInteger tag);

@interface SXTMainTopView : UIView

- (instancetype)initWithFrame:(CGRect)frame titleNames:(NSArray *)titles;

@property (nonatomic, copy) MainTopBlock block;

- (void)scrolling:(NSInteger)tag;

@end
