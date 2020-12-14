//
//  DLCurrentTableViewCell.m
//  DownLoadTest
//
//  Created by 李五民 on 15/10/24.
//  Copyright © 2015年 李五民. All rights reserved.
//

#import "DLCurrentTableViewCell.h"
#import "DLDownloadProcessView.h"
#import "DLDownloadModel.h"
#import "Masonry.h"
#import "DLDownloadMagager.h"
#import "DLSharedToastManager.h"
#import "AppDelegate.h"

@interface DLCurrentTableViewCell ()

@property (nonatomic,strong) DLDownloadModel *downloadModel;
@property (nonatomic,strong) DLDownloadProcessView *processView;
@property (nonatomic,strong) UILabel *titleNameLabel;
@property (nonatomic,strong) UILabel *statusLabel;
@property (nonatomic,strong) UIButton *clickedButton;

@end

@implementation DLCurrentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        [self setupUI];
    }
    return self;
}

#pragma mark - Private
- (void)setupUI {
    self.processView = [[DLDownloadProcessView alloc] init];
    self.processView.backgroundColor = [UIColor whiteColor];
    self.processView.layer.borderWidth = 0.5;
    self.processView.layer.borderColor = [[UIColor blueColor] CGColor];
    [self.contentView addSubview:self.processView];
    
    [self.processView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(5, 5, 0, 5));
    }];
    [self.processView configUIWithCurrentProcess:0.0];
    
    self.titleNameLabel = [[UILabel alloc] init];
    self.titleNameLabel.textColor = [UIColor colorWithRed:100/255.0 green:149/255.0 blue:237/255.0 alpha:1];
    self.titleNameLabel.text = @"泰坦尼克号";
    [self.processView addSubview:self.titleNameLabel];
    
    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.font = [UIFont systemFontOfSize:10];
    self.statusLabel.textColor = [UIColor colorWithRed:0/255.0 green:206/255.0 blue:209/255.0 alpha:1];
    self.statusLabel.text = @"已暂停";
    [self.processView addSubview:self.statusLabel];
    
    self.clickedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.clickedButton setImage:[UIImage imageNamed:@"下载"] forState:UIControlStateNormal];
    [self.clickedButton setImage:[UIImage imageNamed:@"下载-点击"] forState:UIControlStateHighlighted];
    [self.clickedButton addTarget:self action:@selector(clickDownloadTask) forControlEvents:UIControlEventTouchUpInside];
    [self.processView addSubview:self.clickedButton];
    
    [self.clickedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.processView.mas_trailing).offset(-20);
        make.centerY.equalTo(self.processView.mas_centerY);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.clickedButton.mas_bottom);
        make.bottom.equalTo(self.processView.mas_bottom).offset(-8);
        make.trailing.equalTo(self.clickedButton.mas_leading).offset(-20);
    }];
    
    [self.titleNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.processView.mas_leading).offset(15);
        make.bottom.equalTo(self.statusLabel.mas_top).offset(-10);
    }];
}

#pragma mark - Public
- (void)configUIWithDownloadModel:(DLDownloadModel *)model {
    self.downloadModel = model;
    self.titleNameLabel.text = model.urlModel.name;
    [self configUIWithButtonStatus:model.buttonStatus statusTask:model.statusTask];
    DLURLSessionOperation *operation = [[DLDownloadMagager sharedManager].operationDictionary objectForKey:self.downloadModel.urlModel.url];
    if (model.speed.length > 0 && operation.task.state == NSURLSessionTaskStateRunning) {
        self.statusLabel.text = model.speed;
    }
    [self.processView configUIWithCurrentProcess:model.progress];
}
//自动暂停任务
- (void)autoSuspendTask {
    [self suspendTask];
}
//下载失败
- (void)taskFail {
    [self suspendTask];
}
//开始下载
- (void)startTask {
    [self restartTask];
}

- (void)configUIWithButtonStatus:(NSInteger)buttonStatus statusTask:(NSInteger)statusTask {
    self.downloadModel.buttonStatus = buttonStatus;
    self.downloadModel.statusTask = statusTask;
    switch (statusTask) {
        case 1:
            self.statusLabel.text = @"获取中";
            break;
        case 2:
            self.statusLabel.text = @"已暂停";
            break;
        case 3:
            self.statusLabel.text = @"加载失败";
            break;
    }
    switch (buttonStatus) {
        case 1: {
            [self.clickedButton setImage:[UIImage imageNamed:@"download暂停"] forState:UIControlStateNormal];
            [self.clickedButton setImage:[UIImage imageNamed:@"download暂停-点击"] forState:UIControlStateHighlighted];
        }
            break;
        case 2: {
            [self.clickedButton setImage:[UIImage imageNamed:@"下载"] forState:UIControlStateNormal];
            [self.clickedButton setImage:[UIImage imageNamed:@"下载-点击"] forState:UIControlStateHighlighted];
        }
            break;
        case 3: {
            [self.clickedButton setImage:[UIImage imageNamed:@"重新下载"] forState:UIControlStateNormal];
            [self.clickedButton setImage:[UIImage imageNamed:@"重新下载-点击"] forState:UIControlStateHighlighted];
        }
            break;
    }
}

