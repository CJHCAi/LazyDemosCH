//
//  HKMyApplyResumeOperationCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMyApplyResumeOperationCell.h"

@implementation HKMyApplyResumeOperationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setUpUI {
    NSArray *images = @[@"bjjl_56",@"jlyl_56",@"shxjl_56",@"wdtd_56"];
    NSArray *titles = @[@"编辑简历",@"简历预览",@"刷新简历",@"我的投递"];
    NSInteger count = [titles count];
    CGFloat itemWith = 47;
    CGFloat cap = (kScreenWidth-itemWith*count)/(count+1);
    UIView *lastView = nil;
    for (int i = 0; i < count; i++) {
        //添加包含视图
        UIView *bgView = [[UIView alloc] init];
//        bgView.backgroundColor = [UIColor greenColor];
        [self.contentView addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.left.equalTo(self.contentView).offset(cap);
            } else {
                make.left.equalTo(lastView.mas_right).offset(cap);
            }
            make.top.bottom.equalTo(self.contentView);
            make.width.mas_equalTo(itemWith);
            
        }];
        lastView = bgView;
        //添加子视图
        UIButton *iconButton = [HKComponentFactory buttonWithType:UIButtonTypeCustom
                                                            frame:CGRectZero
                                                            taget:self
                                                           action:@selector(iconButtonClick:) supperView:bgView];
        iconButton.tag = i;
        [iconButton setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        [iconButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(bgView);
            make.top.equalTo(bgView).offset(22);
        }];
        
        UILabel *tipLabel = [HKComponentFactory labelWithFrame:CGRectZero
                                                     textColor:UICOLOR_HEX(0x666666) textAlignment:NSTextAlignmentCenter
                                                          font:PingFangSCRegular12
                                                          text:titles[i]
                                                    supperView:bgView];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(bgView);
            make.top.equalTo(iconButton.mas_bottom).offset(10);
        }];
    }
}

- (void)iconButtonClick:(UIButton *)button {
    if (self.block) {
        self.block(button.tag);
    }
}


@end
