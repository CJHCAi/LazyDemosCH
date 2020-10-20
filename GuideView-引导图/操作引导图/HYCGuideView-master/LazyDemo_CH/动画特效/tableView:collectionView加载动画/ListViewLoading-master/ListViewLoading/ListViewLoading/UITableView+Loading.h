//
//  UITableView+Loading.h
//  ListViewLoading
//
//  Created by 刘江 on 2019/10/14.
//  Copyright © 2019 Liujiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UITableViewLoadingDelegate <NSObject>
@required
- (NSInteger)loadingTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)loadingTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@optional
- (NSInteger)sectionsOfloadingTableView:(UITableView *)tableView;
- (UIView *)loadingTableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
- (UIView *)loadingTableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;
@end

@interface UITableView (Loading)
@property (nonatomic, readonly)BOOL loading;
@property (nonatomic, weak)id<UITableViewLoadingDelegate> loadingDelegate;


- (void)startLoading;
- (void)stopLoading;

@end

NS_ASSUME_NONNULL_END
