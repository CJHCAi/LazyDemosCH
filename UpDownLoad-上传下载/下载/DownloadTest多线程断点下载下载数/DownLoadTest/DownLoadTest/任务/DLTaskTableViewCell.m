//
//  DLTaskTableViewCell.m
//  DownLoadTest
//
//  Created by 李五民 on 15/10/23.
//  Copyright © 2015年 李五民. All rights reserved.
//

#import "DLTaskTableViewCell.h"
#import "Masonry.h"
#import "DLDownloadUrlModel.h"

@interface DLTaskTableViewCell ()

@property (nonatomic,strong) DLDownloadUrlModel *urlModel;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *startButton;

@end

@implementation DLTaskTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        [self setupUI];
    }
    return self;
}

#pragma mark - Private
- (void)setupUI{
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor darkGrayColor];
    [self.contentView addSubview:self.titleLabel ];
    self.startButton = [[UIButton alloc] init];
    [self.startButton setTitle:@"下载" forState:UIControlStateNormal];
    [self.startButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.startButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [self.startButton addTarget:self action:@selector(startDownloadTask) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.startButton];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.leading.equalTo(self.contentView.mas_leading).offset(16);
    }];
    self.titleLabel.preferredMaxLayoutWidth = [[UIScreen mainScreen] bounds].size.width - 66;
    
    [self.startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.trailing.equalTo(self.contentView.mas_trailing).offset(-16);
    }];
}

#pragma mark - Pubilic
- (void)configUIWithModel:(DLDownloadUrlModel *)urlModel{
    self.urlModel = urlModel;
    self.titleLabel.text = urlModel.name;
}

#pragma mark - Actions
- (void)startDownloadTask{
    if (self.startDownloadBlock) {
        self.startDownloadBlock();
    }
}


@end
