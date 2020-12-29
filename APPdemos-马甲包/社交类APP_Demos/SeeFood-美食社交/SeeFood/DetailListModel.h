//
//  DetailListModel.h
//  SeeFood
//
//  Created by 陈伟捷 on 15/11/24.
//  Copyright © 2015年 纪洪波. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailListModel : NSObject

/**只有一张图片的URL数组*/
@property(nonatomic, strong)NSArray *albums;
/**标题*/
@property(nonatomic, copy)NSString *title;
/**菜的ID*/
@property(nonatomic, copy)NSString *vegetableId;


#pragma mark --- 步骤界面需要的数据 ---
/**简单介绍*/
@property(nonatomic, copy)NSString *imtro;
/**用料*/
@property(nonatomic, copy)NSString *burden;
/**主材料*/
@property(nonatomic, copy)NSString *ingredients;
/**步骤图片url*/
@property(nonatomic, strong)NSArray *steps;
/**类别*/
@property(nonatomic, copy)NSString *tags;

@end
