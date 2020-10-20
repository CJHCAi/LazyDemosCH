//
//  XMGSettingCell.m
//  小码哥彩票
//
//  Created by xiaomage on 15/7/1.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "XMGSettingCell.h"

#import "XMGArrowSettingItem.h"
#import "XMGSwtichSettingItem.h"

@interface XMGSettingCell ()
@property (nonatomic, strong) UIImageView *arrowView;
@property (nonatomic, strong) UISwitch *switchView;
@property (nonatomic, strong) UIButton *editorBtn;

@end

@implementation XMGSettingCell

- (UIImageView *)arrowView{
    if (_arrowView == nil) {
        _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]];
    }
    return _arrowView;
}

- (UISwitch *)switchView{
    if (_switchView == nil) {
        _switchView = [[UISwitch alloc] init];
    }
    return _switchView;
}

-(UIButton *)editorBtn{
    if (_editorBtn == nil) {
        _editorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _editorBtn.frame = CGRectMake(0, 0, 10, 30);
        [_editorBtn setImage:[UIImage imageNamed:@"arrow_right"] forState:UIControlStateNormal];
        [_editorBtn addTarget:self action:@selector(editorBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        _editorBtn.backgroundColor = [UIColor redColor];
    }
    return _editorBtn;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView style:(UITableViewCellStyle)style{
    static NSString *ID = @"cell";
    XMGSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[XMGSettingCell alloc] initWithStyle:style reuseIdentifier:ID];
    }
    return cell;
}

- (void)setItem:(XMGSettingItem *)item{
    _item = item;
    [self setUpData];
    // 设置辅助视图
    [self setUpAccessoryView];
}

- (void)setUpData{
    self.textLabel.text = _item.title;
    self.detailTextLabel.text = _item.subTitle;
    self.imageView.image = _item.image;
}

- (void)setUpAccessoryView{
    if ([_item isKindOfClass:[XMGArrowSettingItem class]]) {
        // 箭头
        self.accessoryView = self.editorBtn;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }else if ([_item isKindOfClass:[XMGSwtichSettingItem class]]){
        // 开关
        self.accessoryView = self.switchView;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        // 还原
        self.accessoryView = nil;
    }
}

-(void)editorBtnClicked{
    NSLog(@"点击了编辑");
}
@end
