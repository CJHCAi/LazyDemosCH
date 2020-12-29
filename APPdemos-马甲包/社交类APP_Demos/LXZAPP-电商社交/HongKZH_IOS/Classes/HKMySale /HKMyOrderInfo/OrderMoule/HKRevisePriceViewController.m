//
//  HKRevisePriceViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/3.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKRevisePriceViewController.h"
#import "RHKevisePrice.h"
#import "HKOrderFormViewModel.h"
@interface HKRevisePriceViewController ()
@property (nonatomic, strong)RHKevisePrice *evisePriceView;
@end

@implementation HKRevisePriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)setUI{
    [self.view addSubview:self.evisePriceView];
    [self.evisePriceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(10);
        make.height.mas_offset(160);
    }];
    self.title = @"修改地址";
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
}
-(void)saveData{
    [HKOrderFormViewModel sellerupdateorderprice:self.evisePriceView.parameter success:^(HKBaseResponeModel *responde) {
        if (responde.responeSuc) {
            if ([self.delegate respondsToSelector:@selector(sellerupdateorderpriceWithModel:)]) {
                [self.delegate sellerupdateorderpriceWithModel:self.evisePriceView.parameter];
            }
             [self.navigationController popViewControllerAnimated:YES];
        }
       
    }];
}
-(RHKevisePrice *)evisePriceView{
    if (!_evisePriceView) {
        _evisePriceView = [[RHKevisePrice alloc]init];
        
    }
    return _evisePriceView;
}
-(void)setModel:(HKOrderInfoData *)model{
    _model = model;
    self.evisePriceView.model = model;
}
@end
