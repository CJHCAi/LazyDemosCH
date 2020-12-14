//
//  MusicDownloadListTableCell.h
//  MusicPartnerDownload
//
//  GitHub:https://github.com/szweee
//  Blog:  http://www.szweee.com
//
//  Created by 索泽文 on 16/2/12.
//  Copyright © 2016年 索泽文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicPartnerDownloadManager.h"
#import "TaskEntity.h"
#import "TYMProgressBarView.h"

@interface MusicDownloadListTableCell : UITableViewCell

@property (nonatomic, strong) TYMProgressBarView *progressBarView;

@property (nonatomic,strong)TaskEntity *taskEntity;

@property (nonatomic,strong) NSString                *downloadUrl;
@property (weak, nonatomic ) IBOutlet UILabel        *musicName;

@property (weak, nonatomic ) IBOutlet UILabel        *musicDownloadPercent;
@property (weak, nonatomic ) IBOutlet UIButton       *stopStartBtn;

@property (weak, nonatomic) IBOutlet UIImageView *img;

@property (weak, nonatomic) IBOutlet UILabel *desc;


@property (weak, nonatomic) IBOutlet UIView *contentBgView;
- (IBAction)stopStartAction:(UIButton *)sender;

-(void)showData:(TaskEntity *)taskEntity;


@end
