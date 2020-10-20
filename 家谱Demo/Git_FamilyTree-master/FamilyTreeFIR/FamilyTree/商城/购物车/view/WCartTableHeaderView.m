//
//  WCartTableHeaderView.m
//  FamilyTree
//
//  Created by 王子豪 on 16/7/27.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "WCartTableHeaderView.h"

@implementation WCartTableHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.headSelectBtn];
        [self addSubview:self.editBtn];
    }
    return self;
}
#pragma mark *** Events ***
-(void)respondsToTheBtn:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(WcartTableHeaderView:didSeletedButtion:)]) {
        [_delegate WcartTableHeaderView:self didSeletedButtion:sender];
    };
}
#pragma mark *** getters ***
-(UIButton *)headSelectBtn{
    if (!_headSelectBtn) {
        _headSelectBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 50, self.bounds.size.height)];
        [_headSelectBtn setTitle:@"全选" forState:0];
        _headSelectBtn.titleLabel.font = WFont(30);
        [_headSelectBtn setTitleColor:[UIColor blackColor] forState:0];
        [_headSelectBtn addTarget:self action:@selector(respondsToTheBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_headSelectBtn setImage:[UIImage imageWithColor:[UIColor redColor]] forState:0];
    }
    return _headSelectBtn;
}
-(UIButton *)editBtn{
    if (!_editBtn) {
        _editBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width-50, 0, 50, self.bounds.size.height)];
        [_editBtn setTitle:@"" forState:0];
        _editBtn.titleLabel.font = self.headSelectBtn.titleLabel.font;
        [_editBtn setTitleColor:[UIColor blackColor] forState:0];
        [_editBtn addTarget:self action:@selector(respondsToTheBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editBtn;
}
@end
