//
//  BWGuideCollectionViewCell.m
//  BWGuideViewController
//
//  Created by syt on 2019/12/20.
//  Copyright © 2019 syt. All rights reserved.
//

#import "BWGuideCollectionViewCell.h"

@interface BWGuideCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UIButton *enterBtn;

@end

@implementation BWGuideCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        [self loadSubViews];
    }
    return self;
}

- (void)loadSubViews
{
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.enterBtn];
}


- (void)updateContent:(NSString *)imgName isHiden:(BOOL)isHiden
{
    self.imgView.image = [UIImage imageNamed:imgName];
    self.enterBtn.hidden = isHiden;
}


#pragma mark - enterBtnAction
- (void)enterBtnAction
{
    NSLog(@"进入主页");
    if (self.enterButtonClick) {
        self.enterButtonClick();
    }
}



#pragma mark - lazy loading

- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:self.contentView.frame];
    }
    return _imgView;
}

- (UIButton *)enterBtn
{
    if (!_enterBtn) {
        _enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _enterBtn.frame = CGRectMake(k_Screen_Width / 2 - 60, k_Screen_Height - 70 - k_TabBar_DValue_Height, 120, 30);
        [_enterBtn setTitle:@"立即进入" forState:UIControlStateNormal];
        [_enterBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _enterBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _enterBtn.layer.masksToBounds = YES;
        _enterBtn.layer.borderWidth = 1.0;
        _enterBtn.layer.cornerRadius = 5;
        _enterBtn.layer.borderColor = UIColor.whiteColor.CGColor;
        _enterBtn.hidden = YES;
        [_enterBtn addTarget:self action:@selector(enterBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterBtn;
}






@end
