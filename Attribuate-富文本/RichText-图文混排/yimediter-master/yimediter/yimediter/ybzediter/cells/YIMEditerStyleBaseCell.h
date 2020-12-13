//
//  YIMEditerStyleBaseCell.h
//  yimediter
//
//  Created by ybz on 2017/11/21.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YIMEditerSetting.h"

@interface YIMEditerStyleBaseCell : UITableViewCell

@property(nonatomic,strong)YIMEditerSetting *setting;
@property(nonatomic,strong)UIView *bottomLineView;


/**
 override to initialize
 please call super
 */
-(void)setup;

/**cell 需要的高度*/
-(CGFloat)needHeight;

@end
