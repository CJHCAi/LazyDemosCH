//
//  AreaChooseView.h
//  CheLian
//
//  Created by imac on 16/5/27.
//  Copyright © 2016年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^returnaTFBlock) (NSString *data);

@interface AreaChooseView : UIView
/**
 *  省
 */
@property (strong,nonatomic) NSString *province;
/**
 *  市
 */
@property (strong,nonatomic) NSString *city;
/**
 *  区
 */
@property (strong,nonatomic) NSString *area;

-(instancetype)initWithAreaFrame:(CGRect)frame;

@property (copy,nonatomic) returnaTFBlock returntextfileBlock;
@end
