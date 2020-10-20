//
//  ModifyAddressViewController.h
//  CheLian
//
//  Created by imac on 16/5/27.
//  Copyright © 2016年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReceiveAddressModel.h"

@interface ModifyAddressViewController : BaseViewController

@property (strong,nonatomic)ReceiveAddressModel *modifyAddressModel;

@property (strong,nonatomic) NSString *areaAdd;

/**
 *  是否是默认地址
 */
@property (nonatomic) BOOL isDefalut;
@end
