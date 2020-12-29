//
//  HKChoosePositionView.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/16.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKChoosePositionView.h"

@interface HKChoosePositionView() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIControl *bgView;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HKChoosePositionView

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
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

+ (void)showInView:(UIView *)containerView
          curTitle:(NSString *)curTitle
              data:(HKMyRecruitData *)data{
    HKChoosePositionView *view = [[self alloc] init];
    view.data = data;
    view.curTitle = curTitle;
    view.delegate =  containerView;
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

- (void)setData:(HKMyRecruitData *)data {
    if (data) {
        _data = data;
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
    return [self.data.recruits count]+1;
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
                                                      text:@"选择职位"
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HKChoosePositionViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HKChoosePositionViewCell"];
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
    NSString *title = @"";
    if (indexPath.row == 0) {
        title = @"人才推荐";
    } else {
        HKMyRecruitList *list = [self.data.recruits objectAtIndex:indexPath.row-1];
        title = list.title;
    }
    titleLabel.text = title;
    if ([title isEqualToString:self.curTitle]) {
        titleLabel.textColor = UICOLOR_HEX(0x4090f7);
    } else {
        titleLabel.textColor = UICOLOR_HEX(0x333333);
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = @"";
    if (indexPath.row == 0) {
        title = @"人才推荐";
    } else {
        HKMyRecruitList *list = [self.data.recruits objectAtIndex:indexPath.row-1];
        title = list.title;
    }
    if ([self.delegate respondsToSelector:@selector(choosePositionViewBlock:title:)]) {
        [self.delegate choosePositionViewBlock:indexPath.row title:title];
    }
    [self removeFromSuperview];
}


@end
