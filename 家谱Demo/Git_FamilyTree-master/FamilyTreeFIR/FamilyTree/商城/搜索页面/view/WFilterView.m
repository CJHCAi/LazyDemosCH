//
//  WFilterView.m
//  FamilyTree
//
//  Created by 王子豪 on 16/7/25.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "WFilterView.h"
#define StartTag 20
@interface WFilterView()<UITextFieldDelegate>
{
    //选择了的促销条件
    NSMutableArray *_condiArr;
    /** 筛选条件是否正确*/
    BOOL _correctFilert;
}
/**背景*/
@property (nonatomic,strong) UIView *backView;
/**最低价*/
@property (nonatomic,strong) UITextField *minPrice;
/**最高价*/
@property (nonatomic,strong) UITextField *maxPrice;
/**传出去的筛选条件dic*/
@property (nonatomic,strong) NSMutableDictionary *condDic;


@end

@implementation WFilterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initdata];
        [self initUI];
        
    }
    return self;
}
-(void)initdata{
    _condDic = [NSMutableDictionary dictionary];
    _condiArr= [@[@"",@"",@""] mutableCopy];
    _correctFilert = true;
}
#pragma mark *** 初始化界面 ***
-(void)initUI{
    [self addSubview:self.backView];
    [self.backView addSubview:self.minPrice];
    [self.backView addSubview:self.maxPrice];
    [self initConditionLabelBtn];
    [self initSureBtn];
}
/** 促销条件 */
-(void)initConditionLabelBtn{
 
    NSArray *titleArr = @[@"折扣",@"返券",@"包邮"];
    for (int idx = 0; idx<titleArr.count; idx++) {
        
        UIButton *btn = [[UIButton alloc] initWithFrame:AdaptationFrame(27+207*idx, 264, 180, 60)];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageWithColor:LH_RGBCOLOR(234, 234, 234)] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor redColor]] forState:UIControlStateSelected];
        [btn setTitle:titleArr[idx] forState:0];
        btn.tag = idx+StartTag;
        btn.titleLabel.font = WFont(25);
        [btn addTarget:self action:@selector(respondsToCondiTionBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius = 4;
        [self.backView addSubview:btn];
    }
    
}
/** 重置和完成 */
-(void)initSureBtn{
    UILabel *conditionLabel = [[UILabel alloc] initWithFrame:AdaptationFrame(21, 200, 200, 40)];
    conditionLabel.text = @"促销条件";
    conditionLabel.font = WFont(30);
    [self.backView addSubview:conditionLabel];
    
    NSArray *arr = @[@"重置",@"完成"];
    for (int idx = 0; idx<arr.count; idx++) {
        UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sureBtn.frame = CGRectMake(idx*self.backView.size.width/2, CGRectGetMaxY(self.bounds)-95*AdaptationWidth(), self.backView.bounds.size.width/2, 95*AdaptationWidth());
        sureBtn.titleLabel.font = WFont(30);
        [sureBtn setTitle:arr[idx] forState:0];
        [sureBtn addTarget:self action:@selector(respondsToSureBtn:) forControlEvents:UIControlEventTouchUpInside];
        sureBtn.backgroundColor = [UIColor redColor];
        
        if (idx==0) {
            sureBtn.backgroundColor = [UIColor whiteColor];
            [sureBtn setTitleColor:[UIColor blackColor] forState:0];
            sureBtn.layer.borderWidth = 1;
            sureBtn.layer.borderColor = LH_RGBCOLOR(234, 234, 234).CGColor;
        }
        
        [self.backView addSubview:sureBtn];
    }
}
#pragma mark *** Events ***
//单选
-(void)respondsToSureBtn:(UIButton *)sender{
    if ([sender.titleLabel.text isEqualToString:@"完成"]) {
        
        [_condDic setObject:self.minPrice.text forKey:@"min"];
        [_condDic setObject:self.maxPrice.text forKey:@"max"];
        
        if ([self.maxPrice.text integerValue] < [self.minPrice.text integerValue]) {
            [SXLoadingView showAlertHUD:@"筛选条件有误" duration:0.6];
        }else{
            NSLog(@"筛选条件---%@", _condDic);
            if (_delegate && [_delegate respondsToSelector:@selector(WfilterView:completeFilterDictionary:)]) {
                [_delegate WfilterView:self completeFilterDictionary:_condDic];
            };
            [self removeFromSuperview];
        }
    }else{
        //重置
        for (int idx = StartTag; idx<StartTag+3; idx++) {
            UIButton *btn = [self.backView viewWithTag:idx];
            [btn removeFromSuperview];
        }
        self.minPrice.text = @"";
        self.maxPrice.text = @"";
        [self initConditionLabelBtn];
        [_condDic removeAllObjects];
        
    }
}

