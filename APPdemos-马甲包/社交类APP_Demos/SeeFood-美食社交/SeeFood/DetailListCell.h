//
//  DetailListCell.h
//  SeeFood
//
//  Created by 陈伟捷 on 15/11/24.
//  Copyright © 2015年 纪洪波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailListModel.h"

@interface DetailListCell : UITableViewCell

/**菜的图片*/
@property(nonatomic, strong, readonly)UIImageView *myImageView;
/**标题label*/
@property(nonatomic, strong, readonly)UILabel *titleLabel;
/**简单介绍的label*/
@property(nonatomic, strong, readonly)UILabel *synopsisLabel;
/**数据*/
@property(nonatomic, strong)DetailListModel *model;

+ (CGFloat)rowHeight:(DetailListModel *)model;

@end
