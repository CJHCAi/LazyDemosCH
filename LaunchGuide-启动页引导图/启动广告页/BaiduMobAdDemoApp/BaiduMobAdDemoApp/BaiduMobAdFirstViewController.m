//
//  BaiduMobAdFirstViewController.m
//  APIExampleApp
//
//  Created by jaygao on 11-10-26.
//  Copyright (c) 2011年 Baidu,Inc. All rights reserved.
//

#import "BaiduMobAdFirstViewController.h"
#import "BaiduMobAdSDK/BaiduMobAdView.h"
#import "BaiduMobAdSDK/BaiduMobAdSetting.h"

#define kScreenWidth self.view.frame.size.width
#define kScreenHeight self.view.frame.size.height
@implementation BaiduMobAdFirstViewController

-(void) dealloc
{
    [sharedAdView removeFromSuperview];
    sharedAdView.delegate = nil;
    [sharedAdView release];
    sharedAdView = nil;
    [super dealloc];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"横幅悬浮样式";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addText];
    [self addAdView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [sharedAdView removeFromSuperview];
    sharedAdView.delegate = nil;
    [sharedAdView release];
    sharedAdView = nil;
    //注意一定要设置为nil
}

- (void)addText {
    UITextView *textView = [[UITextView alloc]init];
    CGFloat textH = kScreenHeight-64;
    textView.frame = CGRectMake(0, 0, kScreenWidth, textH);
    textView.font = [UIFont systemFontOfSize:16];
    textView.editable = NO;
    [self.view addSubview:textView];
    textView.text = @"丰富的广告样式说明\n\n1. 横幅：常见的移动广告样式，以通栏式或矩形式出现在应用中\n使用场景：用户停留较久或者访问频繁的页面\n优势：适用媒体范围广，接入成本低，自然展现于媒体页面中，用户认可度高\n\n2. 开屏：应用开启后全屏展现的广告样式（支持底部展示媒体LOGO）\n使用场景：应用启动时\n优势：视觉效果震撼，提升媒体品牌价值渗透，广告点击率高，变现能力出色\n\n3. 插屏：基于用户使用场景切换，插入半屏或全屏的广告形式\n使用场景：应用内视图切换、游戏过关或失败、图书翻页、应用退出等\n优势：交互场景丰富，减少对应用界面的占用，深受广告主青睐，预算能力充足\n\n4. 信息流：移动广告新锐，作为媒体内容的一部分与应用内容高度融合的广告样式\n使用场景：列表页、焦点图、动态更新页、内容页等\n优势：广告内容融入媒体环境，深受大牌媒体青睐，提升变现能力成就优秀用户体验\n\n5. 视频贴片：在视频播放中暂停或场景切换时，展示的贴片广告\n使用场景：视频播放前、中、后或者暂停场景\n优势：丰富视觉体验，无缝交互展示";
}

- (void)addAdView {
    //lp颜色配置
    [BaiduMobAdSetting setLpStyle:BaiduMobAdLpStyleDefault];
#warning ATS默认开启状态, 可根据需要关闭App Transport Security Settings，设置关闭BaiduMobAdSetting的supportHttps，以请求http广告，多个产品只需要设置一次.    [BaiduMobAdSetting sharedInstance].supportHttps = NO;

    //使用嵌入广告的方法实例。
    sharedAdView = [[BaiduMobAdView alloc] init];
    sharedAdView.AdUnitTag = @"2015347";
    sharedAdView.AdType = BaiduMobAdViewTypeBanner;
    CGFloat bannerY = kScreenHeight - 0.15*kScreenWidth;
    sharedAdView.frame = CGRectMake(0, bannerY, kScreenWidth, 0.15*kScreenWidth);
    [self.view addSubview:sharedAdView];
    
    sharedAdView.delegate = self;
    [sharedAdView start];
}

- (NSString *)publisherId
{
    return  @"ccb60059"; //@"your_own_app_id";注意，iOS和android的app请使用不同的app ID
}

-(BOOL) enableLocation
{
    //启用location会有一次alert提示
    return YES;
}


-(void) willDisplayAd:(BaiduMobAdView*) adview
{
    NSLog(@"delegate: will display ad");
}

-(void) failedDisplayAd:(BaiduMobFailReason) reason;
{
    NSLog(@"delegate: failedDisplayAd %d", reason);
}

- (void)didAdImpressed {
    NSLog(@"delegate: didAdImpressed");

}

- (void)didAdClicked {
    NSLog(@"delegate: didAdClicked");
}

- (void)didAdClose {
    NSLog(@"delegate: didAdClose");
}
//人群属性接口
/**
 *  - 关键词数组
 */
-(NSArray*) keywords{
    NSArray* keywords = [NSArray arrayWithObjects:@"测试",@"关键词", nil];
    return keywords;
}

/**
 *  - 用户性别
 */
-(BaiduMobAdUserGender) userGender{
    return BaiduMobAdMale; 
}

/**
 *  - 用户生日
 */
-(NSDate*) userBirthday{
    NSDate* birthday = [NSDate dateWithTimeIntervalSince1970:0];
    return birthday;
}

/**
 *  - 用户城市
 */
-(NSString*) userCity{
    return @"上海";
}


/**
 *  - 用户邮编
 */
-(NSString*) userPostalCode{
    return @"435200";
}


/**
 *  - 用户职业
 */
-(NSString*) userWork{
    return @"程序员";
}

/**
 *  - 用户最高教育学历
 *  - 学历输入数字，范围为0-6
 *  - 0表示小学，1表示初中，2表示中专/高中，3表示专科
 *  - 4表示本科，5表示硕士，6表示博士
 */
-(NSInteger) userEducation{
    return  5;
}

/**
 *  - 用户收入
 *  - 收入输入数字,以元为单位
 */
-(NSInteger) userSalary{
    return 10000;
}

/**
 *  - 用户爱好
 */
-(NSArray*) userHobbies{
    NSArray* hobbies = [NSArray arrayWithObjects:@"测试",@"爱好", nil];
    return hobbies;
}

/**
 *  - 其他自定义字段
 */
-(NSDictionary*) userOtherAttributes{
    NSMutableDictionary* other = [[[NSMutableDictionary alloc] init] autorelease];
    [other setValue:@"测试" forKey:@"测试"];
    return other;
}


@end