-(void)respondsToCondiTionBtn:(UIButton *)sender{
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        [_condDic setObject:sender.titleLabel.text forKey:@"filter"];
    }else{
        [_condDic removeObjectForKey:@"filter"];
    }
    for (int idx = StartTag; idx<StartTag+3; idx++) {
        if (idx==sender.tag) {
            continue;
        }
        UIButton *btn = [self.backView viewWithTag:idx];
        btn.selected = false;
    }
}


/* 多选
-(void)respondsToSureBtn:(UIButton *)sender{
    if ([sender.titleLabel.text isEqualToString:@"完成"]) {
        [_condDic setObject:self.minPrice.text forKey:@"min"];
        [_condDic setObject:self.maxPrice.text forKey:@"max"];
        [_condDic setObject:_condiArr forKey:@"filter"];
        NSLog(@"筛选条件---%@", _condDic);
    }else{
        //重置
        for (int idx = StartTag; idx<StartTag+3; idx++) {
            UIButton *btn = [self.backView viewWithTag:idx];
            [btn removeFromSuperview];
        }
        self.minPrice.text = @"";
        self.maxPrice.text = @"";
        [self initConditionLabelBtn];
        [_condDic removeAllObjects];
        _condiArr = [@[@"",@"",@""] mutableCopy];
    }
}
-(void)respondsToCondiTionBtn:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [_condiArr replaceObjectAtIndex:(sender.tag-StartTag) withObject:sender.titleLabel.text];
    }else{
        [_condiArr replaceObjectAtIndex:(sender.tag-StartTag) withObject:@""];
    }
}
*/


#pragma mark *** getters ***
-(UIView *)backView{
    if (!_backView) {
        UIView *hafBlackView = [[UIView alloc] initWithFrame:self.bounds];
        hafBlackView.alpha = 0.5;
        hafBlackView.backgroundColor  = [UIColor blackColor];
        [self addSubview:hafBlackView];
        _backView = [[UIView alloc] initWithFrame:CGRectMake(30, 0, Screen_width-30, self.bounds.size.height)];
        _backView.backgroundColor = [UIColor whiteColor];
        
    }
    return _backView;
}
-(UITextField *)minPrice{
    if (!_minPrice) {
        
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:AdaptationFrame(21, 28, 200, 40)];
        priceLabel.text = @"价格区间(元)";
        priceLabel.font = WFont(30);
        [self.backView addSubview:priceLabel];
        
        _minPrice = [[UITextField alloc] initWithFrame:AdaptationFrame(130, 90, 180, 60)];
        _minPrice.placeholder = @"最低价";
        _minPrice.backgroundColor = LH_RGBCOLOR(242, 242, 242);
        _minPrice.textAlignment = 1;
        _minPrice.keyboardType = UIKeyboardTypeNumberPad;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectXW(self.minPrice)+7*AdaptationWidth(), CGRectY(self.minPrice)+CGRectGetHeight(self.minPrice.bounds)/2-1, 26*AdaptationWidth(), 1)];
        lineView.backgroundColor = [UIColor blackColor];
        [self.backView addSubview:lineView];
    }
    return _minPrice;
}
-(UITextField *)maxPrice{
    if (!_maxPrice) {
//        _maxPrice = [[UITextField alloc] initWithFrame:AdaptationFrame(350, 90, 180, 60)];
        _maxPrice = [self.minPrice deepCopy];
        _maxPrice.frame = AdaptationFrame(350, 90, 180, 60);
        _maxPrice.placeholder = @"最高价";
        _maxPrice.backgroundColor = self.minPrice.backgroundColor;
        _maxPrice.textAlignment = 1;
        _maxPrice.keyboardType = _minPrice.keyboardType;
        _maxPrice.delegate = self;
    }
    return _maxPrice;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:true];
}
@end
