//
//  HKUpdateResumeListBasicCell.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/21.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UpdateResumeIndexBlock)(NSInteger index, id obj);
typedef void(^AddResumeBlock)(void);

@interface HKUpdateResumeListBasicCell : UITableViewCell <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *items;

@property (nonatomic, copy) UpdateResumeIndexBlock block;

@property (nonatomic, copy) AddResumeBlock addResumeBlock;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier block:(UpdateResumeIndexBlock) block addResumeBlock:(AddResumeBlock)addResumeBlock;

@end
