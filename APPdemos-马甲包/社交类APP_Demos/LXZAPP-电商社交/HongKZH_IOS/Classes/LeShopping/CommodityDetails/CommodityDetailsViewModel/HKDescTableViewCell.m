//
//  HKDescTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/28.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKDescTableViewCell.h"
@interface HKDescTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *textL;

@end

@implementation HKDescTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(void)setHtmlStr:(NSString *)htmlStr
{
    NSString *htmls = [NSString stringWithFormat:@"<html> \n"
                       "<head> \n"
                       "<meta name=\"viewport\" content=\"initial-scale=1.0, maximum-scale=1.0, user-scalable=no\" /> \n"
                       "<style type=\"text/css\"> \n"
                       "body {font-size:15px;}\n"
                       "</style> \n"
                       "</head> \n"
                       "<body>"
                       "<script type='text/javascript'>"
                       "window.onload = function(){\n"
                       "var $img = document.getElementsByTagName('img');\n"
                       "for(var p in  $img){\n"
                       " $img[p].style.width = '100%%';\n"
                       "$img[p].style.height ='auto'\n"
                       "}\n"
                       "}"
                       "</script>%@"
                       "</body>"
                       "</html>",htmlStr];

    NSAttributedString *briefAttrStr = [[NSAttributedString alloc] initWithData:[htmls dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithAttributedString:briefAttrStr];
    [attr addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]} range:NSMakeRange(0, attr.string.length)];
    
    self.textL.attributedText = [attr copy];
    
}
@end
