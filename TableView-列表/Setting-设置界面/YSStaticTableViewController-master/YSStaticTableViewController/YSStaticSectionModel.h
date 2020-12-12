//
//  YSStaticSectionModel.h
//  YSStaticTableViewControllerDemo
//
//  Created by MOLBASE on 2018/7/18.
//  Copyright © 2018年 YangShen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class YSStaticCellModel;
@interface YSStaticSectionModel : NSObject

@property (nonatomic, copy) NSString *sectionHeaderTitle;   ///< header标题
@property (nonatomic, copy) NSString *sectionFooterTitle;   ///< footer标题
@property (nonatomic, assign) CGFloat sectionHeaderHeight;  ///< header高度, default 10
@property (nonatomic, assign) CGFloat sectionFooterHeight;  ///< footer的高度, default 0
@property (nonatomic, strong) NSMutableArray<YSStaticCellModel *> *cellModelArray;   ///< section下的items

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new  NS_UNAVAILABLE;
- (instancetype)initWithItemArray:(NSArray<YSStaticCellModel *> *)cellModelArray NS_DESIGNATED_INITIALIZER;
+ (instancetype)sectionWithItemArray:(NSArray<YSStaticCellModel *> *)cellModelArray;

@end
