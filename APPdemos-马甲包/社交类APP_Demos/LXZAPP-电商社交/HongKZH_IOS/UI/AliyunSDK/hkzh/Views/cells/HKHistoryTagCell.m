//
//  HKHistoryTagCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/7/28.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKHistoryTagCell.h"
#import "HKHistoryTagView.h"

@interface HKHistoryTagCell ()<HKHistoryTagViewDelegate>

@property (weak, nonatomic) IBOutlet HKHistoryTagView *tagView;
@end

@implementation HKHistoryTagCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.tagView.delegate = self;
}
-(void)historyTagViewBlock:(HK_AllTagsHis *)tagHis{
    self.block(tagHis);
}
- (void)setTagItems:(NSArray *)tagItems {
    if (tagItems && [tagItems count] >0) {
        _tagItems = tagItems;
        self.tagView.hisTags = tagItems;
    }
}

@end
