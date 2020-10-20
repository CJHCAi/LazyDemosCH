//
//  SXTBuyCarListCell.h
//  SXT
//
//  Created by 赵金鹏 on 16/8/30.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXTBuyCarListModel.h"
@interface SXTBuyCarListCell : UITableViewCell

@property (strong, nonatomic)   UIButton *isSelectBtn;              /** 是否选中 */
@property (strong, nonatomic)   UIButton *addButton;              /** 增加商品个数 */
@property (strong, nonatomic)   UIButton *cutButton;              /** 减少商品个数 */

@property (strong, nonatomic)   SXTBuyCarListModel *cellData;              /** cell的数据源 */

@end
