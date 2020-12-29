//
//  HKHtmlTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/29.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKHtmlTableViewCell.h"
@interface HKHtmlTableViewCell()<UIScrollViewDelegate,UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h;

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic,assign) CGFloat cY;
@end

@implementation HKHtmlTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.webView.delegate = self;
    self.webView.scrollView.scrollEnabled = NO;
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
     self.h.constant = webView.scrollView.contentSize.height;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([self.delegate respondsToSelector:@selector(htmlScroll:)]) {
        [self.delegate htmlScroll:scrollView.contentOffset.y-self.cY ];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setHtmlStr:(NSString *)htmlStr{
    _htmlStr = htmlStr;
    NSString *content = [htmlStr stringByReplacingOccurrencesOfString:@"&amp;quot" withString:@"'"];
    content = [content stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    content = [content stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    content = [content stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
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
                       "</html>",content];
    
    
    [self.webView loadHTMLString:htmls baseURL:nil];
}
@end
