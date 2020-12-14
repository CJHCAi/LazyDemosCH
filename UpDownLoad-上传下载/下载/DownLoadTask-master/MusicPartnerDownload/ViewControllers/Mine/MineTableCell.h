//
//  MineTableCell.h
//  MusicPartnerDownload
//
//  GitHub:https://github.com/szweee
//  Blog:  http://www.szweee.com
//
//  Created by 索泽文 on 16/2/10.
//  Copyright © 2016年 索泽文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DRCellSlideGestureRecognizer.h"
@interface MineTableCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *name;

-(void)configurePanDelete:(DRCellSlideActionBlock)drCellSlideActionBlock;

@end
