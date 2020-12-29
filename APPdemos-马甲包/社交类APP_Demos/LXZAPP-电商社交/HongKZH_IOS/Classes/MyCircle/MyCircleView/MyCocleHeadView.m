//
//  MyCocleHeadView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "MyCocleHeadView.h"
#import "HKImageShowView.h"
#import "ZSUserHeadBtn.h"
#import "UIButton+ZSYYWebImage.h"
#import "HKMyCircleData.h"
#import "HKProductsModel.h"
@interface MyCocleHeadView()<HKImageShowViewDelegate>
@property (weak, nonatomic) IBOutlet ZSUserHeadBtn *headBtn;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *num;
@property (weak, nonatomic) IBOutlet HKImageShowView *commodity;
@property (weak, nonatomic) IBOutlet UILabel *setTop;
@property (weak, nonatomic) IBOutlet UILabel *notice;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;

@property (weak, nonatomic) IBOutlet UIButton *publish;
@property (weak, nonatomic) IBOutlet UIButton *essence;
@property (weak, nonatomic) IBOutlet UIImageView *groupImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commdityH;

@property (nonatomic, copy) NSString *setTopPostId;
@property (nonatomic, copy) NSString *setNoticePostId;

@end

@implementation MyCocleHeadView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"MyCocleHeadView" owner:self options:nil].lastObject;
        self.frame = frame;
        UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addGroup:)];
        self.groupImage.userInteractionEnabled = YES;
        [self.groupImage addGestureRecognizer:tap];
        self.commodity.delegate =self;
        
   //公告和置顶 加 点击事件.....
        UITapGestureRecognizer * tapTop =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TopClick)];
        self.setTop.userInteractionEnabled = YES;
        [self.setTop addGestureRecognizer:tapTop];
        UITapGestureRecognizer * tapNotice =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(NoticeClick)];
        self.notice.userInteractionEnabled = YES;
        [self.notice addGestureRecognizer:tapNotice];
    }
    return self;
}
-(void)setModel:(HKMyCircleData *)model{
    _model = model;
    [self.headBtn hk_setBackgroundImageWithURL:model.coverImgSrc forState:0 placeholder:kPlaceholderImage];
    self.name.text = model.name;
    self.num.text = [NSString stringWithFormat:@"%@∙%ld人",model.categoryName,model.members.count];
    NSMutableArray*imageArray = [NSMutableArray arrayWithCapacity:model.products.count];
    for (HKProductsModel*pModel in model.products) {
        [imageArray addObject:pModel.imgSrc];
    }
    if (imageArray.count>0) {
        self.commdityH.constant = 70;
        self.height = 375;
        self.commodity.imageArray = imageArray;
    }else{
        self.height = 305;
        self.commdityH.constant = 0;
    }
    
    if (model.posts.count) {
        for (HKMyPostModel * p in model.posts) {
            if (p.isNotice.integerValue) {
                self.notice.text =p.title;
                self.setNoticePostId =p.postId;
            }else {
                continue;
            }
        }
        for (HKMyPostModel * p in model.posts) {
            if (p.isTop.integerValue) {
                self.setTop.text =p.title;
                self.setTopPostId =p.postId;
            }else {
                continue;
            }
        }
    }else {
        self.notice.text =@"暂无公告通知";
        self.setTop.text =@"暂无置顶消息";
    }
    if (!self.setNoticePostId.length) {
         self.notice.text =@"暂无公告通知";
    }
    if (!self.setTopPostId.length) {
        self.setTop.text =@"暂无置顶消息";
    }

#pragma mark 查看是否加入圈子修改状态..
    if (model.state == 1) {
        
        self.groupImage.image =[UIImage imageNamed:@"add_circle"];
    }else {
        
        self.groupImage.image =[UIImage imageNamed:@"group_moreP"];
        
    }
}
//点击置顶
-(void)TopClick {
    if (self.setTopPostId.length) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(pushTopPostWithPostId:)]) {
            [self.delegate pushTopPostWithPostId:self.setTopPostId];
        }
    }
}
//点击通知
-(void)NoticeClick {
    if (self.setNoticePostId.length) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(pushNoticeWithPostId:)]) {
            [self.delegate pushNoticeWithPostId:self.setNoticePostId];
        }
    }
}
- (IBAction)headBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(toVcheadBtnClick)]) {
        [self.delegate toVcheadBtnClick];
    }
}
-(void)addGroup:(UITapGestureRecognizer*)sender{
    if ([self.delegate respondsToSelector:@selector(toAddGroup)]) {
        [self.delegate toAddGroup];
    }
}
-(void)gotoShopping:(NSInteger)tag{
    if ([self.delegate respondsToSelector:@selector(gotoShoppingVc:)]) {
        [self.delegate gotoShoppingVc:tag];
    }
}
- (IBAction)postSenderClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(swichSenderTag:)]) {
        [self.delegate swichSenderTag:sender.tag];
    }
}

@end
