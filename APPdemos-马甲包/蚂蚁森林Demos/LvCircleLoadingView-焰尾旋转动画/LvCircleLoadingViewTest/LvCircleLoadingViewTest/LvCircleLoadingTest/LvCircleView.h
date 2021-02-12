//
//  LvCircleLoadingView.h
//  LvCircleLoadingViewTest
//
//  Created by lv on 2016/11/10.
//  Copyright © 2016年 lv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LvCircleView : UIView
@property(nonatomic,assign)CGFloat lineWidth;
@property(nonatomic,strong)UIImageView *imgLogo;
@property(nonatomic,assign)CGFloat lineSpacing;//线和图片间的间距
@property(nonatomic,strong)UIColor *colorStart;
@property(nonatomic,strong)UIColor *colorEnd;
@property(nonatomic,strong)UIImage *imageLogo;
@end