#pragma mark - Actions
- (void)clickDownloadTask {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (![delegate.reachability isReachable]) {
        [self taskFail];
        [self configUIWithButtonStatus:DLButtonStatusFail statusTask:DLTextStatusSuspend];
        [self suspendTask];
        self.failDowloadBlock(@"没有网络");
        return;
    } else if ([delegate.reachability isReachableViaWWAN] && ![DLDownloadMagager sharedManager].isWWANDownload) {
        [self configUIWithButtonStatus:DLButtonStatusFail statusTask:DLTextStatusSuspend];
        [self suspendTask];
        self.failDowloadBlock(@"3g不允许下载，请重新设置");
        return;
    }
    switch (self.downloadModel.buttonStatus) {
        case 1: {
            [self configUIWithButtonStatus:DLButtonStatusSuspend statusTask:DLTextStatusSuspend];
            [self suspendTask];
            NSLog(@"lll%@",@([DLDownloadMagager sharedManager].queue.operationCount));
        }
            break;
        case 2: {
            [self configUIWithButtonStatus:DLButtonStatusStart statusTask:DLTextStatusStart];
            [self restartTask];
            NSLog(@"%@",@([DLDownloadMagager sharedManager].queue.operationCount));
        }
            break;
        case 3: {
            [self configUIWithButtonStatus:DLButtonStatusStart statusTask:DLTextStatusStart];
            [self restartTask];
            NSLog(@"%@",@([DLDownloadMagager sharedManager].queue.operationCount));
        }
            break;
    }
}

#pragma mark - Private
//暂停任务
- (void)suspendTask {
    [self changeTaskWithisSuspend:YES];
}
//开始任务
- (void)restartTask {
    [self changeTaskWithisSuspend:NO];
}

- (void)changeTaskWithisSuspend:(BOOL)suspend{
    DLURLSessionOperation *operation = [[DLDownloadMagager sharedManager].operationDictionary objectForKey:self.downloadModel.urlModel.url];
    if (suspend) {
        if (operation.task.state != NSURLSessionTaskStateSuspended) {
            [operation.task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
                if(resumeData != nil) {
                operation.resumeData = resumeData;
                }
            }];
            operation.alReadyStart = NO;
            [operation cancel];
            [operation completeOperation];
            operation.isResume = YES;
            operation.isSuspend = NO;
        } else {
            //operation.alReadyStart = NO;
            operation.isSuspend = YES;
        }
    } else {
        DLURLSessionOperation *newOperation;
        if (operation.isResume) {
            if (operation.resumeData.length > 0) {
                newOperation = [[DLURLSessionOperation alloc] initWithSession:operation.session URLString:operation.task.taskDescription ResumeData:operation.resumeData];
            } else {
                newOperation = [[DLURLSessionOperation alloc] initWithSession:operation.session URLString:operation.task.taskDescription];
            }
            operation.isResume = NO;
            operation.isSuspend = NO;
            operation.alReadyStart = NO;
            [[DLDownloadMagager sharedManager].queue addOperation:newOperation];
            [[DLDownloadMagager sharedManager].operationDictionary setObject:newOperation forKey:self.downloadModel.urlModel.url];
        } else {
            if (operation.alReadyStart) {
                if (operation.resumeData.length > 0) {
                    newOperation = [[DLURLSessionOperation alloc] initWithSession:operation.session URLString:operation.task.taskDescription ResumeData:operation.resumeData];
                    //operation.isResume = NO;
                } else {
                    newOperation = [[DLURLSessionOperation alloc] initWithSession:operation.session URLString:operation.task.taskDescription];
                }
                operation.alReadyStart = NO;
                [[DLDownloadMagager sharedManager].queue addOperation:newOperation];
                [[DLDownloadMagager sharedManager].operationDictionary setObject:newOperation forKey:self.downloadModel.urlModel.url];
            }
            operation.isSuspend = NO;
        };
    }
    
}


@end
