//
//  CreateCemViewController.h
//  FamilyTree
//
//  Created by 王子豪 on 16/6/14.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "BaseViewController.h"

@interface CreateCemViewController : BaseViewController
/**新建或者修改墓园 */
@property (nonatomic, assign) BOOL creatOrEditStr;
/** 修改墓园的id*/
@property (nonatomic, assign) NSInteger CeId;
@end
