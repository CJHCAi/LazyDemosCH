//
//  BaiduMobAdChuileiAdObject.h
//  BaiduMobAdSDK
//
//  Created by lishan04 on 16/7/11.
//  Copyright © 2016年 Baidu Inc. All rights reserved.
//

#import "BaiduMobAdNativeAdObject.h"

@interface BaiduMobAdChuileiAdObject : BaiduMobAdNativeAdObject
/**
 * 标题 text
 */
@property (copy, nonatomic)  NSString *title;

/**
 * 大图 url
 */
@property (copy, nonatomic) NSString *mainImageURLString;

@end
