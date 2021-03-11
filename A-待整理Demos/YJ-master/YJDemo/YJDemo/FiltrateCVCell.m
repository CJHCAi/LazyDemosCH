//
//  FiltrateCVCell.m
//  JingBanYun
//
//  Created by zhu on 2017/5/5.
//  Copyright © 2017年 YJ. All rights reserved.
//

#import "FiltrateCVCell.h"

@implementation FiltrateCVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}
-(void)setDic:(NSDictionary *)dic {
    _dic = dic;
    self.titleLab.text = dic[@"name"];
    if([dic[@"showclose"] integerValue]==1){
        self.imgView.hidden = NO;
        [self.imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(20);
        }];
        self.bgView.backgroundColor = GreenFont;
        self.titleLab.textColor = [UIColor whiteColor];
    }else{
        
        self.imgView.hidden = YES;
        [self.imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
            
        }];
        self.bgView.backgroundColor = UIColorFromRGB(0xF0EFF0);
        self.titleLab.textColor = [UIColor blackColor];



    }
}



@end
