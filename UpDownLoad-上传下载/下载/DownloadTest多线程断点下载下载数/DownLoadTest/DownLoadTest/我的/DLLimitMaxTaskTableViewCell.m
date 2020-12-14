//
//  DLLimitMaxTaskTableViewCell.m
//  DownLoadTest
//
//  Created by 李五民 on 15/10/26.
//  Copyright © 2015年 李五民. All rights reserved.
//

#import "DLLimitMaxTaskTableViewCell.h"
#import "Masonry.h"
#import "DLDownloadMagager.h"

@implementation DLLimitMaxTaskTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.text = @"设置最大连接数n 1-3";
    [self.contentView addSubview:textLabel];
    self.limitTextField = [[DLMaxLinkTextFieldView alloc] init];
    self.limitTextField.contentMode = UIViewContentModeCenter;
    [self.limitTextField configTextFieldWithMaxNum:3];
    [self.limitTextField setText:[NSString stringWithFormat:@"%@",@([DLDownloadMagager sharedManager].queue.maxConcurrentOperationCount)]];
    [self.contentView addSubview:self.limitTextField];
    
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(16);
        make.centerY.equalTo(self.contentView);
    }];
    textLabel.preferredMaxLayoutWidth = [[UIScreen mainScreen] bounds].size.width - 80;
    [self.limitTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.contentView).offset(-16);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(30, 20));
    }];
}

@end
