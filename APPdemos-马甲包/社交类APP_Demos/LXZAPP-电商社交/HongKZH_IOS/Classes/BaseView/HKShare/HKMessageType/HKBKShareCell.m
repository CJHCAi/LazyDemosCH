//
//  HKBKShareCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/17.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBKShareCell.h"
#import "HKBursingtShareView.h"
#import "HKBurstingActivityShareModel.h"
@interface HKBKShareCell()<HKBursingtShareViewDelegate>
@property (nonatomic, strong)HKBursingtShareView *shareView;
@end

@implementation HKBKShareCell
+ (CGSize)sizeForMessageModel:(RCMessageModel *)model
      withCollectionViewWidth:(CGFloat)collectionViewWidth
         referenceExtraHeight:(CGFloat)extraHeight{
    return CGSizeMake(kScreenWidth, 133+extraHeight);
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
    self.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
 
    [self.messageContentView addSubview:self.shareView];
    
}
- (void)setDataModel:(RCMessageModel *)model{
    [super setDataModel:model];
    HKBurstingActivityShareModel*bshare =(HKBurstingActivityShareModel*)model.content;
    self.shareView.model =bshare;
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
-(void)gotoBurstingActivity{
    if ([self.delegate respondsToSelector:@selector(didTapMessageCell:)]) {
        [self.delegate didTapMessageCell:self.model];
    }
    
}
-(HKBursingtShareView *)shareView{
    if (!_shareView) {
        _shareView = [[HKBursingtShareView alloc]init];
        _shareView.delegate = self;
    }
    return _shareView;
}
@end
