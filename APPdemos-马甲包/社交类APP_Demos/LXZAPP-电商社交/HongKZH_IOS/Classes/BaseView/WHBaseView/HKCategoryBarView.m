//
//  HKCategoryBarView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/31.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCategoryBarView.h"
@interface HKCategoryBarView()
@property (nonatomic, strong)NSMutableArray *btnArray;
@property (nonatomic, strong)UIView *selectLine;
@property (nonatomic, strong)UIScrollView *scrollView;
@property(nonatomic, assign) CGFloat allW;
@end

@implementation HKCategoryBarView
- (instancetype)initWithCategoryArray:(NSArray*)category selectCategory:(SelectCategory)selectCategory allW:(CGFloat)allw
{
    self = [super init];
    if (self) {
        self.allW = allw;
        self.selectCategory = selectCategory;
        NSMutableArray *array = [NSMutableArray arrayWithArray:category];
        self.category = array;
        [self setUI];
    }
    return self;
}
-(void)setUI{
    self.backgroundColor = [UIColor whiteColor];
    UIView*lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorFromHexString:@"e2e2e2"];
    [self addSubview:lineView];
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(1);
    }];
}
+(instancetype)categoryBarViewWithCategoryArray:(NSArray*)category selectCategory:(SelectCategory)selectCategory allW:(CGFloat)w{
    HKCategoryBarView *view = [[HKCategoryBarView alloc]initWithCategoryArray:category selectCategory:selectCategory allW:w];
    
    return view;
}
+(instancetype)categoryBarViewWithCategoryArray:(NSArray*)category selectCategory:(SelectCategory)selectCategory{
    HKCategoryBarView *view = [[HKCategoryBarView alloc]initWithCategoryArray:category selectCategory:selectCategory allW:0];
   
    return view;
}
-(void)setSelectTag:(int)tag{
    CGFloat minW = kScreenWidth/6;
    CGFloat w = kScreenWidth / self.category.count;
    if (self.allW>0) {
        w = self.allW/self.category.count;
    }
    if (w <minW) {
        w = minW;
    }
    [self.selectLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView).offset(tag*w);
    }];
    
    for (UIButton*btn in self.btnArray) {
        if(btn.tag == tag){
            btn.selected = YES;
        }else{
            btn.selected = NO;
        }
    }
}
-(void)selectbtn:(UIButton*)sender{
    int tag = (int)sender.tag;
    [self setSelectTag:tag];
    self.selectCategory(tag);
}
- (NSMutableArray *)btnArray
{
    if(_btnArray == nil)
    {
        _btnArray = [ NSMutableArray array];
    }
    return _btnArray;
}
-(void)setCategory:(NSMutableArray *)category{
    _category = category;
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (category.count > 0) {
        CGFloat minW = kScreenWidth/6;
        CGFloat w = kScreenWidth / category.count;
        if (self.allW>0) {
            w = self.allW/self.category.count;
        }
        if (w <minW) {
            w = minW;
        }
        self.scrollView.contentSize = CGSizeMake(category.count*w, 100);
        for (int i = 0; i<category.count; i++) {
            UIButton *btn = [[UIButton alloc]init];
            [btn setTitle:category[i] forState:0];
            [btn setTitleColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorFromHexString:@"#ef593c"] forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            btn.tag = i;
            [btn addTarget:self action:@selector(selectbtn:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollView addSubview:btn];
            [self.btnArray addObject:btn];
            if (i == 0) {
                btn.selected = YES;
            }
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.scrollView).offset(w*i);
                make.width.mas_equalTo(w);
                make.top.equalTo(self.scrollView);
                make.bottom.equalTo(self.scrollView).offset(-2);
            }];
        }
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
        [self.scrollView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.scrollView);
            make.height.mas_equalTo(1);
        }];
        UIView *selectLine = [[UIView alloc]init];
        _selectLine = selectLine;
        selectLine.backgroundColor = [UIColor colorFromHexString:@"#ef593c"];
        [self.scrollView addSubview:selectLine];
        [selectLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(w);
            make.left.equalTo(self.scrollView);
            make.top.equalTo(self.scrollView.mas_bottom).offset(5);
            make.height.mas_equalTo(2);
        }];
    }
}
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        _scrollView = scrollView;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.bounces = NO;
    }
    return _scrollView;
}
@end
