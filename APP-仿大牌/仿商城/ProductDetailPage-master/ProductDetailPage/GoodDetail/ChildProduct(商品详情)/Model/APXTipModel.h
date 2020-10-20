//
//  APXTipModel.h
//  ZhongHeBao
//
//  Created by 云无心 on 2017/7/10.
//  Copyright © 2017年 yangyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APXTipModel : NSObject

@property (nonatomic, strong) NSArray<NSString *> *markList; // 标签
@property (nonatomic, copy) NSString *title; // 左边title
@property (nonatomic, copy) NSString *detail; // 右边detail文本
@property (nonatomic, copy) NSString *url; // 点开的url

@end
