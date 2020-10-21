//
//  CompleteCell.h
//  VideoHandle
//
//  Created by JSB - Leidong on 17/7/13.
//  Copyright © 2017年 JSB - leidong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoModel.h"

@interface CompleteCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *playBtn;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UILabel *msgLab;

@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@property (weak, nonatomic) IBOutlet UIButton *renameBtn;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end
