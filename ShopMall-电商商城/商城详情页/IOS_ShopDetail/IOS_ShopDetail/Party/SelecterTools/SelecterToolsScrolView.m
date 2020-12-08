//
//  SelecterToolsScrolView.m
//  SelecterTools
//
//  Created by zhao on 16/3/15.
//  Copyright © 2016年 xincheng. All rights reserved.
//

#import "SelecterToolsScrolView.h"

#define TitlesFont baseFontSize
#define TitleFont 15
#define widths 80  // 100

@interface SelecterToolsScrolView()
{
    CGFloat btnWidths;
    CGFloat sapces;
    
}
@property(nonatomic,copy)BtnClick btnClick;


@property(nonatomic,retain)NSMutableArray *btnArr;
@property(nonatomic,retain)UIButton * previousBtn;
@property(nonatomic,retain)UIButton * currentBtn;


@property(nonatomic,strong)UIButton *titilone;
@property(nonatomic,strong)UIButton *titletwo;
@property(nonatomic,strong)UIImageView *images;

@property(nonatomic,retain)UIView *bottomScrLine;
@end

@implementation SelecterToolsScrolView

//获取view的controller
- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
-(void)popviewcontroller{
    [self.viewController.navigationController popViewControllerAnimated:YES];
}
- (void)backAction{
    
    [[self viewController].navigationController popViewControllerAnimated:YES];
}
#pragma mark - 商品详情使用
-(instancetype)initWithSeletershopdetails:(NSArray *)titleArr andBool:(BOOL) Bool andBtnBlock:(BtnClick)btnClick{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(-1,0,SCREEN_WIDTH+titleArr.count, Heightscrooler);
        btnWidths= SCREEN_WIDTH/titleArr.count-40;
        sapces = 0;
        
        self.backgroundColor = Kwhite;
        _btnArr = [NSMutableArray array];
        for (int i = 0; i<titleArr.count; i++) {
            UIButton *titleBtn = [[UIButton alloc]initWithFrame:CGRectMake(sapces+i*(btnWidths+40), 5, btnWidths+40, Heightscrooler-10)];
            titleBtn.tag = i;
            [titleBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [titleBtn setTitle:titleArr[i] forState:UIControlStateNormal];
            titleBtn.titleLabel.font = [UIFont systemFontOfSize:TitleFont];
            [titleBtn setTitleColor:AlltextgrayColor forState:UIControlStateNormal];
            [titleBtn setTitleColor:AllxianBinColor forState:UIControlStateSelected];
            [self addSubview:titleBtn];
            [_btnArr addObject:titleBtn];
            if (i == 0) {
                _previousBtn = titleBtn;
                _currentBtn = titleBtn;
                titleBtn.selected = YES;
            }
        }
        _bottomScrLine = [[UIView alloc]initWithFrame:CGRectMake(20*SCALEWITH6, self.frame.size.height-2,btnWidths,2)];
        self.btnClick = btnClick;
        _bottomScrLine.backgroundColor =AllxianBinColor;
        [self addSubview:_bottomScrLine];
        
        
        for (int i=0; i<3; i++) {
            UILabel *leandlabe=[UILabel new];
            leandlabe.backgroundColor=AlltextgrayColor;
            [self addSubview:leandlabe];
            [leandlabe mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(SCREEN_WIDTH/3*i);
                make.centerY.mas_equalTo(self.mas_centerY);
                make.width.mas_equalTo(0.5);
                make.height.mas_equalTo(Heightscrooler-26);
            }];
        }
        
//        UILabel *leanlabea=[UILabel new];
//        leanlabea.backgroundColor=[UIColor redColor];
//        [self addSubview:leanlabea];
//        [leanlabea mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.mas_equalTo(0);
//            make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-2);
//            make.height.mas_equalTo(1);
//        }];
        
#pragma mark -  滑动的时候 下面的线条...
        if (Bool==YES) {
            self.contentSize = CGSizeMake(sapces+btnWidths*titleArr.count, 30);
        }
        self.keyboardDismissMode=UIScrollViewKeyboardDismissModeOnDrag;// 滚动时候，键盘消失
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
    }
    return self;
}

-(void)updateSelecterToolsIndex:(NSInteger )index
{

    UIButton *selectBtn = _btnArr[index];
    
    [self changeSelectBtn:selectBtn];
}

-(void)btnClick:(UIButton *)sender
{
    self.btnClick(sender);
}

-(void)changeSelectBtn:(UIButton *)btn
{
    
    _previousBtn = _currentBtn;
    _currentBtn = btn;
    _previousBtn.selected = NO;
    _currentBtn.selected = YES;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
    _bottomScrLine.width =btnWidths;
    _bottomScrLine.center = CGPointMake(_currentBtn.center.x, _bottomScrLine.center.y);
    } completion:^(BOOL finished) {
    }];
    
}
@end
