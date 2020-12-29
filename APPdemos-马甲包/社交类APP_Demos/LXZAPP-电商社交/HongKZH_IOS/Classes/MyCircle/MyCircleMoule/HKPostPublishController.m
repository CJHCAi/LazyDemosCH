//
//  HKPostPublishController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/23.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKPostPublishController.h"
#import "VPImageCropperViewController.h"
#import "HK_NetWork.h"
#import "UrlConst.h"
#import "HKDateTool.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIWebView+GUIFixes.h"
@interface HKPostPublishController ()<UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIWebViewDelegate>
@property (nonatomic, strong)UITextField *textField;
@property (nonatomic,strong)UIWebView *webView;
@property (nonatomic, strong)UIImageView *pickerView;
@property (nonatomic,copy)NSString *inHtmlString;
@end
@implementation HKPostPublishController

-(void)initNav {
    self.title =[NSString stringWithFormat:@"发布到%@",self.respone.data.name];
    //观看历史..
    UIButton * moreBtn  =[UIButton buttonWithType:UIButtonTypeCustom];
    
    if (iPhone5) {
        moreBtn.frame =CGRectMake(0,0,30,30);
    }else {
        moreBtn.frame = CGRectMake(0,0,40,40);
    }
    [moreBtn setTitle:@"发布" forState:UIControlStateNormal];
    moreBtn.titleLabel.font =PingFangSCRegular15;
    [moreBtn setTitleColor:[UIColor colorFromHexString:@"4090f7"] forState:UIControlStateNormal];
    UIBarButtonItem * itemMore =[[UIBarButtonItem alloc] initWithCustomView:moreBtn];
    [moreBtn addTarget:self action:@selector(lookhistory) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = itemMore;

}
#pragma mark 发布..
-(void)lookhistory {
    if (!self.textField.text.length) {
        [EasyShowTextView showText:@"请输入帖子标题"];
        return;
    }
        NSString *html = [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('content').innerHTML"];
    if (!html.length) {
        [EasyShowTextView showText:@"请输入帖子内容"];
        return;
    }
     [Toast loading];
    [HKMyCircleViewModel publishPostWithCicleId:self.circleId postTitle:self.textField.text withContent:html success:^(HKBaseResponeModel *responde) {
        [Toast loaded];
        if (responde.responeSuc) {
            [self successAction];
        }else {
            [EasyShowTextView showText:@"发布失败"];
        }
    }];
}
-(void)successAction {
    if (self.delegete && [self.delegete respondsToSelector:@selector(getNewPost)]) {
        [self.delegete getNewPost];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(UITextField *)textField {
    if (!_textField) {
        _textField =[[UITextField alloc] initWithFrame:CGRectMake(15,20,kScreenWidth-30,30)];
        _textField.textColor =[UIColor colorFromHexString:@"333333"];
        _textField.font =PingFangSCRegular17;
        _textField.clearButtonMode =UITextFieldViewModeWhileEditing;
        [_textField setValue:[UIColor colorFromHexString:@"999999"] forKeyPath:@"_placeholderLabel.textColor"];
        [_textField setValue:PingFangSCRegular17 forKeyPath:@"_placeholderLabel.font"];
        _textField.returnKeyType =UIReturnKeyDone;
        _textField.placeholder =@"加个标题哦";
    }
    return _textField;
}
-(void)tapTCLick {
    UIActionSheet *imageSheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍摄照片",@"从相册选择", nil];
    imageSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [imageSheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self openCamera:UIImagePickerControllerSourceTypeCamera];
    }else if (buttonIndex == 1) {
        [self openCamera:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    else if (buttonIndex == 2)
    {
    }
}
- (void)openCamera:(UIImagePickerControllerSourceType)sourceType{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate  = self;
    picker.sourceType = sourceType;
    [self showPickViewController:picker];
}
-(void)showPickViewController:(UIImagePickerController *)viewController;
{
    [self presentViewController:viewController animated:YES completion:nil];
}
#pragma mark Camera View Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self api_uploadImage:portraitImg imageURL:[NSString stringWithFormat:@"image-%@.jpeg",[self stringFromDate:[NSDate date]]]];
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)dismissController:(UIViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark - Method
-(NSString *)changeString:(NSString *)str
{
    NSMutableArray * marr = [NSMutableArray arrayWithArray:[str componentsSeparatedByString:@"\""]];
    
    for (int i = 0; i < marr.count; i++)
    {
        NSString * subStr = marr[i];
        if ([subStr hasPrefix:@"/var"] || [subStr hasPrefix:@" id="])
        {
            [marr removeObject:subStr];
            i --;
        }
    }
    NSString * newStr = [marr componentsJoinedByString:@"\""];
    return newStr;
    
}
- (void)printHTML
{
//    NSString *title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('title-input').value"];
//    NSString *html = [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('content').innerHTML"];
//    NSString *script = [self.webView stringByEvaluatingJavaScriptFromString:@"window.alertHtml()"];
//    [self.webView stringByEvaluatingJavaScriptFromString:script];
//    DLog(@"Inner HTML: %@", html);
//
//    if (html.length == 0)
//    {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入内容" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好", nil];
//        [alert show];
//    }
//    else
//    {
//       self.inHtmlString = html;
//
//    }
}
- (NSString *)stringFromDate:(NSDate *)date
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
    return timeString;
}
- (void)api_uploadImage:(UIImage *)image imageURL:(NSString *)imageURL
{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setObject:HKUSERLOGINID forKey:@"loginUid"];
    NSString *imageNameAndSuff = [imageURL componentsSeparatedByString:@"/"].lastObject;
    NSString *imageName = [imageNameAndSuff componentsSeparatedByString:@"."].firstObject;
    [SVProgressHUD showWithStatus:@"正在上传图片..."];
    [HJNetwork uploadImageURL:[Host stringByAppendingString:get_FriendsavePostPhoto] parameters:dic images:@[image] name:@"imgSrc" fileName:imageName mimeType:@"jpeg" progress:^(NSProgress *progress) {
        
    } callback:^(id responseObject, NSError *error) {
        if (!error) {
            [SVProgressHUD showSuccessWithStatus:@"图片上传成功"];
            NSString *imageURL = responseObject[@"data"];
            //添加到富文本中去
            NSString * script = [NSString stringWithFormat:@"window.insertImage('%@', '%@')", imageURL, imageURL];
           [self.webView stringByEvaluatingJavaScriptFromString:script];
        }
    }];
}
#pragma mark - webview delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (self.inHtmlString.length > 0)
    {
        NSString *place = [NSString stringWithFormat:@"window.placeHTMLToEditor('%@')",self.inHtmlString];
        [webView stringByEvaluatingJavaScriptFromString:place];
    }
}
-(UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.textField.frame),CGRectGetMaxY(self.textField.frame)+10,kScreenWidth-30,300)];
        _webView.delegate = self;
        _webView.scrollView.backgroundColor = [UIColor clearColor];
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.scrollView.bounces = NO;
        //html
        NSBundle *bundle = [NSBundle mainBundle];
        NSURL *indexFileURL = [bundle URLForResource:@"richTextEditor" withExtension:@"html"];
        [_webView loadRequest:[NSURLRequest requestWithURL:indexFileURL]];
    }
    return _webView;
}
-(UIImageView *)pickerView {
    if (!_pickerView) {
        _pickerView =[[UIImageView alloc] initWithFrame:CGRectMake(0,kScreenHeight-30-SafeAreaBottomHeight-NavBarHeight-StatusBarHeight,30,30)];
        _pickerView.image =[UIImage imageNamed:@"tupian1a"];
        _pickerView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTCLick)];
        [_pickerView addGestureRecognizer:tap];
    }
    return _pickerView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    [self initNav];
    self.inHtmlString =@"来吧,尽情发挥吧";
    [self.view addSubview:self.textField];
    [self.view addSubview:self.webView];
    [self.view addSubview:self.pickerView];

}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
