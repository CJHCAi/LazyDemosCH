//
//  CommonNavigationViews.m
//  FamilyTree
//
//  Created by 王子豪 on 16/5/27.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "CommonNavigationViews.h"

@interface CommonNavigationViews()<SelectMyFamilyViewDelegate>

/**我的家谱↓*/
@property (nonatomic,strong) SelectMyFamilyView *selecMyFamView;

@end
@implementation CommonNavigationViews
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title image:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backView];
        [self addSubview:self.titleLabel];
        self.titleLabel.text = title;
        [self addSubview:self.rightBtn];
        [self.rightBtn setImage:image forState:0];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backView];
        [self addSubview:self.titleLabel];
        self.titleLabel.text = title;
        [self addSubview:self.MyFamilyRightBtn];
    }
    return self;
}

#pragma mark *** Events ***

-(void)respondsToReturnBtn{
    
    MYLog(@"返回按钮");
    NSArray *titleArr = @[@"四海同宗",@"世系图",@"阅读家谱",@"字辈",@"图文影音"];
    if ([titleArr containsObject:self.titleLabel.text]) {
        
        [[self getNaiViewController] popToRootViewControllerAnimated:YES];

    }
    [[self getNaiViewController] popViewControllerAnimated:YES];
    
}

-(void)respondsToRightBtn:(UIButton *)sender{
    sender.selected = !sender.selected;
    MYLog(@"右按钮");
    
    if (sender.selected) {
        [self.viewController.view addSubview:self.selecMyFamView];
    }else{
        [self.selecMyFamView removeFromSuperview];
    }
    [self.selecMyFamView updateDataSourceAndUI];
    
    if (_delegate && [_delegate respondsToSelector:@selector(CommonNavigationViews:respondsToRightBtn:)]) {
        [_delegate CommonNavigationViews:self respondsToRightBtn:sender];
    }
    
}
-(void)respondsToRightRankingBtn:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    MYLog(@"右按钮");
    if (sender.selected) {
        [self.viewController.view addSubview:self.rightMenuBtn];
    }else{
        [self.rightMenuBtn removeFromSuperview];
    }
    
}

//获取当前view导航控制器
- (UINavigationController*)getNaiViewController {
    
    for (UIView* next = [self superview]; next; next = next.superview) {
        
        UIResponder* nextResponder = [next nextResponder];
        
        if ([nextResponder isKindOfClass:[UINavigationController class]]) {
            
            return (UINavigationController*)nextResponder;

        }
    }
    return nil;
    
}

#pragma mark *** SelecMyFamyDelegate ***
-(void)SelectMyFamilyViewDelegate:(SelectMyFamilyView *)seleMyFam didSelectFamID:(NSString *)famId{
    
    self.MyFamilyRightBtn.selected = false;
    if (_delegate && [_delegate respondsToSelector:@selector(CommonNavigationViews:selectedFamilyId:)]) {
        [_delegate CommonNavigationViews:self selectedFamilyId:famId];
    };
}

#pragma mark *** getters ***
-(UIImageView *)backView{
    if (!_backView) {
        _backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 44+StatusBar_Height)];
//        _backView.backgroundColor = LH_RGBCOLOR(75, 88, 91);
        _backView.image = MImage(@"navibg");
        _backView.userInteractionEnabled = YES;
        self.leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_backView.bounds)/2-30+StatusBar_Height, 44, 44)];
        [self.leftBtn setImage:MImage(@"fanhui") forState:0];
        
        [self.leftBtn addTarget:self action:@selector(respondsToReturnBtn) forControlEvents:UIControlEventTouchUpInside];
        self.leftBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [_backView addSubview:self.leftBtn];
    }
    return _backView;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
        _titleLabel.center = CGPointMake(self.center.x,CGRectGetHeight(_backView.bounds)/2-30+StatusBar_Height+22);
        _titleLabel.textAlignment = 1;
        _titleLabel.text = @"这是标题";
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

-(UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.frame)-44+5, CGRectGetHeight(_backView.bounds)/2-30+StatusBar_Height+10, 25, 25)];
        _rightBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [_rightBtn addTarget:self action:@selector(respondsToRightRankingBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

-(UIButton *)MyFamilyRightBtn{
    if (!_MyFamilyRightBtn) {
        _MyFamilyRightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.8*Screen_width, 30, 0.2*Screen_width, 24)];
        [_MyFamilyRightBtn setTitle:@"我的家谱" forState:UIControlStateNormal];
        _MyFamilyRightBtn.titleLabel.font = MFont(12);
        [_MyFamilyRightBtn setImage:MImage(@"sel2") forState:UIControlStateNormal];
        [_MyFamilyRightBtn setImage:MImage(@"sel1") forState:UIControlStateSelected];
        _MyFamilyRightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, -3, -95);
        _MyFamilyRightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
        _MyFamilyRightBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_MyFamilyRightBtn addTarget:self action:@selector(respondsToRightBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_MyFamilyRightBtn];

    }
    return _MyFamilyRightBtn;
}
-(SelectMyFamilyView *)selecMyFamView{
    if (!_selecMyFamView) {
        _selecMyFamView = [[SelectMyFamilyView alloc] initWithFrame:CGRectMake(0, 64, Screen_width, Screen_height-64-self.viewController.tabBarController.tabBar.bounds.size.height)];
        _selecMyFamView.delegate = self;
    }
    [_selecMyFamView updateDataSourceAndUI];
//    _selecMyFamView.didSelectedItem = false;
    return _selecMyFamView;
}
-(WMenuBtn *)rightMenuBtn{
    if (!_rightMenuBtn) {
        _rightMenuBtn = [[WMenuBtn alloc] initWithFrame:AdaptationFrame(Screen_width/AdaptationWidth()-135, 64/AdaptationWidth(), 135, 190)];
    }
    return _rightMenuBtn;
}
@end
