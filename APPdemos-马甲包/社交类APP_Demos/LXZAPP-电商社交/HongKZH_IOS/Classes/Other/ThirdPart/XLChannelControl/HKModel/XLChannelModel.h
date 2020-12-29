//
//  XLChannelModel.h
//  XLChannelControlDemo
//
//  Created by Apple on 2017/1/11.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLChannelModel : NSObject<NSCoding>
/**
 标题
 */
@property (copy,nonatomic) NSString *title;
@property (copy,nonatomic) NSString *image;
@property (copy,nonatomic) NSString *categoryId;


@end
