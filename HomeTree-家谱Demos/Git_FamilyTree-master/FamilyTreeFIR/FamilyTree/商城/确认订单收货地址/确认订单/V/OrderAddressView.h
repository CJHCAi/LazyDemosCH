//
//  OrderAddressView.h
//  ListV
//
//  Created by imac on 16/8/2.
//  Copyright © 2016年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderAddressView : UIView
/**
 *  收货人姓名
 */
@property (strong,nonatomic) UILabel *nameLb;
/**
 *  收货人手机号
 */
@property (strong,nonatomic) UILabel *mobileLb;
/**
 *  收货人默认地址
 */
@property (strong,nonatomic) UILabel *addressLb;
/**
 *  默认图标
 */
@property (strong,nonatomic) UILabel *defaultLb;

@end
