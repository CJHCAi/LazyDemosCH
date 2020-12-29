//
//  DetailCell.h
//  SeeFood
//
//  Created by 陈伟捷 on 15/11/25.
//  Copyright © 2015年 纪洪波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailListModel.h"

@interface DetailCell : UITableViewCell

/**主图*/
@property(nonatomic, strong)UIImageView *myImageView;

@property(nonatomic, strong)DetailListModel *model;

+ (CGFloat)rowHeight:(DetailListModel *)model;


@end
