//
//  WAddJPPersonView.m
//  FamilyTree
//
//  Created by 王子豪 on 16/7/8.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "WAddJPPersonView.h"

#define MaxDisplayPersonCount 4

@interface WAddJPPersonView()
{
    NSArray *_personArr;
}

/**滚动背景*/
@property (nonatomic,strong) UIScrollView *bacScrollView;


@end
@implementation WAddJPPersonView
- (instancetype)initWithFrame:(CGRect)frame forPersonArr:(NSArray *)perArr
{
    self = [super initWithFrame:frame];
    if (self) {
        _personArr = perArr;
        [self initUI];
    }
    return self;
}


#pragma mark *** 初始化界面 ***
-(void)initUI{
    [self addSubview:self.bacScrollView];
    
    for (int idx = 0; idx<_personArr.count; idx++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, idx*50*AdaptationWidth(), self.bounds.size.width, 50*AdaptationWidth())];
        btn.layer.borderWidth = 1.0f;
        btn.layer.borderColor = LH_RGBCOLOR(224, 201, 183).CGColor;
        [btn setTitle:_personArr[idx] forState:0];
        [btn setTitleColor:[UIColor blackColor] forState:0];
        btn.titleLabel.font = WFont(33);
        btn.backgroundColor = [UIColor whiteColor];
        [btn addTarget:self action:@selector(respondsToPerBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = idx;
        [self.bacScrollView addSubview:btn];
    }
    
}

#pragma mark *** Events ***
-(void)respondsToPerBtn:(UIButton *)sender{
    
    if (_delegate && [_delegate respondsToSelector:@selector(WAddJPPersonViewDelegate:didSelectedBtn:)]) {
        [_delegate WAddJPPersonViewDelegate:self didSelectedBtn:sender];
    };
}

#pragma mark *** getters ***

-(UIScrollView *)bacScrollView{
    if (!_bacScrollView) {
        NSInteger maxCount = _personArr.count>MaxDisplayPersonCount?MaxDisplayPersonCount:_personArr.count;

        _bacScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, maxCount*50*AdaptationWidth())];
        _bacScrollView.contentSize = AdaptationSize(self.bounds.size.width/AdaptationWidth(), _personArr.count*50);
        _bacScrollView.showsVerticalScrollIndicator = false;
        _bacScrollView.showsHorizontalScrollIndicator = false;

    }
    return _bacScrollView;
}
@end
