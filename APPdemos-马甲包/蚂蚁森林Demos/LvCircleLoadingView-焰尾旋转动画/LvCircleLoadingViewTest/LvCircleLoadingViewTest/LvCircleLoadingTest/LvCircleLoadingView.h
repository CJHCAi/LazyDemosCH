//
//  LvCircleLoadingView.h
//  LvCircleLoadingViewTest
//
//  Created by lv on 2016/11/10.
//  Copyright © 2016年 lv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LvCircleLoadingView : UIView
@property(nonatomic,assign)CGFloat lineWidth;
@property(nonatomic,assign)CGFloat lineSpacing;//线和图片间的间距
@property(nonatomic,strong)UIImage *imageLogo;
@property(nonatomic,strong)NSString *alertText;
@property(nonatomic,strong)UILabel *labText;
@property(nonatomic,strong)UIColor *colorStart;
@property(nonatomic,strong)UIColor *colorEnd;

+(void)showWithText:(NSString *)text;
+(void)showWithText:(NSString *)text imgLogo:(UIImage *)image;
+(void)hidden;

@end
