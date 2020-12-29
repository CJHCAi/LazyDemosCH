//
//  HKSelfMeidaVodeoViewController.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/19.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewController.h"

@interface HKSelfMeidaVodeoViewController : HKBaseViewController
@property (nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, assign) NSInteger selectRow;
@property (nonatomic, copy) NSString *sourceType;
-(void)play;

@end
