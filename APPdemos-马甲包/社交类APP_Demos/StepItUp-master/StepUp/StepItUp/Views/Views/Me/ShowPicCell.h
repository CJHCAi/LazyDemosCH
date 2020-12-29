//
//  ShowPicCell.h
//  StepUp
//
//  Created by syfll on 15/6/13.
//  Copyright (c) 2015年 JFT0M. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowPicCell : UITableViewCell

/**
 *背景图片
 */

@property (weak, nonatomic) IBOutlet UIImageView *backImage;
/**
 *用户头像
 */

@property (weak, nonatomic) IBOutlet UIImageView *headImage;

//修改背景图片
-(void)chageBackImage:(UIImage*)backImage;
//修改头像图片
-(void)chageHeadImage:(UIImage*)headImage;
@end
