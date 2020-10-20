//
//  YSStaticCellModel.h
//  YSStaticTableViewControllerDemo
//
//  Created by MOLBASE on 2018/7/18.
//  Copyright © 2018年 YangShen. All rights reserved.
//
//  所有自定义Model的基类 YSStaticCellModel

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YSStaticCellType) {
    YSStaticCellTypeAccessoryNone,                  // 右侧无箭头
    YSStaticCellTypeAccessorySwitch,                // 右侧有个Switch控件
    YSStaticCellTypeAccessoryArrow,                 // 右侧有箭头
    YSStaticCellTypeButton,                         // Cell是个按钮的作用
    YSStaticCellTypeCustom,                         // 自定义Cell
};

@interface YSStaticCellModel : NSObject

@property (nonatomic, assign) YSStaticCellType cellType;        ///< cell类型, 默认有箭头
@property (nonatomic, copy  ) NSString *cellClassName;          ///< cell类名, 默认YSStaticTableViewCell
@property (nonatomic, copy  ) NSString *cellIdentifier;         ///< cell标识
@property (nonatomic, assign) CGFloat   cellHeight;             ///< cell高度

@property (nonatomic, copy  ) void(^didSelectCellBlock)(YSStaticCellModel *cellModel, NSIndexPath *indexPath); ///< 点击Cell调用的block

@end

@interface YSStaticDefaultModel: YSStaticCellModel

// 左侧
@property (nonatomic, copy  ) NSString *titleImageName;         ///< 左侧图片名
@property (nonatomic, copy  ) NSString *titleImageUrl;          ///< 左侧图片Url
@property (nonatomic, copy  ) NSString *title;                  ///< 左侧标题
@property (nonatomic, assign) CGSize    titleImageSize;         ///< 左侧图片Size
@property (nonatomic, strong) UIColor  *titleColor;             ///< 左侧标题颜色
@property (nonatomic, strong) UIFont   *titleFont;              ///< 左侧标题字体
@property (nonatomic, assign) CGFloat   titleImageSpace;        ///< 标题与图片的间隔
@property (nonatomic, assign) BOOL      isTitleImageRight;      ///< 图片是否在文字右侧，默认NO

// 右侧
@property (nonatomic, copy  ) NSString *indicatorImageName;     ///< 右侧图片名
@property (nonatomic, copy  ) NSString *indicatorImageUrl;      ///< 右侧图片Url
@property (nonatomic, copy  ) NSString *indicatorTitle;         ///< 右侧标题
@property (nonatomic, assign) CGSize    indicatorImageSize;     ///< 右侧图片Size
@property (nonatomic, strong) UIColor  *indicatorTitleColor;    ///< 右侧标题颜色
@property (nonatomic, strong) UIFont   *indicatorTitleFont;     ///< 右侧标题字体
@property (nonatomic, assign) CGFloat   indicatorImageSpace;    ///< 右侧标题与图片的间隔
@property (nonatomic, assign) BOOL      isIndicatorImageLeft;   ///< 右侧图片是否在文字左侧，默认NO

@property (nonatomic, readonly, assign) BOOL showTitleImage;
@property (nonatomic, readonly, assign) BOOL showIndicatorImage;
@property (nonatomic, readonly, assign) CGSize titleSize;           ///< 左侧标题Size
@property (nonatomic, readonly, assign) CGSize indicatorTitleSize;  ///< 右侧标题Size

// Block
@property (nonatomic, copy  ) void(^switchValueDidChangeBlock)(BOOL isOn);      ///< 切换switch开关的时候调用的block

@end
