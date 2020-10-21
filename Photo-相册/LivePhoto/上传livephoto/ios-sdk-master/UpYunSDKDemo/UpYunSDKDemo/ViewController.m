//
//  ViewController.m
//  upyundemo
//
//  Created by andy yao on 12-6-14.
//  Copyright (c) 2012年 upyun.com. All rights reserved.
//

#import "ViewController.h"
#import "UpYun.h"
#import "UPLivePhotoViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIProgressView *pv;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (IBAction)uploadFile:(id)sender {
    [UPYUNConfig sharedInstance].DEFAULT_BUCKET = @"test654123";
    [UPYUNConfig sharedInstance].DEFAULT_PASSCODE = @"0/8/1gPFWUQWGcfjFn6Vsn3VWDc=";
    __block UpYun *uy = [[UpYun alloc] init];
    uy.successBlocker = ^(NSURLResponse *response, id responseData) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"上传成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        NSLog(@"response body %@", responseData);
    };
    uy.failBlocker = ^(NSError * error) {
        NSString *message = [error.userInfo objectForKey:@"message"];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"message" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        NSLog(@"error %@", message);
    };
    uy.progressBlocker = ^(CGFloat percent, int64_t requestDidSendBytes) {
        [_pv setProgress:percent];
    };

    
//    uy.uploadMethod = UPMutUPload; 分块
//    如果 policy 由服务端生成, 只需要 return policy
//    uy.policyBlocker = ^()
//    {
//        return @"";
//    };
//    如果 sinature 由服务端生成, 服务端只需要将 policy 和 密钥 拼接之后进行 MD5, 否则就不用初始化signatureBlocker
//    uy.signatureBlocker = ^(NSString *policy)
//    {
//        return @"";
//    };

    
    
    /**
     *	@brief	根据 UIImage 上传
     */
//    UIImage * image = [UIImage imageNamed:@"test2.png"];
//    [uy uploadFile:image saveKey:[self getSaveKeyWith:@"jpg"]];

//    [uy uploadFile:image saveKey:@"2016.jpg"];
//    [uy uploadImage:image savekey:[self getSaveKeyWith:@"png"]];
    /**
     *	@brief	根据 文件路径 上传
     */
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *filePath = [resourcePath stringByAppendingPathComponent:@"image.jpg"];
    [uy uploadFile:filePath saveKey:@"/test2.png"];
    /**
     *	@brief	根据 NSDate  上传
     */
//    NSData * fileData = [NSData dataWithContentsOfFile:filePath];
//    [uy uploadFile:fileData saveKey:[self getSaveKeyWith:@"png"]];
}

- (NSString * )getSaveKeyWith:(NSString *)suffix {
    /**
     *	@brief	方式1 由开发者生成saveKey
     */
    return [NSString stringWithFormat:@"/%@.%@", [self getDateString], suffix];
    /**
     *	@brief	方式2 由服务器生成saveKey
     */
//    return [NSString stringWithFormat:@"/{year}/{mon}/{filename}{.suffix}"];
    /**
     *	@brief	更多方式 参阅 http://docs.upyun.com/api/form_api/#_4
     */
}

- (NSString *)getDateString {
    NSDate *curDate = [NSDate date];//获取当前日期
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy/MM/dd"];//这里去掉 具体时间 保留日期
    NSString * curTime = [formater stringFromDate:curDate];
    curTime = [NSString stringWithFormat:@"%@/%.0f", curTime, [curDate timeIntervalSince1970]];
    return curTime;
}

// 生成随机文件
+ (NSString *)createTempFileWithSize:(NSUInteger)size {
    NSString *fileName = [NSString stringWithFormat:@"/test%08X.txt", arc4random()];
    NSURL *fileUrl = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:fileName]];
    NSData *data = [NSMutableData dataWithLength:size];
    NSError *error = nil;
    
    [data writeToURL:fileUrl options:NSDataWritingAtomic error:&error];
    
    return fileUrl.path;
}

+ (void)removeTempfile:(NSString *)filePath {
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
}
- (IBAction)livePhotoAction:(UIButton *)sender {
    UPLivePhotoViewController *vc = [[UPLivePhotoViewController alloc]init];
    
    [self presentViewController:vc animated:YES completion:nil];
    
}

@end