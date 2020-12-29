//
//  HKMyPostShareTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/7.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMyPostShareTableViewCell.h"
#import "HKMyPostNameView.h"
#import "UIImageView+HKWeb.h"
#import "HKMydyamicDataModel.h"
@interface HKMyPostShareTableViewCell()<PostNameClickDelegete>
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet HKMyPostNameView *nameView;
@property (weak, nonatomic) IBOutlet UIImageView *iconVIew;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet HKMyPostToolVIew *toolView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imagew;
@property (weak, nonatomic) IBOutlet UILabel *shareType;
@property (weak, nonatomic) IBOutlet UIImageView *shareIcon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWs;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolH;

@end

@implementation HKMyPostShareTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.toolView.delegate = self;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)setModel:(HKMyPostModel *)model{
    [super setModel:model];
    if (model.userName.length==0&&model.uName.length == 0) {
        self.toolView.hidden = NO;
        self.toolH.constant = 52;
        self.toolView.model = model;
        self.nameView.model = model;
        self.nameView.delegete = self;
    }else{
        self.toolView.hidden = YES;
        self.toolH.constant = 0;
        HKMyPostModel*nameModel = [[HKMyPostModel alloc]init];
        nameModel.name = model.userName;
        nameModel.uName = model.uName;
        nameModel.headImg = model.headImg;
        nameModel.createDate = model.createDate;
        nameModel.title = model.name;
        nameModel.isShowLabel = YES;
        self.nameView.model = nameModel;
        self.nameView.delegete = self;
    }

    if (model.coverImgSrc.length < 5) {
        self.imagew.constant = 0;
    }else{
        self.imagew.constant = 75;
        [self.iconVIew hk_sd_setImageWithURL:model.coverImgSrc placeholderImage:kPlaceholderImage];
    }
    if (model.type.intValue == 2) {
        self.titleView.text = @"转发帖子";
        self.content.text = model.title;
    }else if (model.type.intValue == 3){
        self.titleView.text = @"分享帖子";
        self.content.text = model.title;
    }else if(model.type.intValue == 11){
        self.titleView.text = @"攒了你的帖子";
        self.content.text = model.title;
    }else if(model.type.intValue == 12){
        self.titleView.text = @"转发你的帖子";
        self.content.text = model.title;
    }else{
        self.titleView.text = model.title;
        self.content.text = model.content;
    }
    
    if (model.model == MyPostType_Travels) {
        self.imageWs.constant = 0;
        self.shareIcon.hidden = YES;
        self.shareType.hidden = NO;
        self.shareType.text = @"游记";
    }else if (model.model == MyPostType_Advertising){
        self.imageWs.constant = 20;
        self.shareIcon.hidden = NO;
        self.shareType.hidden = NO;
        self.shareType.text = @"广告";
        self.shareIcon.image = [UIImage imageNamed:@"red_img"];
    }else if (model.model == MyPostType_MediaMVoideo){
        self.imageWs.constant = 0;
        self.shareIcon.hidden = NO;
        self.shareIcon.image = [UIImage imageNamed:@"enterprise_play"];
        self.shareType.hidden = YES;
    }else{
        self.shareIcon.hidden = YES;
        self.shareType.hidden = YES;
    }
}
-(void)setDataModel:(HKMydyamicDataModel *)dataModel{
    [super setDataModel:dataModel];
    self.toolView.hidden = YES;
    //self.toolView.hidden = NO;
    self.toolH.constant = 52;
    HKMyPostModel*commcout = [[HKMyPostModel alloc]init];
    commcout.commitCount = dataModel.commentCount;
    commcout.praiseCount = [NSString stringWithFormat:@"%d",dataModel.praiseCount];
    self.toolView.model = commcout;
    HKMyPostModel*nameModel = [[HKMyPostModel alloc]init];
    nameModel.name = dataModel.name;
    nameModel.headImg = dataModel.headImg;
    nameModel.createDate = dataModel.createDate;
    nameModel.uid =dataModel.uid;
    self.model = nameModel;
    self.nameView.model = nameModel;
    self.nameView.delegete = self;
    if (!dataModel.coverImgSrc.length) {
        self.imagew.constant = 0;
    }else{
        self.imagew.constant = 75;
        [self.iconVIew hk_sd_setImageWithURL:dataModel.coverImgSrc placeholderImage:kPlaceholderImage];
    }
        //self.titleView.text = @"";
        self.shareIcon.hidden = YES;
        self.shareType.hidden = YES;

}

#pragma mark  PostNameClickDelegete
-(void)clickHeader:(NSString *)headImg userName:(NSString *)name uid:(NSString *)uid {
    if (self.delegate && [self.delegate respondsToSelector:@selector(showUserDetailWithModel:)]) {
        [self.delegate showUserDetailWithModel:self.model];
    }
}
-(void)repostUserWithUid:(NSString *)uid {
    if (self.delegate && [self.delegate respondsToSelector:@selector(showActionSheetWithModel:andIndexPath:)]) {
        [self.delegate showActionSheetWithModel:self.model andIndexPath:self.indexPath];
    }
}
-(void)setIsHideTool:(BOOL)isHideTool{
    [super setIsHideTool:isHideTool];
    if (isHideTool) {
        self.toolView.hidden = isHideTool;
        self.toolH.constant = 0;
    }else{
        self.toolView.hidden = isHideTool;
        self.toolH.constant = 52;
    }
   
}
@end
