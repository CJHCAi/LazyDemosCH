//
//  WTypeBtnView.m
//  FamilyTree
//
//  Created by 王子豪 on 16/7/25.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "WTypeBtnView.h"

@implementation WTypeBtnView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initAllFilterBtn];
    }
    return self;
}
-(void)respondsToForBtn:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(typeBtnView:didSelectedTitle:)]) {
        [_delegate typeBtnView:self didSelectedTitle:sender.titleLabel.text];
    };
}
-(void)initAllFilterBtn{
    NSArray *titleArr = @[@"综合",@"价格",@"销量"];
    CGFloat width = self.frame.size.width/titleArr.count;
    for (int idx = 0; idx<titleArr.count; idx++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(width*idx, 0, width, self.bounds.size.height)];
        [btn setTitle:titleArr[idx] forState:0];
        btn.titleLabel.font = WFont(30);
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitleColor:[UIColor blackColor] forState:0];
        [btn addTarget:self action:@selector(respondsToForBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}
@end
