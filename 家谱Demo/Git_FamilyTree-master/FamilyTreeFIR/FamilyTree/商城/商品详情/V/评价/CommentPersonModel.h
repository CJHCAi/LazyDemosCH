//
//  CommentPersonModel.h
//  ListV
//
//  Created by imac on 16/7/22.
//  Copyright © 2016年 imac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentPersonModel : NSObject
/**
 *  用户头像
 */
@property (strong,nonatomic) NSString *headImg;
/**
 *  用户名
 */
@property (strong,nonatomic) NSString *userName;
/**
 *  评价星级
 */
@property (strong,nonatomic) NSString *star;
/**
 *  日期
 */
@property (strong,nonatomic) NSString *date;
/**
 *  评价
 */
@property (strong,nonatomic) NSString *content;
/**
 *  颜色
 */
@property (strong,nonatomic) NSString *color;
/**
 *  规格
 */
@property (strong,nonatomic) NSString *size;
@end
