//
//  HKSearchHeadCollectionViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKSearchHeadCollectionViewCell.h"
@interface HKSearchHeadCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIButton *labelText;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation HKSearchHeadCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setType:(int)type{
    _type = type;
    if (type == 0) {
        self.labelText.selected = NO;
        self.btn.hidden = NO;
        [self.labelText setTitle:@"历史记录" forState:0];
    }else{
        self.labelText.selected = YES;
        self.btn.hidden = YES;
        [self.labelText setTitle:@"热门搜索" forState:0];
    }
   
}
- (IBAction)emptySearchHistory:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(toEmptySearchHistory)]) {
        [self.delegate toEmptySearchHistory];
    }
}
@end
