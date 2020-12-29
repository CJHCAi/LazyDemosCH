//
//  ListModel.h
//  SeeFood
//
//  Created by 陈伟捷 on 15/11/24.
//  Copyright © 2015年 纪洪波. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListModel : NSObject

/**类别名称*/
@property(nonatomic, copy)NSString *name;
/**类别ID*/
@property(nonatomic, copy)NSString *parentId;
/**详细类别ID*/
@property(nonatomic, copy)NSString *listId;

@end
