//
//  Helper.m
//
//  Created by 郭军 on 2017/3/16.
//  Copyright © 2017年 ZJNY. All rights reserved.
//

#import "Helper.h"

@implementation Helper

//+(NSDictionary *)JSONObjectWithData:(NSString *)JsString
//{
//    return [[NSJSONSerialization JSONObjectWithData:[JsString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil] deleteNull];
//}

//---------label
+(UILabel *)commonLableWithFrame:(CGRect)Size text:(NSString *)text front:(UIFont *)front textAlignment:(NSTextAlignment)textAlignment
{
    UILabel *label = [[UILabel alloc]init];
    label.frame = Size;
    label.textAlignment = textAlignment;
    label.font = front;
    label.text = text;
    
    return label;
}

//---------image
+(UIImageView *)commonImageWithFram:(CGRect)Size Image:(UIImage *)Image
{
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = Image;
    imageView.frame = Size;

    return imageView;
}

//---------alertView
+(UIAlertView *)alertWith:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    
    return alert;
}

// --------- 无数据背景
//+(UIImageView *)setBgimageView
//{
//    /**
//     *  背景图
//     */
//    UIImageView *BGimageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDE/2 - SCREEN_WIDE/8, SCREEN_HEIGHT/2 - SCREEN_WIDE/8, SCREEN_WIDE/4, SCREEN_WIDE/4)];
//    BGimageView.image = Image(@"NodataBg");
//    
//    return BGimageView;
//}

+(void)ShowAlertWithTitle:(NSString *)title
                   prompt:(NSString *)prompt
                   cancel:(NSString *)cancenl
                  defaultLb:(NSString *)defaultLb
           ViewController:(UIViewController *)viewcontroller
             alertOkClick:(AlertTouchOkBlock)touchOkBlock
             alertNoClick:(AlertTouchNoBlock)touchNoBlock;

{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:prompt preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:defaultLb style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        touchOkBlock(action);
    }];
    
    UIAlertAction *no = [UIAlertAction actionWithTitle:cancenl style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        touchNoBlock(action);
    }];
    
    [alert addAction:ok];
    [alert addAction:no];
    
    [viewcontroller presentViewController:alert animated:YES completion:nil];
}

@end
