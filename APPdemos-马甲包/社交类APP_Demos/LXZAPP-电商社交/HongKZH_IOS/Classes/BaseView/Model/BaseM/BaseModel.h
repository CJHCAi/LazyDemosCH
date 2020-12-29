//
//  BaseModel.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/4/17.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "CNTreeNode/CNTreeNode.h"
#import <Foundation/Foundation.h>
//#import "LKDBHelper.h"
#import "CNTreeNode.h"

@interface BaseModel : CNTreeNode
@property(nonatomic , copy)NSString * imageurl;
@property(nonatomic , copy)NSString * bgimageurl;
//@property(nonatomic , assign)CGSize imgsize;
@property(nonatomic , assign)Size imgsize;
//@property(nonatomic,strong) NSNumber *pageSize;
@property(nonatomic,strong) NSNumber *page;

@end

@interface NSObject(PrintSQL)
+(NSString*)getCreateTableSQL;
@end
