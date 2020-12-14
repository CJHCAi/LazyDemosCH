//
//  DLTaskTableViewCell.h
//  DownLoadTest
//
//  Created by 李五民 on 15/10/23.
//  Copyright © 2015年 李五民. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DLDownloadUrlModel;
@interface DLTaskTableViewCell : UITableViewCell

@property (nonatomic, copy) void (^startDownloadBlock)();
- (void)configUIWithModel:(DLDownloadUrlModel *)urlModel;

@end

