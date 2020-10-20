//
//  TopSearchView.m
//  FamilyTree
//
//  Created by 王子豪 on 16/5/26.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "TopSearchView.h"
#import "MyHelpViewController.h"

@interface TopSearchView ()
/** 同城家谱*/
@property (nonatomic, strong) UILabel *tcjpLB;
@end

@implementation TopSearchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backView];
        [self addSubview:self.searchView];
        [self addSubview:self.tcjpLB];
        self.tcjpLB.sd_layout.centerXEqualToView(self).heightIs(40).topSpaceToView(self,20).leftSpaceToView(self,20).rightSpaceToView(self,20);
        [self.searchView addSubview:self.searchLabel];
        [self.searchView addSubview:self.searchImage];
        [self addSubview:self.menuBtn];
        self.menuBtn.sd_layout.leftSpaceToView(self.searchView,-30).rightSpaceToView(self,10).heightIs(30).topSpaceToView(self,27);
       
    }
    return self;
}

#pragma mark *** 点击搜索栏 ***
-(void)didTapSearchView{
    if (_delegate && [_delegate respondsToSelector:@selector(TopSearchViewDidTapView:)]) {
        [_delegate TopSearchViewDidTapView:self];
    }
}

#pragma mark *** 点击菜单栏 ***
-(void)respondsToMenuBtn:(UIButton *)sender{
    MyHelpViewController *myHelpVC = [[MyHelpViewController alloc]initWithTitle:@"我的互助" image:nil];
    [[self viewController].navigationController pushViewController:myHelpVC animated:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(TopSearchView:didRespondsToMenusBtn:)]) {
        [_delegate TopSearchView:self didRespondsToMenusBtn:sender];
    }
}

#pragma mark *** getters ***
-(UIImageView *)backView{
    if (!_backView) {
        _backView = [[UIImageView alloc] initWithFrame:self.bounds];
        //_backView.backgroundColor = LH_RGBCOLOR(75, 88, 91);
        _backView.image = MImage(@"navibg");
        _backView.userInteractionEnabled = YES;
    }
    return _backView;
}
-(UIView *)searchView{
    if (!_searchView) {
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(0.05*Screen_width, SearchToTop, 0.8*Screen_width, SearchView_Height)];
        _searchView.layer.cornerRadius = SearchView_Height/2.0f;
        _searchView.backgroundColor = [UIColor whiteColor];

    }
    return _searchView;
}
-(UITextField *)searchLabel{
    if (!_searchLabel) {
        _searchLabel = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, 150, SearchView_Height)];
        _searchLabel.font = BFont(13);
        _searchLabel.textAlignment = NSTextAlignmentLeft;
       
        _searchLabel.textColor = LH_RGBCOLOR(143, 143, 143);
        
    }
    return _searchLabel;
}
-(UIImageView *)searchImage{
    if (!_searchImage) {
        _searchImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.searchView.frame)-3*SearchImage_Size, self.searchView.bounds.size.height/2-SearchImage_Size/2, SearchImage_Size, SearchImage_Size)];
        _searchImage.image = MImage(@"search");
        _searchImage.userInteractionEnabled = true;
        //添加手势
        UITapGestureRecognizer *tapGues = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapSearchView)];
        [_searchImage addGestureRecognizer:tapGues];
        
    }
    return _searchImage;
}
-(UIButton *)menuBtn{
    if (!_menuBtn) {
        _menuBtn = [[UIButton alloc]init];
        [_menuBtn setTitle:@"我的互助" forState:UIControlStateNormal];
        _menuBtn.titleLabel.font = MFont(15);
        [_menuBtn addTarget:self action:@selector(respondsToMenuBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _menuBtn;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:true];
}

-(UILabel *)tcjpLB{
    if (!_tcjpLB) {
        _tcjpLB = [[UILabel alloc]init];
        _tcjpLB.text = @"同城家谱";
        _tcjpLB.font = MFont(18);
        _tcjpLB.textAlignment = NSTextAlignmentCenter;
        //_tcjpLB.backgroundColor = [UIColor random];
        _tcjpLB.textColor = [UIColor whiteColor];
    }
    return _tcjpLB;
}

@end
