//
//  HKReplysTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKReplysTableViewCell.h"
#import "ZSUserHeadBtn.h"
#import "UIButton+ZSYYWebImage.h"
@interface HKReplysTableViewCell()
@property (weak, nonatomic) IBOutlet ZSUserHeadBtn *headBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UILabel *desc;

@end

@implementation HKReplysTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(MediaAdvCommentReplyListModels *)model{
    _model = model;
    [self.headBtn hk_setBackgroundImageWithURL:model.headImg forState:0 placeholder:kPlaceholderHeadImage];
    self.titleView.text = model.content;
    self.desc.text = [NSString stringWithFormat:@"%@·%@",model.uName,model.createDate];
}
@end
