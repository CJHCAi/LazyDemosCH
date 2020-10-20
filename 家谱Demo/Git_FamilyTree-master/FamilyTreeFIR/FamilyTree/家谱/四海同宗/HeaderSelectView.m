//
//  HeaderSelectView.m
//  FamilyTree
//
//  Created by 王子豪 on 16/5/31.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "HeaderSelectView.h"
#define BtnWidth 60

#define GapToleft 15
@interface HeaderSelectView()


@end

@implementation HeaderSelectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //self.backgroundColor = [UIColor whiteColor];
        //[self initUI];
    }
    return self;
}

-(void)initUI{
    
    NSArray *topTitles = @[@"全部",@"宗室会",@"家族人员",@"名人",@"重要地点"];
    
    for (int idx = 0; idx<topTitles.count; idx++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.bounds = CGRectMake(0, 0, BtnWidth, 30);
        btn.tag = idx;
        [btn addTarget:self action:@selector(respondsToAllBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        btn.sd_layout.topSpaceToView(self,10).bottomSpaceToView(self,10).leftSpaceToView(self,GapToleft+idx*(BtnWidth+(Screen_width-GapToleft*2-topTitles.count*BtnWidth)/(topTitles.count-1))).widthIs(BtnWidth);
        [btn setTitle:topTitles[idx] forState:0];
        [btn setTitleColor:[UIColor blackColor] forState:0];
        btn.titleLabel.font = MFont(14);

        
    }
    
    
}

#pragma mark *** events ***
-(void)respondsToAllBtn:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(HeaderSelecteView:didSelectedBtn:)]) {
        [_delegate HeaderSelecteView:self didSelectedBtn:sender];
    }
}

@end
