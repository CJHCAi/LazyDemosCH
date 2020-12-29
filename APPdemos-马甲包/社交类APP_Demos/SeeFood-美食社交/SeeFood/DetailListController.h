//
//  DetailListController.h
//  SeeFood
//
//  Created by 陈伟捷 on 15/11/24.
//  Copyright © 2015年 纪洪波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListModel.h"

typedef void(^noteListID)(NSInteger listID);

@interface DetailListController : UIViewController

@property(nonatomic, strong)ListModel *model;
@property(nonatomic, copy)NSString *name;

@property(nonatomic, assign)NSInteger listID;

@property(nonatomic, strong)NSArray *listArray;

/**搜索内容*/
@property(nonatomic, copy)NSString *search;
/**是否是从搜索界面Push过来的*/
@property(nonatomic, assign)BOOL isPushed;

- (void)takeNoteListID:(noteListID)block;

@end
