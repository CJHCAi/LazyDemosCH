//
//  YIMEditerParagraphStyle.m
//  yimediter
//
//  Created by ybz on 2017/11/30.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import "YIMEditerParagraphStyle.h"
#import "YIMEditerDrawAttributes.h"

@interface YIMEditerParagraphStyle()
/**
 emmmmm.....这里获取一个字体大小用于设置css的line-height，css不支持直接设置行间距，要设置行高
 */
@property(nonatomic,assign)CGFloat fontSize;
@end

@implementation YIMEditerParagraphStyle

-(instancetype)initWithAttributed:(YIMEditerMutableDrawAttributes *)drawAttributed{
    NSDictionary *attributed = drawAttributed.textAttributed;
    self = [[self class]createDefualtStyle];
    if ([attributed.allKeys containsObject:NSParagraphStyleAttributeName]) {
        NSParagraphStyle *s = [attributed objectForKey:NSParagraphStyleAttributeName];
        self.firstLineIndent = s.firstLineHeadIndent > 0;
        self.alignment = s.alignment;
        self.lineSpacing = s.lineSpacing;
    }
    if ([attributed.allKeys containsObject:NSFontAttributeName]) {
        UIFont *font = [attributed objectForKey:NSFontAttributeName];
        self.fontSize = font.pointSize;
    }
    return self;
}
-(YIMEditerDrawAttributes*)outPutAttributed{
    NSMutableParagraphStyle *s = [[NSMutableParagraphStyle alloc]init];
    if(self.firstLineIndent)
        s.firstLineHeadIndent = 28;
    else
        s.firstLineHeadIndent = 0;
    s.alignment = self.alignment;
    s.lineSpacing = self.lineSpacing;
    s.paragraphSpacing = self.lineSpacing;
    YIMEditerMutableDrawAttributes *drawAttributed = [[YIMEditerMutableDrawAttributes alloc]init];
    drawAttributed.textAttributed = @{NSParagraphStyleAttributeName:s};
    drawAttributed.paragraphAttributed = @{NSParagraphStyleAttributeName:s};
    return drawAttributed;
}

+(instancetype)createDefualtStyle{
    YIMEditerParagraphStyle *style = [[YIMEditerParagraphStyle alloc]init];
    style.firstLineIndent = false;
    style.alignment = NSTextAlignmentNatural;
    style.lineSpacing = 5.0;
    return style;
}

-(BOOL)isParagraphStyle{
    return true;
}

-(instancetype)copy{
    YIMEditerParagraphStyle *paragraphStyle = [[YIMEditerParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = self.lineSpacing;
    paragraphStyle.firstLineIndent = self.firstLineIndent;
    paragraphStyle.alignment = self.alignment;
    return paragraphStyle;
}
-(instancetype)copyWithZone:(NSZone *)zone{
    return [self copy];
}

-(NSString*)htmlStyle{
    NSMutableString* style = [NSMutableString string];
    if (self.firstLineIndent) {
        [style appendString:@"text-indent:14px;"];
    }else{
        [style appendString:@"text-indent:0px;"];
    }
    [style appendFormat:@"line-height:%.1fpx;",self.lineSpacing + 16];
    
    NSString* textAlign = @"left";
    switch (self.alignment) {
        case NSTextAlignmentCenter:
            textAlign = @"center";
            break;
        case NSTextAlignmentRight:
            textAlign = @"right";
            break;
        default:
            break;
    }
    [style appendFormat:@"text-align:%@;",textAlign];
    return style;
}

+(instancetype)createWithHtmlElement:(struct HtmlElement)element content:(NSString *__autoreleasing *)content{
    YIMEditerParagraphStyle* paragraphStyle = [YIMEditerParagraphStyle createDefualtStyle];
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[NSData dataWithBytes:element.attr_json length:strlen(element.attr_json)] options:NSJSONReadingMutableLeaves error:&error];
    if (!error && [json isKindOfClass:[NSDictionary class]] && [json.allKeys containsObject:@"style"]) {
        NSString* style = json[@"style"];
        NSArray<NSString*>* attrs = [style componentsSeparatedByString:@";"];
        for (NSString* attr in attrs) {
            NSArray<NSString*>* key_value = [attr componentsSeparatedByString:@":"];
            if (key_value.count == 2) {
                if ([key_value[0] isEqualToString:@"text-indent"]) {
                    NSString* value = key_value[1];
                    if ([value hasSuffix:@"px"]) {
                        paragraphStyle.firstLineIndent = [value substringToIndex:value.length - 2].integerValue != 0;
                    }
                }
                if ([key_value[0] isEqualToString:@"line-height"]) {
                    NSString* value = key_value[1];
                    if ([value hasSuffix:@"px"]) {
                        paragraphStyle.lineSpacing = [value substringToIndex:value.length - 2].integerValue - 16;
                    }
                }
                if ([key_value[0] isEqualToString:@"text-align"]) {
                    if ([key_value[1] isEqualToString:@"left"]) {
                        paragraphStyle.alignment = NSTextAlignmentLeft;
                    }
                    if ([key_value[1] isEqualToString:@"center"]) {
                        paragraphStyle.alignment = NSTextAlignmentCenter;
                    }
                    if ([key_value[1] isEqualToString:@"right"]) {
                        paragraphStyle.alignment = NSTextAlignmentRight;
                    }
                }
            }
        }
    }
    return paragraphStyle;
}


@end
