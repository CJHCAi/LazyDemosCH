//
//  ZHBGoodDetailViewController.h
//  ZhongHeBao
//
//  Created by 云无心 on 16/12/14.
//  Copyright © 2016年 zhbservice. All rights reserved.
//

#import "ZHBTitleViewPagerController.h"

@interface ZHBGoodDetailViewController : ZHBTitleViewPagerController

@property (nonatomic, copy) NSString *goodId; // 主商品id 
@property (nonatomic, copy) NSString *goodDetailId; // 子商品id 如果传了默认选中该子商品,未传则选用服务器返回的
@property (nonatomic, copy) NSString *refereeId; // 共享联盟id

@end
