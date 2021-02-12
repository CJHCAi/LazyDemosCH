//
//  PopDropdownMenuView.h
//  TextColorRamp
//
//  Created by admin on 2017/6/22.
//  Copyright © 2017年 王晓丹. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopDropdownMenuViewDelegate <NSObject>

- (void)tableViewDidSelect:(NSInteger)indexRow obj:(id)obj;
- (void)dismissCurrentViewChangeSelectBtnStatues:(id)statues;
@end

@interface PopDropdownMenuView : UIView
//table1数据数组
@property (nonatomic, strong) NSMutableArray *firstArray;
//table2当前数据数组
@property (nonatomic, strong) NSMutableArray *secondArray;
//table2全部数据数组
@property (nonatomic, strong) NSMutableArray *tmpOuterArray;
//自定义页面
@property (nonatomic, strong) UIView *contentView;
//是否展示两个table表样式(前提是展示table表样式下)
@property (nonatomic, assign) NSInteger isTowTable;

@property (nonatomic, weak) id<PopDropdownMenuViewDelegate>delegate;

-(void)show:(BOOL)animated;
-(void)dismiss:(BOOL)animated;

/** 
 *初始化DropdownMenuView（有TableView样式）
 * frame：              DropdownMenuView的frame
 * tableOneWith：       tableView_1宽度（只有一级表单时，默认传屏幕宽度）
 * imageArray:          tableView_1左侧图片数组（没有可忽略，但如果部分标题有图片，则需要中间有占位空字段，即数组个数应一致，数组个数可以小于firstArray数组个数）
 * otherSetting         其他的设置
 */
+(instancetype)PopDropdownMenuViewWithFrame:(CGRect)frame
                               tableOneWith:(CGFloat)tableOneWith
                                 imageArray:(NSArray *)imageArray
                               otherSetting:(void(^)(PopDropdownMenuView *popDropMenuView))otherSetting;


/**
 *初始化DropdownMenuView（自定义View样式）
 * frame：              DropdownMenuView的frame 
 * contentMainView：    自定义的View，frame可在创建时候指定
 * otherSetting         其他的设置
 */
+(instancetype)PopDropdownMenuViewWithFrame:(CGRect)frame
                                contentView:(UIView *)contentMainView
                               otherSetting:(void(^)(PopDropdownMenuView *popDropMenuView))otherSetting;

@end
