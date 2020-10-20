//
//  TopBackSearch.m
//  FamilyTree
//
//  Created by 王子豪 on 16/6/8.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "TopBackSearch.h"

@implementation TopBackSearch
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.searchView.frame = CGRectMake(0.10*Screen_width, SearchToTop, 0.70*Screen_width, SearchView_Height);
        self.searchImage.frame = CGRectMake(450*AdaptationWidth(), 10*AdaptationWidth(), self.searchImage.bounds.size.width, self.searchImage.bounds.size.height);
        
        self.searchLabel.placeholder = @"查询字辈";
        [self.menuBtn removeFromSuperview];
        
        [self addSubview:self.backBtn];
        
        [self addSubview:self.MyFamilyRightBtn];
        
        
    }
    return self;
}

-(void)SelectMyFamilyViewDelegate:(SelectMyFamilyView *)seleMyFam didSelectFamID:(NSString *)famId{
    [seleMyFam removeFromSuperview];
    _MyFamilyRightBtn.selected = false;
    
    if (_delegateBak && [_delegateBak respondsToSelector:@selector(didTapMySeletedFamWithNumber:)]) {
        [_delegateBak didTapMySeletedFamWithNumber:famId];
    };
    
}
#pragma mark *** events ***
-(void)respondsToToBackRightBtn:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.viewController.view addSubview:self.selecMyFamView];
    }else{
        [self.selecMyFamView removeFromSuperview];
    }
    [self.selecMyFamView updateDataSourceAndUI];
    
}
#pragma mark *** getters ***
-(UIButton *)backBtn{
    
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] initWithFrame:CGRectMake(-10*AdaptationWidth(), StatusBar_Height, 44, 44)];
        [_backBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    }
    return _backBtn;
    
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
        [_MyFamilyRightBtn addTarget:self action:@selector(respondsToToBackRightBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_MyFamilyRightBtn];
        
    }
    return _MyFamilyRightBtn;
}
-(SelectMyFamilyView *)selecMyFamView{
    if (!_selecMyFamView) {
        _selecMyFamView = [[SelectMyFamilyView alloc] initWithFrame:CGRectMake(0, 64, Screen_width, Screen_height-64-self.viewController.tabBarController.tabBar.bounds.size.width)];
        _selecMyFamView.delegate = self;
    }
    [_selecMyFamView updateDataSourceAndUI];
//    _selecMyFamView.didSelectedItem = false;
    return _selecMyFamView;
}
@end
