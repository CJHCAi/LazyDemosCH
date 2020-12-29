//
//  HKMyEditPostTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/8.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMyEditPostTableViewCell.h"
#import "HKMyPostNameView.h"
#import "LHPhotosView.h"
#import "ImageListModel.h"
#import "HKMydyamicDataModel.h"
@interface HKMyEditPostTableViewCell()<PostNameClickDelegete>
@property (weak, nonatomic) IBOutlet HKMyPostNameView *headView;
@property (weak, nonatomic) IBOutlet UILabel *titleVIew;
@property (weak, nonatomic) IBOutlet LHPhotosView *photosView;
@property (weak, nonatomic) IBOutlet HKMyPostToolVIew *toolView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phothH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolH;

@end

@implementation HKMyEditPostTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.toolView.delegate = self;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)setModel:(HKMyPostModel *)model{
    [super setModel:model];
    self.headView.model = model;
    self.headView.delegete =self
    ;
    self.toolView.model = model;
    self.titleVIew.text = model.title;
    if (model.imgList.count <= 0) {
        self.phothH.constant = 0;
        self.photosView.hidden = YES;
    }else{
        self.photosView.hidden = NO;
        NSMutableArray*imageArray = [NSMutableArray arrayWithCapacity:model.imgList.count];
        for (NSString*url in model.imgList) {
            ImageListModel*modelI = [[ImageListModel alloc]init];
            modelI.fileUrl = url;
            [imageArray addObject:modelI];
        }
        
        
        if (model.imgList.count == 1) {
            self.phothH.constant = 200;
        }else{
            CGSize size = [LHPhotosView sizeWithPhotosCount:(int)model.imgList.count andTag:0];
            self.phothH.constant = size.height;
        }
        self.photosView.pic_urls = imageArray;
//
//        if (model.imgList.count == 1) {
//            self.phothH.constant = 200;
//        }else if (model.imgList.count == 2){
//            self.phothH.constant = (kScreenWidth - 30 - 7)*0.5;
//        }else if(model.imgList.count == 4){
//            self.phothH.constant = (kScreenWidth - 30 - 7)+7;
//        }else{
//            NSInteger row = model.imgList.count/3;
//            if (model.imgList.count%3>0) {
//                row ++;
//            }
//            self.phothH.constant = (kScreenWidth -30 -14)*row+(row-1)*7;
//        }
    }
}
-(void)setDataModel:(HKMydyamicDataModel *)dataModel{
    [super setDataModel:dataModel];
    HKMyPostModel*commcout = [[HKMyPostModel alloc]init];
    commcout.commitCount = dataModel.commentCount;
    commcout.praiseCount = [NSString stringWithFormat:@"%d",dataModel.praiseCount];
    self.toolView.model = commcout;
    HKMyPostModel*nameModel = [[HKMyPostModel alloc]init];
    nameModel.name = dataModel.name;
    nameModel.headImg = dataModel.headImg;
    nameModel.createDate = dataModel.createDate;
    nameModel.uid = dataModel.uid;
    self.headView.model = nameModel;
    self.model = nameModel;
    self.headView.delegete = self;
    self.titleVIew.text = dataModel.title;
    
    self.toolView.hidden = YES;
    self.toolH.constant = 0;
    if (dataModel.coverImgSrc.length) {
        self.photosView.hidden =YES;
        self.phothH.constant =0;
    }else {
        self.photosView.hidden = NO;
        self.phothH.constant = 200;
    }
    ImageListModel*imageM = [[ImageListModel alloc]init];
    imageM.fileUrl = dataModel.coverImgSrc;
        self.photosView.pic_urls = @[imageM];

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
