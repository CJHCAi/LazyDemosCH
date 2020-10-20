//
//  FlyBarrageTextView.h
//  FamilyTree
//
//  Created by 姚珉 on 16/7/6.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlyBarrageTextView : UILabel
/** 定时器*/
@property (nonatomic, strong) NSTimer *timer;
-(instancetype)initWithY:(CGFloat)y AndText:(NSString*)text AndWordSize:(CGFloat)wordSize;
@end
