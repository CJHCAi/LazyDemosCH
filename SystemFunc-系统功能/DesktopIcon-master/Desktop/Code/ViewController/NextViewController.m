//
//  NextViewController.m
//  Desktop
//
//  Created by 罗泰 on 2018/11/6.
//  Copyright © 2018 chenwang. All rights reserved.
//

#import "NextViewController.h"
#import <CocoaHTTPServer/HTTPServer.h>
#import "Module.h"


@interface NextViewController ()
@property (nonatomic, strong) HTTPServer            *server;

@end

@implementation NextViewController

- (instancetype)initWithModel:(Module *)model {
    if (self = [super init])
    {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        NextViewController *nextVC = [sb instantiateViewControllerWithIdentifier:@"NextViewController"];
        nextVC.model = model;
        return nextVC;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.navigationItem.title = self.model.title;
}


- (IBAction)addToDesktopButtonClick:(UIButton *)sender {
    if (sender.tag == 0)
    {
        // 方式一
        [self startServer1];
    }
    else
    {
        // 方式二
        [self startServer2];
    }
}


/// 过度网页放在服务端
- (void)startServer1 {
    /*
     这种方式所有处理都在服务端网页上
     App基本不需要写多余的代码.直接跳转到指定的引导url地址就可以了.
     缺点就是这种方式添加的桌面快捷方式,在没网的情况下,用户点击桌面上的快捷图标是不能跳转到app里面来的
     */
    NSString *baseUrl = @"http://172.16.1.72:8080/iOS-Desktop/index";
    NSString *urlStrWithPort = [NSString stringWithFormat:@"%@%ld.jsp", baseUrl, self.model.code];
    [self openUrl:[NSURL URLWithString:urlStrWithPort]];
}

/// 过度网页在服务端
/// 但是本地有一个配置网页
- (void)startServer2 {
    //1.将需要添加到桌面快捷的icon base64编码
    NSString *iconDataString = [self base64StringFromPNGImageName:@"demo.png"];
    NSString *iconString = [NSString stringWithFormat:@"data:image/png;base64,%@", iconDataString];
    
    // 2.引导图:放在服务端, 引导图地址
    NSString *imgUrlString = @"http://172.16.1.72:8080/iOS-Desktop/image/guide.png";
   
    // 3.读取本地网页html
    NSString *htmlContent = [self readLocalHtmlContent:@"index.html"];
    htmlContent = [self replaceKeywordFromHtmlContent:htmlContent iconString:iconString imgUrlString:imgUrlString];
    NSString *urlString = @"http://172.16.1.72:8080/iOS-Desktop/index.jsp?dataurl=";
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", urlString, htmlContent]];
    
     // 4.打开
    [self openUrl:url];
}


#pragma mark - Helper
- (void)openUrl:(NSURL *)url {
    if (!url) { return; }
   
    if (@available(iOS 10.0, *))
    {
        [[UIApplication sharedApplication] openURL:url
                                           options:@{}
                                 completionHandler:nil];
    }
    else
    {
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (NSString *)base64StringFromPNGImageName:(NSString *)imgName {
    UIImage *image = [UIImage imageNamed:imgName];
    NSData *imgData = UIImagePNGRepresentation(image);
    return [imgData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
}


- (NSString *)readLocalHtmlContent:(NSString *)fileName {
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    NSString *htmlContent = [NSString stringWithContentsOfURL:[[NSURL alloc] initFileURLWithPath:htmlPath] encoding:NSUTF8StringEncoding error:nil];
    return htmlContent;
}


- (NSString *)replaceKeywordFromHtmlContent:(NSString *)htmlContent iconString:(NSString *)iconString imgUrlString:(NSString *)imgUrlString {
    htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"IconImageString" withString:iconString];
    htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"Title" withString:self.model.title];
    NSString *operationString = [NSString stringWithFormat:@"CWDesktop://desktopIconClick/open/jump?iconCode=%ld&title=%@", self.model.code, self.model.title];
    htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"Operation" withString:operationString];
    htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"ImageString" withString:imgUrlString];
    htmlContent = [NSString stringWithFormat:@"data:text/html;charset=utf-8,%@", htmlContent];
    htmlContent = [htmlContent stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return htmlContent;
}
@end
