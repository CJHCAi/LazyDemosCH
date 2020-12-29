//
//  HKCollageShareView.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/2.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HKShareBaseModel;
typedef void (^ShareSheetDidSelectSheetBlock)( NSInteger index);

@interface HKCollageShareView : UIView

@property (nonatomic, copy) ShareSheetDidSelectSheetBlock selectSheetBlock;

+ (void)showSelfBotomWithselectSheetBlock:(ShareSheetDidSelectSheetBlock)selectSheetBlock;
+ (void)showSelfBotomWithselectSheetBlock:(ShareSheetDidSelectSheetBlock)selectSheetBlock shareModel:(HKShareBaseModel*)model;
@property (nonatomic, strong)HKShareBaseModel *sharM;

@end
