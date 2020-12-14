//
//  NSAttributedString+Rich.m
//  XDZHBook
//
//  Created by 刘昊 on 2018/4/24.
//  Copyright © 2018年 刘昊. All rights reserved.
//

#import "NSAttributedString+Rich.h"
#import "UIColor+HEX.h"
@implementation NSAttributedString (Rich)
-(NSMutableArray *)getArrayWithAttributed
{
    
    static NSDictionary *nameToWeight;
    NSMutableArray * array=[NSMutableArray array];
    
    //枚举出所有的附件字符串-这个是顺序来的NSAttributedStringEnumerationLongestEffectiveRangeNotRequired
    [self enumerateAttributesInRange:NSMakeRange(0, self.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary *Attributes, NSRange range, BOOL *stop) {
        NSMutableDictionary * AttributeDict=[NSMutableDictionary dictionary];
        //1.  通过range取出相应的字符串
        NSString * title=[self.string substringWithRange:range];
        //1.把属性字典和相应字符串成为一个大字典
        if (title!=nil) {
            [AttributeDict setObject:title forKey:@"title"];
        }
  
        UIFont * font= Attributes[@"NSFont"];
        NSLog(@"%@",Attributes);
        if (font!=nil) {
            //这里这两种都可以
            CGFloat size=font.fontDescriptor.pointSize;
            [AttributeDict setObject:[NSNumber numberWithFloat:size] forKey:@"font"];
        }
        //2.取出字体描述fontDescriptor
    
        NSString *bold = Attributes[@"NSStrokeWidth"];
        
        if ([bold integerValue] <0.0) {
            [AttributeDict setObject:[NSNumber numberWithBool:YES] forKey:@"bold"];
        }
        else
        {
            [AttributeDict setObject:[NSNumber numberWithBool:NO] forKey:@"bold"];
        }

        NSString *NSUnderline = Attributes[@"NSUnderline"];
        
        if ([NSUnderline integerValue] > 0.0) {
            [AttributeDict setObject:[NSNumber numberWithBool:YES] forKey:@"underline"];
        }
        else
        {
            [AttributeDict setObject:[NSNumber numberWithBool:NO] forKey:@"underline"];
        }
        NSString *obliq = Attributes[@"NSObliqueness"];
        
        if ([obliq doubleValue] > 0.0) {
            [AttributeDict setObject:[NSNumber numberWithBool:YES] forKey:@"obliq"];
        }
        else
        {
            [AttributeDict setObject:[NSNumber numberWithBool:NO] forKey:@"obliq"];
        }

        
        
        //2.字体－颜色
        UIColor * fontColor= Attributes[@"NSColor"];
        if (fontColor!=nil) {
            [AttributeDict setObject:[fontColor HEXString] forKey:@"color"];
        }
        //2.图片
        NSTextAttachment * ImageAtt = Attributes[@"NSAttachment"];
        if (ImageAtt!=nil) {
        @autoreleasepool {
            NSData *data = UIImageJPEGRepresentation(ImageAtt.image, 1.0f);
            NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            [AttributeDict setObject:encodedImageStr forKey:@"image"];
            //这里为title加上图片标示
            //[AttributeDict setObject:@"[image]" forKey:@"title"];
        }
        }
        //2.行间距
        NSParagraphStyle * paragraphStyle= Attributes[@"NSParagraphStyle"];
        [AttributeDict setObject:[NSNumber numberWithFloat:paragraphStyle.lineSpacing] forKey:@"lineSpace"];
        //4.返回一个数组
        [array addObject:AttributeDict];
        
        
    }];
    
    
    return array;
    

    //    //枚举出所有的附件字符串-这个是反着来的NSAttributedStringEnumerationReverse，
    //    [self enumerateAttributesInRange:NSMakeRange(0, self.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary *Attributes, NSRange range, BOOL *stop) {
    //
    //
    //         NSMutableDictionary * AttributeDict=[NSMutableDictionary dictionary];
    //        //1.  通过range取出相应的字符串
    //        NSString * title=[self.string substringWithRange:range];
    //        //1.把属性字典和相应字符串成为一个大字典
    //        if (title!=nil) {
    //            [AttributeDict setObject:title forKey:@"title"];
    //        }
    //        //2.把属性存储为一个字典
    //
    //        //2.取出相应的属性
    //        //2.字体－大小－加粗:NSOriginalFont,NSFont这里有两个
    //        UIFont * font= Attributes[@"NSFont"];
    //        if (font!=nil) {
    //            //这里这两种都可以
    ////             NSLog(@"fontSize1--%@",[font.fontDescriptor objectForKey:@"NSFontSizeAttribute"]);
    ////             NSLog(@"fontSize2--%f",font.fontDescriptor.pointSize);
    //            CGFloat size=font.fontDescriptor.pointSize;
    //            [AttributeDict setObject:[NSNumber numberWithFloat:size] forKey:@"font"];
    //        }
    //       //2.取出字体描述fontDescriptor
    //        NSDictionary *traits = [font.fontDescriptor objectForKey:UIFontDescriptorTraitsAttribute];
    //        CGFloat weight=[traits[UIFontWeightTrait] doubleValue];
    //        if (weight>0.0) {
    //             [AttributeDict setObject:[NSNumber numberWithBool:YES] forKey:@"bold"];
    //        }
    //        else
    //        {
    //             [AttributeDict setObject:[NSNumber numberWithBool:NO] forKey:@"bold"];
    //        }
    //        //可以得到字体加粗的大小
    ////         NSLog(@"fontbold--%f",[traits[UIFontWeightTrait] doubleValue]);
    ////            if ([traits[UIFontWeightTrait] doubleValue] == 0.0) {
    ////                for (NSString *name in nameToWeight) {
    ////                    if ([font.fontName.lowercaseString containsString:name]) {
    ////                        NSLog(@"normal---%f",[nameToWeight[name] doubleValue]) ;
    ////                    }
    ////                }
    ////            }
    //
    //
    //
    //         //2.字体－颜色
    //        UIColor * fontColor= Attributes[@"NSColor"];
    //        if (fontColor!=nil) {
    //
    //            [AttributeDict setObject:[self getRGBDictionaryByColor:fontColor] forKey:@"color"];
    //        }
    //        //2.图片
    //        ImageTextAttachment * ImageAtt = Attributes[@"NSAttachment"];
    //        if (ImageAtt!=nil) {
    //            [AttributeDict setObject:@"image" forKey:@"image"];
    //        }
    //        //2.行间距
    //       NSParagraphStyle * paragraphStyle= Attributes[@"NSParagraphStyle"];
    //        [AttributeDict setObject:[NSNumber numberWithFloat:paragraphStyle.lineSpacing] forKey:@"lineSpace"];
    //
    //
    //        //4.返回一个数组
    //        [array addObject:AttributeDict];
    //
    //    }];
    
}


@end
