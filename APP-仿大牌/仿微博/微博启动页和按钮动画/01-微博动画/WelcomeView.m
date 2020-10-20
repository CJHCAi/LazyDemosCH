//
//  WelcomeView.m
//  01-微博动画
//
//  Created by xiaomage on 15/6/26.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "WelcomeView.h"

@interface WelcomeView ()
@property (weak, nonatomic) IBOutlet UIImageView *sloganView;

@property (weak, nonatomic) IBOutlet UILabel *textView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@end

@implementation WelcomeView


+ (instancetype)weicomeView{
    return [[NSBundle mainBundle] loadNibNamed:@"WelcomeView" owner:nil options:nil][0];
}
/*
 文字图片慢慢消失，alpha
 显示头像，头像往上移动的动画，弹簧效果
 欢迎回来的文字 慢慢显示 alpha
 */

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
//    _iconView.layer.cornerRadius = 50;
//    _iconView.layer.masksToBounds = YES;
    
    _iconView.transform = CGAffineTransformMakeTranslation(0, 50);
    [UIView animateWithDuration:2 animations:^{
        _sloganView.alpha = 0;
    } completion:^(BOOL finished) {
        _iconView.hidden = NO;
        
        [UIView animateWithDuration:2 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
            _iconView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
            _textView.alpha = 0;
            _textView.hidden = NO;
           // 文字慢慢显示
            
            [UIView animateWithDuration:1 animations:^{
                _textView.alpha = 1;
                
            } completion:^(BOOL finished) {
               
                [self removeFromSuperview];
                
            }];
            
        }];
        
    }];
    
    
    NSLog(@"%s",__func__);
}

//- (void)didMoveToWindow
//{
//    [super didMoveToWindow];
//    NSLog(@"%s",__func__);
//}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
