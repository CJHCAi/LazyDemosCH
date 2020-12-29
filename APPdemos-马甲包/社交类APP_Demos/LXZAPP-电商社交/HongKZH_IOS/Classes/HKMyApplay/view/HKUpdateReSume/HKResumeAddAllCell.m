//
//  HKResumeAddAllCellTableViewCell.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/21.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKResumeAddAllCell.h"

@interface HKResumeAddAllCell ()

@property (nonatomic, strong) UIButton *button;

@end

@implementation HKResumeAddAllCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    return [self initWithStyle:style reuseIdentifier:reuseIdentifier addTitle:@"" addCellBlock:nil];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier addTitle:(NSString *)addTitle addCellBlock:(UpdateResumeBlock) block{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.addTitle = addTitle;
        self.updateResumeBlock = block;
        [self setUpUI];
    }
    return self;
}

+ (instancetype)resumeAddCellWithTitle :(NSString *)title addCellBlock:(UpdateResumeBlock) block{
    return [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(self) addTitle:title addCellBlock:block];
}

- (void)setUpUI {
    UIButton *button = [HKComponentFactory buttonWithType:UIButtonTypeCustom
                                                 frame:CGRectZero
                                                 taget:self
                                                action:@selector(buttonClick)
                                            supperView:self.containerView];
    [button setTitle:[NSString stringWithFormat:@"添加%@",self.addTitle] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"jlfbtj"] forState:UIControlStateNormal];
    button.titleLabel.font = PingFangSCRegular14;
    [button setTitleColor:UICOLOR_HEX(0x4090f7) forState:UIControlStateNormal];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [self.containerView addSubview:button];
    self.button = button;
}

- (void)buttonClick {
    if (self.updateResumeBlock) {
        self.updateResumeBlock();
    }
}

//子控件布局
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containerView);
    }];
}



@end
