//
//  DownloadCell.h
//  VideoHandle
//
//  Created by JSB - Leidong on 17/7/13.
//  Copyright © 2017年 JSB - leidong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloadCell : UITableViewCell

@property (strong, nonatomic) UIProgressView *progressView;

@property (strong, nonatomic) UILabel *progressLab;

@property (strong, nonatomic) UILabel *titleLab;

@property (strong, nonatomic) UIButton *controlBtn;

@property (strong, nonatomic) UIButton *deleteBtn;

@end
