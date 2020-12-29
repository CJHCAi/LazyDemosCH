//
//  HK_ShareViews.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/23.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ActionSheetDidSelectSheetBlock)( NSInteger index);

@interface HK_ShareViews : UIView
@property (nonatomic, copy) ActionSheetDidSelectSheetBlock selectSheetBlock;

+ (void)showSelfBotomWithselectSheetBlock:(ActionSheetDidSelectSheetBlock)selectSheetBlock;

@end
