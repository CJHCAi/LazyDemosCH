//
//  NSString+WJudgeStringlegal.m
//  FamilyTree
//
//  Created by 王子豪 on 16/7/15.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "NSString+WJudgeStringlegal.h"

@implementation NSString (WJudgeStringlegal)
+(BOOL)judgeWithString:(NSString *)string{
    if (!string) {
        return false;
    }
    
    NSInteger continuousCount = 0;
    NSInteger letterCount = 0;
    for(int i=0; i< [string length];i++){
        int a = [string characterAtIndex:i];
        //首字符为汉字
        if (i==0&&!( a > 0x4e00 && a < 0x9fff)) {
            [self showAlterWithTitle:@"请输入正确的格式"];
            return false;
        }
        
        //是汉字
        if( a > 0x4e00 && a < 0x9fff){
            if (letterCount==1) {
                letterCount-=1;
            }
            continuousCount+=1;
        }else{
            
            //不是汉字，是逗号
            letterCount+=1;
            if (continuousCount==1) {
                 continuousCount-=1;
            }
            
            
            //连续两个letter
            if (letterCount==2) {
                
                [self showAlterWithTitle:@"输入格式有误"];
                letterCount = 0;
                return false;
            }
            
            //不是逗号
            if (!(a==44||a==65292)) {
                [self showAlterWithTitle:@"请用','隔开"];
                return false;
            }
            
        }
        //连续两个汉字
        if (continuousCount==2) {
            [self showAlterWithTitle:@"字辈只能为一个字"];
            continuousCount = 0;
            return false;
        }
        //连续两个letter
        if (letterCount==2) {
            
            [self showAlterWithTitle:@"输入格式有误"];
            letterCount = 0;
            return false;
        }
  
    }
    return YES;
    
}

+(void)showAlterWithTitle:(NSString *)title{
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"" message:title preferredStyle:UIAlertControllerStyleAlert];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVc animated:YES completion:nil];
    
}
@end
