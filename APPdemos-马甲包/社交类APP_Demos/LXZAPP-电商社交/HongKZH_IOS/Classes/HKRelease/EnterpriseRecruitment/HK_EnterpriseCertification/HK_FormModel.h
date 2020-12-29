//
//  HK_FormModel.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
    表单提交的 model ,解决 cell 复用以及数据提交的问题
 */

@interface HK_FormModel : NSObject

@property (nonatomic, strong, nonnull) NSString *cellTitle;  //cell 显示的标题

@property (nonatomic, strong) id value;     //cell 中要提交的数据 (textfield 中数据/选择的数据/图片数据..)

@property (nonatomic, strong, nonnull) NSString *postKey;    //提交数据的参数

@property (nonatomic, assign) CGFloat cellHeight;   //单元格高度,不传默认高度48;

@property (nonatomic, assign) BOOL required;        //参数是否是必须的,默认是必须的

//工厂方法
+ (instancetype)formModelWithCellTitle:(NSString *)cellTitle value:(id)value postKey:(NSString *)postKey;

//验证数据完整性
- (void)verifyDataIntegrityWithFaliureBlock:(void(^)(NSString *cellTitle)) block;

@end
