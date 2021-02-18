//
//  ReceiveAddressModel.h
//  CheLian
//
//  Created by imac on 16/5/27.
//  Copyright © 2016年 imac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReceiveAddressModel : NSObject
/**
 *  收货地址表id
 */
@property (strong,nonatomic) NSString *raID;
/**
 *  收货人
 */
@property (strong,nonatomic) NSString *realname;
/**
 *  收货人电话
 */
@property (strong,nonatomic) NSString *mobile;
/**
 *  省
 */
@property (strong,nonatomic) NSString *Province;
/**
 *  市
 */
@property (strong,nonatomic) NSString *city;
/**
 *  区/县
 */
@property (strong,nonatomic) NSString *area;
/**
 *  详细街道门牌号码
 */
@property (strong,nonatomic) NSString *address;
/**
 *  邮编
 */
@property (strong,nonatomic) NSString *zipcode;
/**是否默认*/
@property (nonatomic,strong) NSString *defaultCode;

/**地址id*/
@property (nonatomic,strong) NSString *addressId;



@end
