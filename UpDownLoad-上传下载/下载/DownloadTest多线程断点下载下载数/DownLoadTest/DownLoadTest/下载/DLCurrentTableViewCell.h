//
//  DLCurrentTableViewCell.h
//  DownLoadTest
//
//  Created by 李五民 on 15/10/24.
//  Copyright © 2015年 李五民. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DLButtonStatusType) {
    DLButtonStatusStart = 1,
    DLButtonStatusSuspend,
    DLButtonStatusFail,
};

typedef NS_ENUM(NSInteger, DLTextStatusType) {
    DLTextStatusStart = 1,
    DLTextStatusSuspend,
    DLTextStatusFail,
};

@class DLDownloadModel;
@interface DLCurrentTableViewCell : UITableViewCell

- (void)configUIWithDownloadModel:(DLDownloadModel *)model;
- (void)autoSuspendTask;
- (void)configUIWithButtonStatus:(NSInteger)buttonStatus statusTask:(NSInteger)statusTask;
- (void)startTask;
- (void)taskFail;
@property (nonatomic, copy) void (^failDowloadBlock)(NSString *string);

@end
