//
//  XDEditTextTool.h
//  XDZHBook
//
//  Created by 刘昊 on 2018/4/18.
//  Copyright © 2018年 刘昊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDEditTextTool : UIView
/**添加图片*/
@property (nonatomic ,copy) void(^addImageBlock)(void);

/**分割线*/
@property (nonatomic ,copy) void(^sepLineBlock)(void);

/**斜体*/
@property (nonatomic ,copy) void(^changeToObliqueBlock)(BOOL isOblique);

/**加粗*/
@property (nonatomic ,copy) void(^changeToBoldBlock)(BOOL isBold);

/**删除线（中划线）*/
@property (nonatomic ,copy) void(^changeToCenterLineBlock)(BOOL isCenterLine);

/**下划线*/
@property (nonatomic ,copy) void(^changeToUnderLineBlock)(BOOL isUnderLine);

/**字体*/
@property (nonatomic ,copy) void(^textFontBlock)(CGFloat textFont);

/**添加超链接*/
@property (nonatomic ,copy) void(^linkBlock)(void);

/**撤销*/
@property (nonatomic ,copy) void(^undoBlock)(void);

/**恢复*/
@property (nonatomic ,copy) void(^restoreBlock)(void);
/**取消键盘/添加键盘*/
@property (nonatomic ,copy) void(^changekeyboardBlock)(BOOL isHidden);

@property (nonatomic,copy) void (^changeTextColerBlock)(UIColor *coler);
@property (nonatomic,assign) BOOL isEdit;

- (void)hiddenView;

@end
