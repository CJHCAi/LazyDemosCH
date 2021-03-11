//
//  Tools.h
//  驾照助手
//
//  Created by 淡定独行 on 16/5/9.
//  Copyright © 2016年 肖辉良. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Tools : NSObject


// 处理字符串
-(NSArray *)getAnsWerWithString:(NSString *)str;
// 获取文本size
-(CGSize)sizeWithString:(NSString *)string font:(UIFont *)font;

@end
