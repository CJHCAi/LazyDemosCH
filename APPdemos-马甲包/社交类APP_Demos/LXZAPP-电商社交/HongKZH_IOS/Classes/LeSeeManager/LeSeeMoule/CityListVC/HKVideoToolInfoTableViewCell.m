//
//  HKVideoToolInfoTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKVideoToolInfoTableViewCell.h"
#import "GetMediaAdvAdvByIdRespone.h"
#import "HKMyPostNameView.h"
#import "HKMyPostsRespone.h"
@interface HKVideoToolInfoTableViewCell()
@property (nonatomic,weak) IBOutlet HKMyPostNameView *nameView;
@property (nonatomic,weak) IBOutlet UILabel *titleVIew;
@end

@implementation HKVideoToolInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(void)setResponde:(GetMediaAdvAdvByIdRespone *)responde{
    _responde = responde;
    HKMyPostModel *model = [[HKMyPostModel alloc]init];
    model.name = responde.data.uName;
    model.createDate = responde.data.createDate;
    model.isShowLabel = YES;
    model.headImg = responde.data.headImg;
    self.nameView.model = model;
    self.titleVIew.text = self.responde.data.title;

}
-(void)setCityResponse:(HKCityTravelsRespone *)cityResponse {
    _cityResponse = cityResponse;
    HKMyPostModel *model = [[HKMyPostModel alloc]init];
    model.name = cityResponse.data.name;
    model.createDate = cityResponse.data.createDate;
    model.isShowLabel = YES;
    model.headImg = cityResponse.data.headImg;
    self.nameView.model = model;
    self.titleVIew.text = cityResponse.data.title;
}

@end
