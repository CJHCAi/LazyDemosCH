//
//  FamilyTreeTopView.m
//  FamilyTree
//
//  Created by 姚珉 on 16/5/27.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "FamilyTreeTopView.h"

#define SearchToTop 30
#define SearchView_Height 25
#define SearchImage_Size 15
#define MenusBtn_size 22

@interface FamilyTreeTopView()

@property (nonatomic,strong) UIImageView *backView; /*黑色背景*/
@property (nonatomic,strong) UIView *searchView; /*搜索框*/

@property (nonatomic,strong) UIImageView *searchImage; /*搜索图片*/

@end

@implementation FamilyTreeTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backView];
        [self addSubview:self.searchView];
        
        [self.searchView addSubview:self.searchLabel];
        [self.searchView addSubview:self.searchImage];
        [self addSubview:self.menuBtn];
 
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
    sender.selected = !sender.selected;
    if (_delegate && [_delegate respondsToSelector:@selector(TopSearchView:didRespondsToMenusBtn:)]) {
        [_delegate TopSearchView:self didRespondsToMenusBtn:sender];
    }
    
}
#pragma mark *** tableViewDelegate ***

#pragma mark *** getters ***
-(UIImageView *)backView{
    if (!_backView) {
        _backView = [[UIImageView alloc] initWithFrame:self.bounds];
        //_backView.backgroundColor = LH_RGBCOLOR(75, 88, 91);
        _backView.image = MImage(@"navibg");
    }
    return _backView;
}
-(UIView *)searchView{
    if (!_searchView) {
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(0.05*Screen_width, SearchToTop, 0.75*Screen_width-10, SearchView_Height)];
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
        _searchLabel.placeholder = @"输入关键词";
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
-(UIView *)menuBtn{
    if (!_menuBtn) {
        _menuBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.8*Screen_width, 30, 0.2*Screen_width, 24)];
        [_menuBtn setTitle:@"我的家谱" forState:UIControlStateNormal];
        _menuBtn.titleLabel.font = MFont(12);
        [_menuBtn setImage:MImage(@"sel2") forState:UIControlStateNormal];
        [_menuBtn setImage:MImage(@"sel1") forState:UIControlStateSelected];
        _menuBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, -3, -95);
        _menuBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
        _menuBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_menuBtn addTarget:self action:@selector(respondsToMenuBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_menuBtn];
    }
    return _menuBtn;
}

@end
