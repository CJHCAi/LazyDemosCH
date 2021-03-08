//
//  Tools.m
//  驾照助手
//
//  Created by 淡定独行 on 16/5/9.
//  Copyright © 2016年 肖辉良. All rights reserved.
//

#import "Tools.h"
#define kScreenX [UIScreen      mainScreen].bounds.size.width //屏幕宽度
#define kScreenY [UIScreen      mainScreen].bounds.size.height//屏幕高度

@implementation Tools

// 处理字符串
-(NSArray *)getAnsWerWithString:(NSString *)str
{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    NSArray *arr = [str componentsSeparatedByString:@"<BR>"];
    [array addObject:arr[0]];
    for(int i = 0 ;i<4;i++){
        [array addObject:[arr[i+1] substringFromIndex:2]];
    }
    return array;
    
}

// 获取文本size
- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    [style setLineBreakMode:NSLineBreakByCharWrapping];
    
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake(kScreenX, 8000)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font,NSParagraphStyleAttributeName:style}//传人的字体字典
                                       context:nil];
    
    return rect.size;
}

@end
