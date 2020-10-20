//
//  HeadLuckView.h
//  FamilyTree
//
//  Created by 王子豪 on 16/6/4.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeadLuckView : UIView

@property (nonatomic,strong) UIImageView *headPortraits; /*头像*/

@property (nonatomic,strong) UILabel *headPorTime; /*星座日期*/

@property (nonatomic,strong) UILabel *todayDate; /*几号，星期几*/

@property (nonatomic,strong) UILabel *healthNum; /*健康指数*/

@property (nonatomic,strong) UILabel *chatNum; /*商谈指数*/

@property (nonatomic,strong) UILabel *luckyColor; /*幸运颜色*/

@property (nonatomic,strong) UILabel *luckyNum; /*幸运数*/

@property (nonatomic,strong) UILabel *coupleAite; /*速配星座*/

@end
