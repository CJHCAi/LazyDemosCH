//
//  CustomHeadFooterView.h
//  核心动画
//
//  Created by 朱伟阁 on 2019/1/26.
//  Copyright © 2019 朱伟阁. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GroupModel;
@class CustomHeadFooterView;

@protocol CustomHeadFooterViewDelegate <NSObject>

- (void)groupHeaderViewDidClickTitleButton:(CustomHeadFooterView *)headerview;

@end

NS_ASSUME_NONNULL_BEGIN

@interface CustomHeadFooterView : UITableViewHeaderFooterView

+ (instancetype)headFooterViewWithTableview:(UITableView *)tableview;

@property(nonatomic, strong) GroupModel *group;

@property(nonatomic, weak) id<CustomHeadFooterViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
