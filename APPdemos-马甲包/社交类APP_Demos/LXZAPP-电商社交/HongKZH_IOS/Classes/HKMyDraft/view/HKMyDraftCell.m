//
//  HKMyDraftCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/8.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMyDraftCell.h"
#import "SaveMediaTool.h"

@interface HKMyDraftCell()
@property (weak, nonatomic) IBOutlet UIImageView *coverImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation HKMyDraftCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.coverImgView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)setDraft:(HKReleaseVideoSaveDraft *)draft {
    if (draft) {
        _draft = draft;
        self.coverImgView.image = [SaveMediaTool getImgWithImageName:draft.coverImgSrc];
        NSDictionary *dict = [draft.paramDictJSON mj_JSONObject];
        
        self.titleLabel.text = [dict objectForKey:@"title"];
        NSDictionary *categoryDict = [draft.categroyJSON mj_JSONObject];
        HK_BaseAllCategorys *category = [HK_BaseAllCategorys mj_objectWithKeyValues:categoryDict];
        self.categoryLabel.text = category.name;
        self.timeLabel.text = draft.curTime;
    }
}


@end
