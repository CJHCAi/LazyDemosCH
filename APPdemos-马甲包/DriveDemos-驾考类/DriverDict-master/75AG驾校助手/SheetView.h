//
//  SheetView.h
//  75AG驾校助手
//
//  Created by again on 16/4/9.
//  Copyright © 2016年 again. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SheetViewDelegate
- (void)SheetViewClick:(int)index;
@end

@interface SheetView : UIView
{
    @public
    UIView *_backView;
}

@property (weak,nonatomic) id<SheetViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame withSuperView:(UIView *)superView andQuestion:(int)count;
@end
