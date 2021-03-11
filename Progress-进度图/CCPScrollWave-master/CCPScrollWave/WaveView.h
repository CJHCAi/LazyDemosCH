//
//  WaveView.h
//  QHPay
//
//  Created by liqunfei on 16/3/22.
//  Copyright © 2016年 chenlizhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UIView(Frame)
@property (nonatomic,assign)CGFloat top;
@property (nonatomic,assign)CGFloat bottom;
@property (nonatomic,assign)CGFloat left;
@property (nonatomic,assign)CGFloat right;
@property (nonatomic,assign)CGFloat width;
@property (nonatomic,assign)CGFloat height;
@end


@interface WaveView : UIView
@property (nonatomic,strong)UIImageView *waveImgView;
@property (nonatomic,strong)NSString *percent;
@property (nonatomic,strong)NSString *money;
- (void)buildUI;
- (void)addAnimate;
@end
