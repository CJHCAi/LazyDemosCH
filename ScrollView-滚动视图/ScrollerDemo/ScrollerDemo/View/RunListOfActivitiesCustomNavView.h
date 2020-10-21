//
//  RunListOfActivitiesCustomNavView.h
//  SportChina
//
//  Created by 磊磊 on 2017/6/27.
//  Copyright © 2017年 Beijing Sino Dance Culture Media Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RunListOfActivitiesCustomNavView : UIView
@property (nonatomic,strong)UIView      *backView;
@property (nonatomic,strong)UILabel     *labelTitle;
@property (nonatomic,strong)UIImageView *rightImage;
@property (nonatomic,strong)UIImageView *leftImage;
@property (nonatomic,strong)UIView      *rightView;
@property (nonatomic,strong)UIView      *leftView;
@property (nonatomic,strong)UIView      *lineView;
@property (nonatomic,  copy)void (^clickBlock)(NSString *type);//0左边 1右边
@end
