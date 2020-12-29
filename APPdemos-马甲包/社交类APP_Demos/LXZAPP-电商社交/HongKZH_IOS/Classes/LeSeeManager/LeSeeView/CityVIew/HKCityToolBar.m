//
//  HKCityToolBar.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/31.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCityToolBar.h"

@interface HKCityToolBar ()

@property (nonatomic, strong)NSMutableArray * btnArray;

@end

@implementation HKCityToolBar

-(NSMutableArray *)btnArray {
    if (!_btnArray) {
        _btnArray =[[NSMutableArray alloc] init];
    }
    return _btnArray;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setSubViews];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
        [self setSubViews];
    }
    return self;
}
-(void)setSubViews {
    NSArray * imageArr = @[@"city_collection",@"city_comment",@"city_praise",@"city_reward",@"city_buy"];
    NSArray *selectArr =@[@"city_collectionH",@"city_comment",@"city_praiseH",@"city_reward",@"city_buy"];
    NSArray*titleArray = @[@"打赏",@"售卖"];
    if (![[VersionAuditStaueTool sharedVersionAuditStaueTool]isAuditAdopt]) {
        imageArr = @[@"city_collection",@"city_comment",@"city_praise",@"city_buy"];
        selectArr =@[@"city_collectionH",@"city_comment",@"city_praiseH",@"city_buy"];
        titleArray = @[@"售卖"];
    }
    
    
    CGFloat btnW = kScreenWidth /imageArr.count;
    for (int i =0 ; i<imageArr.count; i++) {
        UIButton * btn =[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*btnW,0,btnW,50);
        UIView *line =[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame)-1,15,1,20)];
        line.backgroundColor =[UIColor groupTableViewBackgroundColor];
        [self addSubview:btn];
        [self addSubview:line];
        [btn setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:selectArr[i]] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor colorFromHexString:@"333333"] forState:UIControlStateNormal];
        btn.titleLabel.font =PingFangSCRegular14;
        if (i==3) {
            [btn setTitle:titleArray.firstObject forState:UIControlStateNormal];
        }else if (i==4){
            [btn setTitle:titleArray.lastObject forState:UIControlStateNormal];
        }
        btn.tag =10+i;
        [btn addTarget:self action:@selector(hanleClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnArray addObject:btn];
    }
}
-(void)hanleClick:(UIButton *)sender {
    if (self.delegete && [self.delegete respondsToSelector:@selector(ClickSender:andSenderTag:)]) {
        [self.delegete ClickSender:sender andSenderTag:sender.tag];
    }
}
-(void)setResponse:(HKCityTravelsRespone *)response {
    _response = response;
    UIButton * btn1 =self.btnArray.firstObject;
    [btn1 setTitle:response.data.praiseCount forState:UIControlStateNormal];
    UIButton *btn2 =self.btnArray[1];
    [btn2 setTitle:response.data.commentCount forState:UIControlStateNormal];
    UIButton *btn3 =self.btnArray[2];
    [btn3 setTitle:response.data.collectionCount forState:UIControlStateNormal];
    if (response.data.praiseState.intValue) {
        btn1.selected = YES;
    }
    if (response.data.collectionState.intValue) {
        btn3.selected = YES;
    }
}


@end
