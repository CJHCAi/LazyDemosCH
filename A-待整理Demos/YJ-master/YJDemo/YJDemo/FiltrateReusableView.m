//
//  FiltrateReusableView.m
//  JingBanYun
//
//  Created by zhu on 2017/5/5.
//  Copyright © 2017年 YJ. All rights reserved.
//

#import "FiltrateReusableView.h"

@implementation FiltrateReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setDic:(NSDictionary *)dic {
    _dic = dic;
    self.titleLab.text = dic[@"name"];
    if([dic[@"switch"] integerValue]==1){//展开
        self.rightBtn.selected=YES;
    }else{//关闭
        self.rightBtn.selected=NO;
        
    }
    [self showAnimateDown:self.rightBtn.selected];
    
    NSString *stateStr = dic[@"showRight"];
    if([stateStr isEqualToString:@"1"]){
        self.rightBtn.hidden = NO;
    }else{
        self.rightBtn.hidden = YES;
    }

}

- (IBAction)pressBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self showAnimateDown:sender.selected];
    
    if(self.filtrateReusableViewBlock){
        self.filtrateReusableViewBlock(sender.selected,self.index);
    }
    
    
}
-(void)showAnimateDown:(BOOL)isON{
    CABasicAnimation *animate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animate.duration = 0.5;
    animate.beginTime = 0;
    if(isON){
        animate.toValue = @(M_PI);
    }else{
        animate.toValue = @(0);
    }
    animate.removedOnCompletion = NO;
    animate.fillMode = kCAFillModeForwards;
    [self.rightBtn.layer addAnimation:animate forKey:nil];
}
@end
