//
//  HKCircleSetting TableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCircleSetting_TableViewCell.h"
#import "HKMyCircleData.h"
#import "UIImageView+HKWeb.h"
#import "HKCommodityDisplayView.h"
#import "HKProductsModel.h"
@interface HKCircleSetting_TableViewCell()<PurchaseGoodsDelegete>
@property (weak, nonatomic) IBOutlet UIImageView *groupHeadImage;
@property (weak, nonatomic) IBOutlet UILabel *groupName;
@property (weak, nonatomic) IBOutlet UILabel *groupDesc;
@property (weak, nonatomic) IBOutlet UILabel *numLimit;
@property (weak, nonatomic) IBOutlet UILabel *method;
@property (weak, nonatomic) IBOutlet UILabel *channel;
@property (weak, nonatomic) IBOutlet HKCommodityDisplayView *showcommodity;
@property (weak, nonatomic) IBOutlet UIView *memberManagerView;

@end

@implementation HKCircleSetting_TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   //更换封面
    self.groupHeadImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapG =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickH)];
    [self.groupHeadImage addGestureRecognizer:tapG];
   //修改圈子标题..
    self.groupName.userInteractionEnabled = YES;
    UITapGestureRecognizer *tagName =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickName)];
    [self.groupName addGestureRecognizer:tagName];
    //修改圈子简介
    self.groupDesc.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapDes =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickDes)];
    [self.groupDesc addGestureRecognizer:tapDes];
    //修改成员上限
    self.numLimit.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapNum =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickNum)];
    [self.numLimit addGestureRecognizer:tapNum];
   //修改验证方式
    self.method.userInteractionEnabled =YES;
    UITapGestureRecognizer * tapValite =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickValite)];
    [self.method addGestureRecognizer:tapValite];
    //修改频道
    self.channel.userInteractionEnabled = YES;
    UITapGestureRecognizer * tapChannel =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickChannel)];
    [self.channel addGestureRecognizer:tapChannel];
    //成员管理
    self.memberManagerView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tapMem =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMember)];
    [self.memberManagerView addGestureRecognizer:tapMem];
    self.showcommodity.delegete = self;
    
}
-(void)purchase {
    if (self.delegete && [self.delegete respondsToSelector:@selector(updateGoodsNumber)]) {
        [self.delegete updateGoodsNumber];
    }
}
-(void)selectGoods {
    if (self.delegete && [self.delegete respondsToSelector:@selector(chooseProduct)]) {
        [self.delegete chooseProduct];
    }
}
-(void)clickMember {
    if (self.delegete && [self.delegete respondsToSelector:@selector(pushMemberVc)]) {
        [self.delegete pushMemberVc];
    }
}
-(void)clickChannel {
    if (self.delegete && [self.delegete respondsToSelector:@selector(updateCaterGrory)]) {
        [self.delegete updateCaterGrory];
    }
}
-(void)clickNum {
    if (self.delegete && [self.delegete respondsToSelector:@selector(updateNumCount)]) {
        [self.delegete updateNumCount];
    }
}
-(void)clickValite {
    if (self.delegete && [self.delegete respondsToSelector:@selector(updateJoinMethod)]) {
        [self.delegete updateJoinMethod];
    }
}
-(void)clickDes {
    if (self.delegete && [self.delegete respondsToSelector:@selector(updateDescInfo)]) {
        [self.delegete updateDescInfo];
    }
}
-(void)clickName {
    if (self.delegete && [self.delegete respondsToSelector:@selector(updateCicleName)]) {
        [self.delegete updateCicleName];
    }
}
-(void)clickH {
    if (self.delegete && [self.delegete respondsToSelector:@selector(updateCoverImage)]) {
        [self.delegete updateCoverImage];
    }
}
+(instancetype)circleSetting_TableViewCellWithTableView:(UITableView*)tableView{
    NSString*ID = @"HKCircleSetting_TableViewCell";
    
    HKCircleSetting_TableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"HKCircleSetting_TableViewCell" bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
-(void)setModel:(HKMyCircleData *)model{
    _model = model;
    if (model.coverImg) {
        self.groupHeadImage.image =model.coverImg;
    }else {
         [self.groupHeadImage hk_sd_setImageWithURL:model.coverImgSrc placeholderImage:kPlaceholderImage];
    }
    self.groupName.text = model.name;
    self.groupDesc.text = model.introduction;
    self.channel.text = model.categoryName;
    self.numLimit.text = [NSString stringWithFormat:@"%d",model.upperLlimit];
    NSString *text = model.isValidate? @"需经圈主同意":@"任何人可加入";
    self.method.text = text;
    NSMutableArray*imageArray = [NSMutableArray arrayWithCapacity:model.products.count];
    
    for (HKProductsModel*pM in model.products) {
        [imageArray addObject:pM.imgSrc];
    }
    [self.showcommodity setImageArray:imageArray imagenum:model.num];
    
    
}




@end
