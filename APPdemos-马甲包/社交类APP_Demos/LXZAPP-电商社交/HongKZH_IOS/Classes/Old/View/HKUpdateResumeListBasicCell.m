//
//  HKUpdateResumeListBasicCell.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/21.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKUpdateResumeListBasicCell.h"

@implementation HKUpdateResumeListBasicCell

- (UITableView *)tableView {
    if (_tableView == nil) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.backgroundColor = [UIColor greenColor];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableFooterView = [[UIView alloc] init];
        [self.contentView addSubview:tableView];
        _tableView = tableView;
    }
    return _tableView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier block:(UpdateResumeIndexBlock) block addResumeBlock:(AddResumeBlock)addResumeBlock{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
        self.block = block;
        self.addResumeBlock = addResumeBlock;
    }
    return self;
}

- (void)setUpUI {
    self.contentView.backgroundColor = RGB(241, 241, 241);
    //设置边框阴影
    self.tableView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.tableView.layer.shadowOpacity = 0.5;
    self.tableView.layer.shadowOffset = CGSizeMake(1, 1);
    self.tableView.layer.borderWidth = 1.f;
    self.tableView.layer.borderColor = UICOLOR_HEX(0xdddddd).CGColor;
    self.tableView.clipsToBounds = false;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];
}

- (void)setItems:(NSArray *)items {
    if (items) {
        _items = items;
    }
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  nil;
}

@end
