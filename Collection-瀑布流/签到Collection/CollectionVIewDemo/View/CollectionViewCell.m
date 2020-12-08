//
//  CollectionViewCell.m
//  CollectionVIewDemo
//
//  Created by 栗子 on 2017/12/13.
//  Copyright © 2017年 http://www.cnblogs.com/Lrx-lizi/. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubviews];
    }
    return self;
}
-(void)addSubviews{
    
    self.iconBorder = [[UIImageView alloc]init];
    [self.contentView addSubview:self.iconBorder];
    [self.iconBorder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(16);
        make.centerX.equalTo(self.mas_centerX).offset(0);
        make.size.mas_offset(70);
    }];
    self.iconBorder.backgroundColor = [UIColor whiteColor];
    self.iconBorder.layer.cornerRadius = 35;
    //    self.iconBorder.layer.masksToBounds = YES;
    self.iconBorder.layer.borderWidth = 1.5;
    self.iconBorder.layer.borderColor =[UIColor lightGrayColor].CGColor;
    self.iconBorder.layer.shadowOffset = CGSizeMake(0,0);
    self.iconBorder.layer.shadowOpacity = 0.6;
    self.iconBorder.layer.shadowRadius = 2;
    
    
    self.iconIV = [[UIImageView alloc]init];
    [self.contentView addSubview:self.iconIV];
    [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconBorder.mas_centerY).offset(0);
        make.centerX.equalTo(self.mas_centerX).offset(0);
        make.size.mas_offset(60);
    }];
    self.iconIV.layer.cornerRadius = 60/2;
    self.iconIV.layer.masksToBounds = YES;
    
    //
    
    self.progressLB = [[UILabel alloc]init];
    [self.contentView addSubview:self.progressLB];
    [self.progressLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.iconIV.mas_bottom).offset(-7);
        make.right.equalTo(self.iconIV.mas_right).offset(10);
        make.width.mas_offset(35);
        make.height.mas_offset(12);
    }];
    self.progressLB.text = @"进行中";
    self.progressLB.font = [UIFont systemFontOfSize:8];
    self.progressLB.textColor = [UIColor whiteColor];
    self.progressLB.backgroundColor = [UIColor redColor];
    self.progressLB.textAlignment = NSTextAlignmentCenter;
    self.progressLB.layer.cornerRadius = 6;
    self.progressLB.layer.masksToBounds = YES;
    self.progressLB.hidden = YES;
    
    self.nameLB = [[UILabel alloc]init];
    [self.contentView addSubview:self.nameLB];
    [self.nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconIV.mas_bottom).offset(8);
        make.left.mas_offset(2);
        make.right.mas_offset(-2);
        make.height.mas_offset(15);
    }];
    self.nameLB.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    self.nameLB.textColor = [UIColor colorWithRed:155/255.0 green:155/255.0 blue:155/255.0 alpha:1/1.0];
    self.nameLB.textAlignment = NSTextAlignmentCenter;
    
    self.topLine = [[UIView alloc]init];
    [self.contentView addSubview:self.topLine];
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.bottom.equalTo(self.iconBorder.mas_top).offset(-2);
        make.width.mas_offset(2);
        make.centerX.equalTo(self.iconBorder.mas_centerX).offset(0);
    }];
    self.topLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    
    self.downLine = [[UIView alloc]init];
    [self.contentView addSubview:self.downLine];
    [self.downLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLB.mas_bottom).offset(0);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
        make.width.mas_offset(2);
        make.centerX.equalTo(self.iconBorder.mas_centerX).offset(0);
    }];
    self.downLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    
    self.leftLine = [[UIView alloc]init];
    [self.contentView addSubview:self.leftLine];
    [self.leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconBorder.mas_centerY).offset(0);
        make.height.mas_offset(2);
        make.left.mas_offset(0);
        make.right.equalTo(self.iconBorder.mas_left).offset(-2);
    }];
    self.leftLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.rightLine = [[UIView alloc]init];
    [self.contentView addSubview:self.rightLine];
    [self.rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconBorder.mas_centerY).offset(0);
        make.height.mas_offset(2);
        make.right.mas_offset(0);
        make.left.equalTo(self.iconBorder.mas_right).offset(2);
    }];
    self.rightLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.topLine.hidden = YES;
    self.downLine.hidden = YES;
    self.rightLine.hidden = YES;
    self.leftLine.hidden  = YES;
}
-(void)cellIndexPathRow:(NSInteger)row rowCount:(NSInteger)count{
    
    if (row%3==2 && row%2==0) {
        if (row ==count) {
            self.downLine.hidden = YES;
        }else{
            self.downLine.hidden = NO;
        }
        self.leftLine.hidden = NO;
        self.topLine.hidden = YES;
        self.rightLine.hidden = YES;
        
    }
    else if ((row%3==1 && row%2==1) ||(row%3==1 && row%2==0)){
        self.topLine.hidden = YES;
        self.downLine.hidden = YES;
        if (row==count) {//最后一个
            self.rightLine.hidden = YES;
        }else{
            self.rightLine.hidden = NO;
        }
        self.leftLine.hidden  = NO;
        
    } else if (row%3==0 && row%2==1){//第二个拐角及类似
        self.rightLine.hidden = NO;
        
        self.topLine.hidden = YES;
        self.leftLine.hidden = YES;
        
        NSInteger total = count+1;
        if (total%3==0 && row+2 == count ) {
            self.downLine.hidden = YES;
        }else{
            self.downLine.hidden = NO;
        }
        
    }else if ((row%3==2 &&row%2==0) ||(row%3==2 && row%2==1)){
        self.topLine.hidden = NO;
        self.leftLine.hidden = NO;
        self.downLine.hidden = YES;
        self.rightLine.hidden = YES;
    }else if (row%3==0 &&row%2==0){
        if (row==0) {
            self.topLine.hidden = YES;
        }else{
            self.topLine.hidden = NO;
        }
        if (row==count) {//最后一个
            self.rightLine.hidden = YES;
        }else{
            self.rightLine.hidden = NO;
        }
        self.leftLine.hidden = YES;
        self.downLine.hidden = YES;
    }
    else{
        self.topLine.hidden = YES;
        self.downLine.hidden = YES;
        self.rightLine.hidden = YES;
        self.leftLine.hidden  = YES;
    }
}
-(void)setDataModel:(CollectionModel *)dataModel{
    _dataModel =  dataModel;
    self.iconIV.image = dataModel.image;
    self.nameLB.text = dataModel.text;
}
-(void)setStatueModel:(CollectionModel *)statueModel{
    _statueModel = statueModel;
    if (statueModel.isComplete) {//已签到
        self.iconBorder.layer.borderWidth = 0;
        self.iconBorder.image = [UIImage imageNamed:@"sige"];
        self.iconIV.hidden = YES;
        self.progressLB.hidden = YES;
        self.iconBorder.layer.shadowColor = [UIColor clearColor].CGColor;
        self.iconBorder.layer.shadowOffset = CGSizeMake(0,0);
        NSString *title = [NSString stringWithFormat:@"%@",_dataModel.text];
        self.nameLB.text = title;
    }else{//未打卡
        self.iconBorder.layer.borderWidth = 1.5;
        if (statueModel.isSelected) {//是否选中
            self.progressLB.hidden = NO;
            self.iconIV.hidden = NO;
            self.iconBorder.image = [UIImage imageNamed:@" "];
            self.iconBorder.layer.shadowColor = [UIColor redColor].CGColor;
            self.iconBorder.layer.borderColor = [UIColor redColor].CGColor;
            self.iconBorder.layer.shadowOffset = CGSizeMake(0,2);
            NSString *title = [NSString stringWithFormat:@"%@",_dataModel.text];
            self.nameLB.text = title;
        }else{
            self.iconIV.hidden = YES;
            self.iconBorder.image = [UIImage imageNamed:@"unSige"];
            self.progressLB.hidden = YES;
            self.iconBorder.layer.shadowColor = [UIColor clearColor].CGColor;
            self.iconBorder.layer.shadowOffset = CGSizeMake(0,0);
            self.iconBorder.layer. borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
            self.nameLB.text = @"签到";
            
        }
    }
}
@end
