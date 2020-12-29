//
//  HKVideoTagCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/7/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKVideoTagCell.h"
#import "HK_AllTags.h"

@interface HKVideoTagCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *iconButton;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIView *bgControl;
@property (weak, nonatomic) IBOutlet UIButton *creatBtn;

@end

@implementation HKVideoTagCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconButton.layer.cornerRadius = 5.f;
    self.iconButton.layer.masksToBounds = YES;

    self.bgControl.layer.cornerRadius = 5.f;
    self.bgControl.layer.masksToBounds = YES;
    [self.creatBtn setTitleColor:RGB(10,96,254) forState:UIControlStateNormal];
    self.creatBtn.enabled = NO;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (IBAction)creatClick:(id)sender {
    
    
}
- (void)setItemValue:(NSObject *)itemValue {
    if (itemValue) {
        if ([itemValue isKindOfClass:[HK_AllTagsCircles class]]) {
            HK_AllTagsCircles *value = (HK_AllTagsCircles *)itemValue;
            [self.iconButton setImage:[UIImage imageNamed:@"psspw2sw"] forState:UIControlStateNormal];
            self.titleLabel.text = value.tag;
            self.tipLabel.text = [NSString stringWithFormat:@"主题 · %ld人为视频打了此标签",value.allCount];
        } else if ([itemValue isKindOfClass:[HK_AllTagsRecommends class]]) {
            HK_AllTagsRecommends *value = (HK_AllTagsRecommends *)itemValue;
            [self.iconButton setImage:[UIImage imageNamed:@"qzsq1e"] forState:UIControlStateNormal];
            self.titleLabel.text = value.tag;
            self.tipLabel.text = [NSString stringWithFormat:@"圈子 · %ld人",value.allCount];
        }
       //搜索模式下....
        else if ([itemValue isKindOfClass:[HK_SeachData class]]) {
            HK_SeachData * value =(HK_SeachData *)itemValue;
            if (value.type.intValue==1) {
                 self.creatBtn.hidden = YES;
             //圈子..
                [self.iconButton setImage:[UIImage imageNamed:@"qzsq1e"] forState:UIControlStateNormal];
                self.titleLabel.text = value.tag;
                self.tipLabel.text = [NSString stringWithFormat:@"圈子 · %ld人",value.allCount];
            }else if (value.type.intValue==2){
                 self.creatBtn.hidden = YES;
                [self.iconButton setImage:[UIImage imageNamed:@"psspw2sw"] forState:UIControlStateNormal];
                self.titleLabel.text = value.tag;
                self.tipLabel.text = [NSString stringWithFormat:@"主题 · %ld人为视频打了此标签",value.allCount];
            }else {
               //自定义的..
                self.creatBtn.hidden = NO;
                self.titleLabel.text  =value.tag;
                self.tipLabel.text =@"自定义标签";
            }
  
        }
    }
}
@end
