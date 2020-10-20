//
//  LoginView.m
//  FamilyTree
//
//  Created by 王子豪 on 16/5/25.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "LoginView.h"


#define TopView_toTop  30
#define TopView_height 30

typedef enum : NSUInteger {
    TopViewRegisBtn,
    TopViewPassBtn,
} TopViewTag;

@interface LoginView()<OtherLoginViewDelegate>

@property (nonatomic,strong) UIImageView *backImageView; /*背景图*/

//@property (nonatomic,strong) OtherLoginView *otherLoginView; /*三方登录*/
//@property (nonatomic,strong) UIButton *tourBtn; /*游客按钮*/



@end
@implementation LoginView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backImageView];
        [self addSubview:self.topView];
        [self addSubview:self.accountView];
        [self addSubview:self.passwordView];
        //[self addSubview:self.otherLoginView];
//        [self addSubview:self.tourBtn];
        
    }
    return self;
}

#pragma mark *** TopViewBtnEvents ***
-(void)respondsToTopViewBtn:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(loginView:didSelectedTopViewBtn:)]) {
        [_delegate loginView:self didSelectedTopViewBtn:sender];
    }
}

#pragma mark *** OtherLoginViewDelegate ***

-(void)OtherLoginView:(OtherLoginView *)otherloginView didSelectedBtn:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(loginView:didSelectedOtherLoginBtn:)]) {
        [_delegate loginView:self didSelectedOtherLoginBtn:sender];
    }
}

#pragma mark *** 登入按钮 ***
-(void)respondsToLoginBtn:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(loginView:didSelectedLoginBtn:)]) {
        [_delegate loginView:self didSelectedLoginBtn:sender];
    }
}

#pragma mark *** 游客按钮 ***
//-(void)respondsToTourBtn:(UIButton *)sender{
//    if (_delegate && [_delegate respondsToSelector:@selector(loginView:didSelectedTourBtn:)]) {
//        [_delegate loginView:self didSelectedTourBtn:sender];
//    }
//}

#pragma mark *** getters ***
-(UIImageView *)backImageView{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backImageView.image = [UIImage imageNamed:@"bg-1.png"];
        
     }
    return _backImageView;
}
-(TopView *)topView{
    if (!_topView) {
        _topView = [[TopView alloc] initWithFrame:CGRectMake(0, 0.05*Screen_height, Screen_width, TopView_height)];
        _topView.regisBtn.tag = TopViewRegisBtn;
        _topView.findPassBtn.tag = TopViewPassBtn;
        [_topView.regisBtn addTarget:self action:@selector(respondsToTopViewBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_topView.findPassBtn addTarget:self action:@selector(respondsToTopViewBtn:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _topView;
}
-(AccountView *)accountView{
    if (!_accountView) {
        _accountView = [[AccountView alloc] initWithFrame:CGRectMake(0, 0,  0.8*Screen_width, 50) headImage:[UIImage imageNamed:@"user"] isSafe:NO hasArrows:NO];
        _accountView.bounds = CGRectMake(0, 0, 0.8*Screen_width, 50);
        _accountView.center = CGPointMake(self.center.x, 0.4*Screen_height);
    
    }
    return _accountView;
}

-(AccountView *)passwordView{
    if (!_passwordView) {
        _passwordView = [[AccountView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.accountView.frame), CGRectGetMaxY(self.accountView.frame)+10, self.accountView.bounds.size.width, 50) headImage:[UIImage imageNamed:@"password"] isSafe:YES hasArrows:YES];
        [_passwordView.goArrows addTarget:self action:@selector(respondsToLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _passwordView;
}
//-(OtherLoginView *)otherLoginView{
//    if (!_otherLoginView) {
//        _otherLoginView = [[OtherLoginView alloc] initWithFrame:CGRectMake(0, 0, 0.7*Screen_width, 100)];
//        
//        _otherLoginView.center = CGPointMake(self.center.x, 0.8*Screen_height);
//        _otherLoginView.delegate = self;
//    }
//    return _otherLoginView;
//}
//
//-(UIButton *)tourBtn{
//    if (!_tourBtn) {
//        _tourBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width/2-75, self.bounds.size.height-40, 150, 30)];
//        [_tourBtn setTitle:@"游 客 直 接 进 入" forState:UIControlStateNormal];
//        
//        _tourBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//        [_tourBtn addTarget:self action:@selector(respondsToTourBtn:) forControlEvents:UIControlEventTouchUpInside];
//        
//    }
//    return _tourBtn;
//}


@end
