
//
//  HKShareCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/28.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKShareCell.h"
#import "ShareMessage.h"
#import "UIImageView+WebCache.h"
#import "LEFriendDbManage.h"
#import "HKBaseShareView.h"

@interface HKShareCell()<HKBaseShareViewDelegate>
@property (nonatomic, strong)HKBaseShareView *shareView;
@end

@implementation HKShareCell
+ (CGSize)sizeForMessageModel:(RCMessageModel *)model
      withCollectionViewWidth:(CGFloat)collectionViewWidth
         referenceExtraHeight:(CGFloat)extraHeight{
    return CGSizeMake(kScreenWidth, 70+extraHeight);
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}
-(void)initialize{

    [self.messageContentView addSubview:self.shareView];

}
- (void)setDataModel:(RCMessageModel *)model{
    [super setDataModel:model];
    ShareMessage*message = (ShareMessage*)model.content;

//    HKExtraMessage*extra = [HKExtraMessage mj_objectWithKeyValues:message.extra];
    HKFriendModel*fM = [[HKFriendModel alloc]init];
    fM.uid = model.userInfo.userId;
    HKFriendModel *item = (HKFriendModel*)[[LEFriendDbManage sharedZSDBManageBaseModel]queryWithModel:fM];
    UIImageView*iconView = (UIImageView*)self.portraitImageView;
    [iconView sd_setImageWithURL:[NSURL URLWithString:item.headImg] placeholderImage:kPlaceholderImage];
    self.shareView.message = message;
    if (model.messageDirection == 1) {
        [self.shareView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(self.messageContentView);
            make.left.equalTo(self.messageContentView).offset(self.messageContentViewWidth - 244);
        }];
    }else{
        [self.shareView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self.messageContentView);
            make.right.equalTo(self.messageContentView).offset(244-self.messageContentViewWidth);
        }];
    }
}
-(HKBaseShareView *)shareView{
    if (!_shareView) {
        _shareView = [[HKBaseShareView alloc]init];
        _shareView.delegate = self;
    }
    return _shareView;

}
-(void)contentClick{
    if ([self.delegate respondsToSelector:@selector(didTapMessageCell:)]) {
        [self.delegate didTapMessageCell:self.model];
    }
}
@end
