//
//  YCCollectionViewCell.m
//  YClub
//
//  Created by 岳鹏飞 on 2017/6/21.
//  Copyright © 2017年 岳鹏飞. All rights reserved.
//

#import "YCCollectionViewCell.h"

@interface YCCollectionViewCell ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) YCBaseModel *pic;
@end

@implementation YCCollectionViewCell
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.layer.masksToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}
- (UIButton *)deleteBtn
{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.hidden = YES;
        [_deleteBtn setImage:[UIImage imageNamed:@"nf_love_delete"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpSubview];
    }
    return self;
}
- (void)setUpSubview
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.deleteBtn];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.equalTo(self.contentView).with.offset(5);
        make.right.bottom.equalTo(self.contentView).with.offset(-5);
    }];
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView).with.offset(5);
        make.right.equalTo(self.contentView).with.offset(-5);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
}
- (void)setModel:(YCBaseModel *)model
{
    if (!model) {
        return;
    }
    _pic = model;
    [_imageView sd_setImageWithURL:[NSURL safeURLWithString:model.thumb] placeholderImage:[UIImage imageNamed:@"yc_default_place"]];
}
- (void)prepareForReuse
{
    [super prepareForReuse];
    _pic = nil;
    _imageView.image   = nil;
}
#pragma mark - 长按删除状态
- (void)setUpLongGes
{
    UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGesAction:)];
    [self.contentView addGestureRecognizer:longGes];
}
- (void)longGesAction:(UILongPressGestureRecognizer *)ges
{
    if(ges.state == UIGestureRecognizerStateBegan) {
        if (_delegate && [_delegate respondsToSelector:@selector(beginDeleteState)]) {
            [_delegate beginDeleteState];
        }
    }
}
#pragma mark - 删除动作
- (void)deleteAction
{
    if (kObjectIsEmpty(_pic) || kObjectIsEmpty(_indexPath)) {
        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(deletePic:atIndexpath:)]) {
        [_delegate deletePic:_pic atIndexpath:_indexPath];
    }
}
@end
