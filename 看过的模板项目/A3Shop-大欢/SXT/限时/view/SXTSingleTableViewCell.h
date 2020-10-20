//
//  SXTSingleTableViewCell.h
//  SXT
//
//  Created by 赵金鹏 on 16/8/22.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXTSingleListModel.h"//存储数据的model模型
@interface SXTSingleTableViewCell : UITableViewCell

@property (strong, nonatomic)   SXTSingleListModel *singleModel;              /** model */

@end
