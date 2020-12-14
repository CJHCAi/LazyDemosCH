//
//  DLSwitchTableViewCell.m
//  DownLoadTest
//
//  Created by 李五民 on 15/10/26.
//  Copyright © 2015年 李五民. All rights reserved.
//

#import "DLSwitchTableViewCell.h"
#import "Masonry.h"
#import "DLDownloadMagager.h"
#import "DLCurrentDownloadViewController.h"

@implementation DLSwitchTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.text = @"移动网络下自动暂停";
    [self.contentView addSubview:textLabel];
    UISwitch *switchView = [[UISwitch alloc] init];
    [switchView setOn:[DLDownloadMagager sharedManager].isWWANDownload];
    [switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:switchView];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(16);
        make.centerY.equalTo(self.contentView);
    }];
    textLabel.preferredMaxLayoutWidth = [[UIScreen mainScreen] bounds].size.width - 80;
    [switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.contentView).offset(-16);
        make.centerY.equalTo(self.contentView);
    }];
}

-(void) switchAction:(UISwitch *)sender {
    BOOL setting = [sender isOn];
    [DLDownloadMagager sharedManager].isWWANDownload = setting;
    if (!setting && [DLDownloadMagager sharedManager].currentNetStatus == 1 ) {
        NSMutableArray *statusArray = [[NSMutableArray alloc] init];
        for (DLURLSessionOperation *operation in [[DLDownloadMagager sharedManager].operationDictionary allValues]) {
            NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
            [tempDic setObject:operation.urlString forKey:@"url"];
            [tempDic setObject:@(operation.isSuspend) forKey:@"isSuspend"];
            [tempDic setObject:@(operation.isResume) forKey:@"isResume"];
            [statusArray addObject:tempDic];
        }
        NSUserDefaults * defaults =  [NSUserDefaults standardUserDefaults];
        [defaults setObject:statusArray forKey:@"suspendStatus"];
        [defaults synchronize];

        [[NSNotificationCenter defaultCenter] postNotificationName:DLSuspendTaskNotification object:nil];
    } else if(setting && [DLDownloadMagager sharedManager].currentNetStatus != 0) {
        NSUserDefaults * defaults =  [NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey:@"suspendStatus"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:DLAutoStartTaskNotification object:nil];
        }
    }
    NSLog(@"%@",@(setting));
}

@end
