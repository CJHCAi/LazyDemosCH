//
//  DLFinshTableViewCell.m
//  DownLoadTest
//
//  Created by 李五民 on 15/10/24.
//  Copyright © 2015年 李五民. All rights reserved.
//

#import "DLFinshTableViewCell.h"
#import "Masonry.h"

@interface DLFinshTableViewCell ()

@property (nonatomic ,strong) UILabel *urlNameLabel;

@end

@implementation DLFinshTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    UIView *backgroundView= [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor whiteColor];
    backgroundView.layer.borderWidth = 0.5;
    backgroundView.layer.borderColor = [[UIColor blueColor] CGColor];
    [self.contentView addSubview:backgroundView];
    
    self.urlNameLabel = [[UILabel alloc] init];
    self.urlNameLabel.textColor = [UIColor colorWithRed:100/255.0 green:149/255.0 blue:237/255.0 alpha:1];
    self.urlNameLabel.text = @"泰坦尼克号11";
    [backgroundView addSubview:self.urlNameLabel];
    
    UILabel *totalSizeLabel = [[UILabel alloc] init];
    totalSizeLabel.font = [UIFont systemFontOfSize:10];
    totalSizeLabel.textColor = [UIColor colorWithRed:0/255.0 green:206/255.0 blue:209/255.0 alpha:1];
    totalSizeLabel.text = @"已完成";
    [backgroundView addSubview:totalSizeLabel];
    
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(5, 5, 0, 5));
    }];
    [self.urlNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backgroundView.mas_centerY);
        make.leading.equalTo(backgroundView.mas_leading).offset(20);
    }];
    [totalSizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backgroundView.mas_centerY);
        make.trailing.equalTo(backgroundView.mas_trailing).offset(-20);
    }];
}

- (void)configViewWithDownloadName:(NSString *)downloadName {
    self.urlNameLabel.text = downloadName;
}

@end
