//
//  HKToolCommtiTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKToolCommtiTableViewCell.h"
#import "ZSUserHeadBtn.h"
#import "UIButton+ZSYYWebImage.h"
#import "HKSelfMeidaVodeoViewModel.h"
@interface HKToolCommtiTableViewCell()
@property (weak, nonatomic) IBOutlet ZSUserHeadBtn *headBtn;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UILabel *zanNUm;
@property (weak, nonatomic) IBOutlet UILabel *commitNum;
@property (weak, nonatomic) IBOutlet UIButton *fhNum;
@property (weak, nonatomic) IBOutlet UIButton *zBtn;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *down;

@end

@implementation HKToolCommtiTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(void)setModel:(InfoMediaAdvCommentListModels *)model{
    _model = model;
    [self.headBtn hk_setBackgroundImageWithURL:model.headImg forState:UIControlStateNormal placeholder:kPlaceholderHeadImage];
    self.name.text = model.content;
    self.desc.text = [NSString stringWithFormat:@"%@·%@",model.uName,model.createDate];
    self.zanNUm.text = model.praiseCount;
    self.commitNum.text = model.commentCount;
    [self.fhNum setTitle:[NSString stringWithFormat:@"查看%@条回复",model.commentCount] forState:0];
        self.zBtn.selected = model.praiseState.integerValue;
    
}
-(void)setType:(int)type{
    _type = type;
    if (type == 0) {
        self.down.constant = 15;
        self.fhNum.hidden = NO;
    }else{
        self.down.constant = 0;
        self.fhNum.hidden = YES;;
    }
}
- (IBAction)praise:(id)sender {
    NSString*staue = @"1";
    if (self.model.praiseState.integerValue == 1) {
        staue = @"0";
    }
    [HKSelfMeidaVodeoViewModel praiseMediaAdvComment:@{@"commentId":self.model.commentId,@"loginUid":HKUSERLOGINID,@"state":staue} type:0 success:^(HKBaseResponeModel *responde) {
        if (responde.responeSuc) {
            self.model.praiseCount = ((NSDictionary*)responde.data)[@"praiseCount"];
            self.model.praiseState = staue;
            self.model = _model;
        }
    }];
}
- (IBAction)comment:(id)sender {
    if ([self.delegate respondsToSelector:@selector(commitWithAdvCommentModel:)]) {
        [self.delegate commitWithAdvCommentModel:self.model];
    }
}
@end
