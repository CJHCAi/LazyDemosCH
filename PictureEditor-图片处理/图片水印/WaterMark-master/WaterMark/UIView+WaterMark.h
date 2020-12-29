//
//  UIView+WaterMark.h
//  Localization
//
//  Created by 明孔 on 2019/10/15.
//  Copyright © 2019 明孔. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (WaterMark)
-(void)addWaterMarkText:(NSString*)waterText WithTextColor:(UIColor*)color WithFont:(UIFont*)font;

@end

NS_ASSUME_NONNULL_END
