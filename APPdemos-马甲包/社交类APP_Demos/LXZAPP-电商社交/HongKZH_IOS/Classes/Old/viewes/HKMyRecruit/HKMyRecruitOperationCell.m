//
//  HKMyRecruitOperationCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/16.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMyRecruitOperationCell.h"

@interface HKMyRecruitOperationCell ()

@property (nonatomic, strong) NSMutableArray *labels;

@end

@implementation HKMyRecruitOperationCell

- (NSMutableArray *)labels {
    if (!_labels) {
        _labels = [NSMutableArray array];
    }
    return _labels;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    UIView *topView =[[UIView alloc] init];
    topView.backgroundColor =[UIColor colorFromHexString:@"f1f1f1"];
    [self.contentView addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.height.mas_equalTo(44);
    }];
    UIButton *searchBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setTitle:@"搜索人才" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor colorFromHexString:@"999999"] forState:UIControlStateNormal];
    searchBtn.titleLabel.font =PingFangSCRegular14;
    [searchBtn setImage:[UIImage imageNamed:@"class_search"] forState:UIControlStateNormal];
    searchBtn.backgroundColor =[UIColor whiteColor];
    searchBtn.layer.cornerRadius = 5;
    searchBtn.layer.masksToBounds =YES;
    searchBtn.tag = 5;
    [topView addSubview:searchBtn];
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView).offset(15);
        make.top.equalTo(topView).offset(7);
        make.bottom.equalTo(topView).offset(-7);
        make.right.equalTo(topView).offset(-15);
    }];
    [searchBtn addTarget:self action:@selector(iconButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    NSArray *images = @[@"fbnr_5742",@"zxzhw_5742",@"zxtd_5742",@"rcshc_5742"];
    NSArray *titles = @[@"发布内容",@"在线职位",@"最新投递",@"人才收藏"];
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
            make.top.equalTo(topView).offset(44);
            make.bottom.equalTo(self.contentView);
            make.width.mas_equalTo(itemWith);
            
        }];
        lastView = bgView;
        //添加label
        if (i > 0) {
            UILabel *countLabel = [HKComponentFactory labelWithFrame:CGRectZero
                                                           textColor:[UIColor whiteColor]
                                                       textAlignment:NSTextAlignmentCenter
                                                                font:PingFangSCRegular9 text:@""
                                                          supperView:self.contentView];
            [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(bgView.mas_centerX).offset(11);
                make.top.equalTo(self.contentView).offset(69);
                make.height.mas_equalTo(14);
                make.width.mas_greaterThanOrEqualTo(27);
            }];
            countLabel.backgroundColor = UICOLOR_HEX(0xd84d35);
            countLabel.layer.cornerRadius = 7;
            countLabel.layer.masksToBounds = YES;
            [self.labels addObject:countLabel];
        }
        
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

- (void)setData:(HKMyRecruitData *)data {
    if (data) {
        _data = data;
        UILabel *recruitCountLabel = [self.labels objectAtIndex:0];
        if (data.recruitCount > 100) {
            recruitCountLabel.text = @"100个+";
        } else if (data.recruitCount <= 0) {
            recruitCountLabel.hidden = YES;
        } else {
            recruitCountLabel.text = [NSString stringWithFormat:@"%ld个",data.recruitCount];
        }
        
        UILabel *collectionCountLabel = [self.labels objectAtIndex:1];
        if (data.collectionCount > 100) {
            collectionCountLabel.text = @"100人+";
        } else if (data.collectionCount <= 0) {
            collectionCountLabel.hidden = YES;
        } else {
            collectionCountLabel.text =[NSString stringWithFormat:@"%ld人",data.collectionCount];
        }
        
        
        UILabel *deliveryCountLabel = [self.labels objectAtIndex:2];
        if (data.deliveryCount > 100) {
            deliveryCountLabel.text = @"100人+";
        } else if (data.deliveryCount <= 0) {
            deliveryCountLabel.hidden = YES;
        } else {
            deliveryCountLabel.text = [NSString stringWithFormat:@"%ld人",data.deliveryCount];
        }
    }
}

- (void)iconButtonClick:(UIButton *)button {
    if (self.block) {
        self.block(button.tag);
    }
}


@end
