//
//  HKSelectFreightProCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKSelectFreightProCell.h"
@interface HKSelectFreightProCell()
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectbtn;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *rightIcon;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation HKSelectFreightProCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.backBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1]] forState:UIControlStateSelected];
    [self.backBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
}
-(void)setModel:(MediaareasInits *)model{
    _model = model;
    self.name.text = model.name;
}
-(void)setSelectType:(int)selectType{
    _selectType = selectType;
    if (selectType < 0) {
        self.rightIcon.hidden = YES;
        self.btn.hidden = YES;
        self.backBtn.selected = YES;
    }else{
        self.backBtn.selected = NO;
        self.btn.hidden = NO;
        self.rightIcon.hidden = NO;
    }
    [UIView animateWithDuration:0.5 animations:^{
        if (selectType == 1) {
            self.rightIcon.transform =  CGAffineTransformMakeRotation(M_PI*0.5);
        }else{
            self.rightIcon.transform =  CGAffineTransformMakeRotation(-M_PI*0);
        }
    }];
 
}
- (IBAction)btnClick:(id)sender {
    self.selectType = !self.selectType;
    self.model.isSelect = self.selectType;
    if (self.block) {
        self.block();
    }
}
-(void)setIsSelcted:(BOOL)isSelcted{
    _isSelcted = isSelcted;
    if (isSelcted) {
        self.selectbtn.userInteractionEnabled = NO;
        [self.selectbtn setBackgroundImage:[UIImage imageNamed:@"limit_gray"] forState:UIControlStateSelected];
        [self.selectbtn setBackgroundImage:[UIImage imageNamed:@"limit_gray"] forState:0];
        self.selectbtn.selected = YES;
    }else{
        self.selectbtn.userInteractionEnabled = YES;
        [self.selectbtn setBackgroundImage:[UIImage imageNamed:@"limit_white"] forState:0];
         [self.selectbtn setBackgroundImage:[UIImage imageNamed:@"limit_red"] forState:UIControlStateSelected];
        self.selectbtn.selected = NO;
    }
}
- (IBAction)selectBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.selectBlcok) {
        self.selectBlcok(self.model, sender.selected);
    }
}
-(void)setIsNewSelect:(BOOL)isNewSelect{
    _isNewSelect = isNewSelect;
    self.selectbtn.selected = isNewSelect;
}
@end
