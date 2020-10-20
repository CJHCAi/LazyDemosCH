//
//  ClickRoundView.h
//  FamilyTree
//
//  Created by 王子豪 on 16/6/3.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClickRoundView : UIView

@property (nonatomic,assign) BOOL marked; /*标记*/

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title isStar:(BOOL)star;

@end
