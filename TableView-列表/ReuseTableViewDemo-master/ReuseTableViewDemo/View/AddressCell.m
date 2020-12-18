//
//  AddressCell.m
//  ReuseTableViewDemo
//
//  Created by 萧奇 on 2017/10/1.
//  Copyright © 2017年 萧奇. All rights reserved.
//

#import "AddressCell.h"

static const CGFloat buttonWidth = 65;
static const CGFloat buttonHeight = 25;

@interface AddressCell ()

@property (nonatomic, strong)UILabel *titleLabel;

@property (nonatomic, strong)UIView *userButtonsView;

@property (nonatomic, copy)NSArray *userArray;

@property (nonatomic, copy)NSMutableArray *selectStateArray;

@end

@implementation AddressCell

- (NSMutableArray *)selectStateArray {
    
    if (!_selectStateArray) {
        _selectStateArray = [NSMutableArray array];
    }
    return _selectStateArray;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 箭头图标
        UIImageView *iconImageview = [[UIImageView alloc] init];
        iconImageview.image = [UIImage imageNamed:@"icon_one"];
        [iconImageview sizeToFit];
        iconImageview.frame = CGRectMake(0, 15, iconImageview.width, iconImageview.height);
        [self addSubview:iconImageview];
        // 标题
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25 + iconImageview.width + 5, 13, SCREEN_WIDTH, 13)];
        self.titleLabel.textColor = RGB(77, 77, 77, 1);
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.titleLabel];
        // 按钮视图
        self.userButtonsView = [[UIView alloc] init];
        [self addSubview:self.userButtonsView];
        
    }
    return self;
}

- (void)setAddress:(Address *)address {
    
    _address = address;
    self.titleLabel.text = _address.NAME;
    self.userArray = _address.USERS;
    NSInteger c = self.userArray.count/4;
    NSInteger l = self.userArray.count%4;
    if (l != 0) {
        self.userButtonsView.frame = CGRectMake(35, self.titleLabel.bottom + 8, SCREEN_WIDTH - 41*2 + 5*2, (c + 1)*(buttonHeight + 10));
    } else {
        self.userButtonsView.frame = CGRectMake(35, self.titleLabel.bottom + 8, SCREEN_WIDTH - 41*2 + 5*2, c*(buttonHeight + 10));
    }
    
    for (NSInteger i = 0; i < self.userArray.count; i++) {
        UIButton *userButton = [[UIButton alloc] initWithFrame:CGRectMake(5 + (buttonWidth + 10)*(i%4), 5 + (buttonHeight + 10)*(i/4), buttonWidth, buttonHeight)];
        if (self.selectStateArray.count != _address.USERS.count) {
            NSString *selectState = @"0";
            [self.selectStateArray addObject:selectState];
            userButton.backgroundColor = RGB(240, 240, 240, 1);// 未选中灰色
        } else {
            BOOL selectState = [self.selectStateArray[i] integerValue];
            userButton.selected = selectState;
            if (!userButton.selected) {
                userButton.backgroundColor = RGB(240, 240, 240, 1);// 未选中灰色
            } else {
                userButton.backgroundColor = RGB(56, 173, 255, 1);// 选中蓝色
            }
        }
        [userButton setTitle:self.userArray[i][@"PERSONNAME"] forState:UIControlStateNormal];
        [userButton setTitleColor:RGB(153, 153, 153, 1) forState:UIControlStateNormal];
        [userButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [userButton addTarget:self action:@selector(userButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        userButton.titleLabel.font = [UIFont systemFontOfSize:13];
        userButton.tag = 100 + i;
        userButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        userButton.layer.cornerRadius = 5;
        userButton.layer.masksToBounds = YES;
        [self.userButtonsView addSubview:userButton];
    }
}

- (void)userButtonClick:(UIButton *)button {
    
    NSInteger tag = button.tag - 100;
    NSDictionary *userDic = self.userArray[tag];
    BOOL selectSate = [self.selectStateArray[tag] integerValue];
    button.selected = selectSate;
    if (button.selected) {
        button.backgroundColor = RGB(240, 240, 240, 1);// 未选中灰色
        button.selected = NO;
        [self.selectStateArray replaceObjectAtIndex:tag withObject:@"0"];
        [self.addressDelegate deleteUserDicFromUsers:userDic];
    } else {
        button.backgroundColor = RGB(56, 173, 255, 1);// 选中蓝色
        button.selected = YES;
        [self.selectStateArray replaceObjectAtIndex:tag withObject:@"1"];
        [self.addressDelegate addUserDicToUsers:userDic];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
