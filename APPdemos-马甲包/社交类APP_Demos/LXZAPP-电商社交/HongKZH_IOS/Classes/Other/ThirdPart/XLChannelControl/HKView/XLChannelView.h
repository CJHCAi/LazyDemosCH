//
//  XLChannelView.h
//  XLChannelControlDemo
//
//  Created by Apple on 2017/1/11.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ClickFinshBlock) (NSMutableArray *array);
@interface XLChannelView : UIView
@property(nonatomic,strong)ClickFinshBlock clickFinshBlock;
-(void)isChange:(BOOL)isHiend;
@end
