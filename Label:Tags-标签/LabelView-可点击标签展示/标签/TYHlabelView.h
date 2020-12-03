//
//  TYHlabelView.h
//  标签
//
//  Created by Vieene on 16/7/29.
//  Copyright © 2016年 hhly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYHlabelView : UIView
- (instancetype)initWithLabelArray:(NSArray *)array viewframe:(CGRect)frame;
@property (nonatomic,copy) void (^Clickblock)(UIButton *btn);

@end
