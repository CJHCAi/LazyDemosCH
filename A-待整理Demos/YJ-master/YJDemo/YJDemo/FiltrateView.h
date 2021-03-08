//
//  FiltrateView.h
//  JingBanYun
//
//  Created by zhu on 2017/5/5.
//  Copyright © 2017年 YJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FiltrateViewBlock)(void);

@interface FiltrateView : UIView

@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *scrArray;

@property(nonatomic,copy)FiltrateViewBlock sendBlock;

@end
