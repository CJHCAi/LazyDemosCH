//
//  DLDownloadProcessView.m
//  DownLoadTest
//
//  Created by 李五民 on 15/10/24.
//  Copyright © 2015年 李五民. All rights reserved.
//

#import "DLDownloadProcessView.h"
#import "Masonry.h"
@interface DLDownloadProcessView ()
@property (nonatomic,strong) UIView *displayView;
@end
@implementation DLDownloadProcessView

- (id)init{
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    _displayView = [[UIView alloc] init];
    _displayView.backgroundColor = [UIColor colorWithRed:135/255.0 green:206/255.0 blue:235/255.0 alpha:1];
    [self addSubview:_displayView];
}

- (void)configUIWithCurrentProcess:(float)process{

//    [_displayView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.mas_leading).offset(0.5);
//        make.top.equalTo(self.mas_top).offset(0.5);
//        make.trailing.equalTo(self.mas_trailing).offset(-([[UIScreen mainScreen] bounds].size.width - 10) * (1 - process));
//        make.bottom.equalTo(self.mas_bottom).offset(-0.5);
//    }];
//    [self layoutIfNeeded];
    _displayView.frame = CGRectMake(0, 0, ([[UIScreen mainScreen] bounds].size.width - 10) * process, self.frame.size.height);
}

@end
