//
//  TitlesView.h
//  老淘宝详情
//
//  Created by Kobe24 on 2018/3/7.
//  Copyright © 2018年 SYD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitlesView : UIView

- (instancetype)initWithTitleArray:(NSArray *)titleArray;

- (void)setItemSelected:(NSInteger)column;


//点击的第几个按钮
typedef void (^TitleViewClick)(NSInteger);

@property (nonatomic, strong) TitleViewClick titleClickBlock;

@end
