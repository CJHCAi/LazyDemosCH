//
//  HKUpdataFromDataModel.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKUpdataFromDataModel : NSObject
@property (nonatomic,assign) int type;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *vaule;
@property (nonatomic, strong)UIImage *image;
@property (nonatomic, strong)NSData *data;

@property (nonatomic, copy)NSString *mimeType;
@end
