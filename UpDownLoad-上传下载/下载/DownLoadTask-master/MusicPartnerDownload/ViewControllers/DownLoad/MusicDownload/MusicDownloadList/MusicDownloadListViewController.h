//
//  MusicDownloadListViewController.h
//  MusicPartnerDownload
//
//  GitHub:https://github.com/szweee
//  Blog:  http://www.szweee.com
//
//  Created by 索泽文 on 16/2/12.
//  Copyright © 2016年 索泽文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface MusicDownloadListViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

+(MusicDownloadListViewController *)shareManager;


@end
