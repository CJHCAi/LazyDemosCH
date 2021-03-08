//
//  WebViewController.m
//  StudyDrive
//
//  Created by apple on 15/8/31.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()
{
    UIWebView * _webView;
}
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(instancetype)initWithUrl:(NSString *)url{
    self = [super init];
    if (self) {
//        NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
       _webView = [[UIWebView alloc]initWithFrame:self.view.frame];
//        [_webView loadRequest:request];
        [_webView loadHTMLString:@"<body>年龄条件 1、申请小型汽车、小型自动挡汽车、残疾人专用小型自动挡载客汽车、轻便摩托车准驾车型的，在18周岁以上、70周岁以下；  2、申请低速载货汽车、三轮汽车、普通三轮摩托车、普通二轮摩托车或者轮式自行机械车准驾车型的，在18周岁以上，60周岁以下  3、申请城市公交车、大型货车、无轨电车或者有轨电车准驾车型的，在20周岁以上，50周岁以下；4、申请中型客车准驾车型的，在21周岁以上，50周岁以下；5、申请牵引车准驾车型的，在24周岁以上，50周岁以下；6、申请大型客车准驾车型的，在26周岁以上，50周岁以下。身体条件 以下条件不得申请机动车驾驶证： 1、有器质性心脏病、癫痫病、美尼尔氏症、眩晕症、癔病、震颤麻痹、精神病、痴呆以及影响肢体活动的神经系统疾病等妨碍安全驾驶疾病的； 2、吸食、注射毒品、长期服用依赖性精神药品成瘾尚未戒除的  3、吊销机动车驾驶证未满二年的；4、造成交通事故后逃逸被吊销机动车驾驶证的；5、驾驶许可依法被撤销未满三年的</body>" baseURL:nil];
        [self.view addSubview:_webView];
    }
    return self;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
