//
//  LLTableViewDataSource.h
//  ListViewLoading
//
//  Created by 刘江 on 2019/10/15.
//  Copyright © 2019 Liujiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UITableView+Loading.h"
NS_ASSUME_NONNULL_BEGIN

@interface LLTableViewDataSource : NSObject
@property (nonatomic, weak)id<UITableViewDataSource> replace_dataSource;
@property (nonatomic, weak)id<UITableViewDelegate> replace_delegate;
@property (nonatomic, weak)id<UITableViewLoadingDelegate> loadingDelegate;

//@property (nonatomic, readonly)BOOL loading;
//@property (nonatomic, weak)id<UITableViewDataSource> reverseDelegate;


@end

NS_ASSUME_NONNULL_END
