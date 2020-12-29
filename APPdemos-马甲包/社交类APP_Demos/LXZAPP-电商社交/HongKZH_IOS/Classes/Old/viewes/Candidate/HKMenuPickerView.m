//
//  HKMenuPickerView.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/20.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMenuPickerView.h"

@interface HKMenuPickerView()
<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIControl *bgView;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation HKMenuPickerView

- (UIControl *)bgView {
    if (!_bgView) {
        _bgView = [[UIControl alloc] init];
        _bgView.backgroundColor = RGBA(0, 0, 0, 0.4);
        [_bgView addTarget:self action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bgView;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = RGB(241, 241, 241);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

+ (void)showInView:(UIView *)containerView
         menuTitle:(NSString *)menuTitle
          curIndex:(NSInteger )curIndex
            titles:(NSMutableArray *)titles
             block:(HKMenuPickerViewBlock)block{
    HKMenuPickerView *view = [[self alloc] init];
    view.block = block;
    view.titles = titles;
    view.curIndex = curIndex;
    view.menuTitle = menuTitle;
    [containerView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(containerView);
    }];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.width.equalTo(self);
        make.height.mas_equalTo(401);
    }];
}

- (void)setTitles:(NSMutableArray *)titles {
    if (titles) {
        _titles = titles;
        [self.tableView reloadData];
    }
}

#pragma mark - tableview delegate & datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titles count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *tipLabel = [HKComponentFactory labelWithFrame:CGRectZero
                                                 textColor:UICOLOR_HEX(0x333333)
                                             textAlignment:NSTextAlignmentCenter
                                                      font:PingFangSCRegular17
                                                      text:self.menuTitle
                                                supperView:view];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.centerY.equalTo(view);
    }];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HKMenuPickerViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HKMenuPickerViewCell"];
        UILabel *titleLabel = [HKComponentFactory labelWithFrame:CGRectZero
                                                       textColor:UICOLOR_HEX(0x333333)
                                                   textAlignment:NSTextAlignmentLeft
                                                            font:PingFangSCRegular14
                                                            text:@""
                                                      supperView:cell.contentView];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(15);
            make.centerY.equalTo(cell.contentView);
        }];
        titleLabel.tag = 101;
    }
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:101];
    NSString *title = self.titles[indexPath.row];
    titleLabel.text = title;
    if (self.curIndex == indexPath.row) {
        titleLabel.textColor = UICOLOR_HEX(0x4090f7);
    } else {
        titleLabel.textColor = UICOLOR_HEX(0x333333);
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.block) {
        self.block(indexPath.row);
    }
    [self removeFromSuperview];
}


@end
