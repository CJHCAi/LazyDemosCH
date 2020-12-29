//
//  HK_LeSeeAddProductDetailDescVC.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/7/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_LeSeeAddProductDescVC.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIWebView+GUIFixes.h"
#import "HKToolBarOverKeyboard.h"
#import "HJNetwork.h"
#import "UrlConst.h"
@interface HK_LeSeeAddProductDescVC ()<UINavigationControllerDelegate,UIActionSheetDelegate>

@property (nonatomic,strong)UIWebView *webView;
@property (nonatomic, strong)UIView *downToolView;
@property (nonatomic, strong) HKToolBarOverKeyboard *toolBarOverKeyboard;
@end

@implementation HK_LeSeeAddProductDescVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"商品图文描述";
    
    [self setupUI];
    self.showCustomerLeftItem = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)rightBarButtonItemClick{
    //保存
    //获取html
    [self printHTML];
    
    [SVProgressHUD showSuccessWithStatus:@"商品详情已保存"];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    //设置不透明导航栏
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    [self.navigationController.navigationBar setShadowImage:nil];
}




#pragma mark - Setup UI
- (void)setupUI
{
    //web view
     [self setrightBarButtonItemWithTitle:@"保存"];
    [self.view addSubview:self.webView];
   
    [self.view addSubview:self.downToolView];
    [self.downToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(45);
    }];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.toolBarOverKeyboard);
    }];
    [self.toolBarOverKeyboard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.downToolView);
    }];
    
}

#pragma mark - actions

- (void)keyboardWillShow:(NSNotification *)noti
{
    NSDictionary *userInfo = noti.userInfo;
    
   
    
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat transY = - keyboardF.size.height;
    
    NSTimeInterval timeInterval = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];//动画持续时间
    UIViewAnimationCurve curve = [noti.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];//动画曲线类型
    [self.downToolView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(transY);
    }];
    [UIView setAnimationCurve:curve];
    [UIView animateWithDuration:timeInterval animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)noti{
    NSTimeInterval timeInterval = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];//动画持续时间
    UIViewAnimationCurve curve = [noti.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];//动画曲线类型
    [UIView setAnimationCurve:curve];
    [self.downToolView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
    }];
    [UIView animateWithDuration:timeInterval animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillChangeFrame:(NSNotification *)noti
{

}

#pragma mark - Api

- (void)api_uploadImage:(UIImage *)image imageURL:(NSString *)imageURL
{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setObject:HKUSERLOGINID forKey:@"loginUid"];
//    [dic setObject:image forKey:@"image"];
//    [dic setObject:imageURL forKey:@"imageURL"];
    
//    NSString *imageURL = body[@"imageURL"];
    
    NSString *imageNameAndSuff = [imageURL componentsSeparatedByString:@"/"].lastObject;
    NSString *imageName = [imageNameAndSuff componentsSeparatedByString:@"."].firstObject;
    
    
     [SVProgressHUD showWithStatus:@"正在上传图片..."];
    [HJNetwork uploadImageURL:[Host stringByAppendingString:get_saveProductDetailImg] parameters:dic images:@[image] name:@"imgSrc" fileName:imageName mimeType:@"jpeg" progress:^(NSProgress *progress) {
        
    } callback:^(id responseObject, NSError *error) {
        if (!error) {
            [SVProgressHUD showSuccessWithStatus:@"图片上传成功"];
            NSString *imageURL = responseObject[@"data"];
                             
                             //添加到富文本中去
            NSString *script = [NSString stringWithFormat:@"window.insertImage('%@', '%@')", imageURL, imageURL];;
            [self.webView stringByEvaluatingJavaScriptFromString:script];;
                         }
        }];
    
    
   
}

#pragma mark - Private

#pragma mark - webview delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (self.inHtmlString.length > 0)
    {
        NSString *place = [NSString stringWithFormat:@"window.placeHTMLToEditor('%@')",self.inHtmlString];
        [webView stringByEvaluatingJavaScriptFromString:place];
    }
}

#pragma mark -消息框代理实现-
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSUInteger sourceType = 0;
    // 判断系统是否支持相机
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self; //设置代理
//    imagePickerController.allowsEditing = YES;
    if (buttonIndex == 2) {
        return;
    }
    if (buttonIndex == 0) {
        //拍照
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else  {
        //相册
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark -实现图片选择器代理-（上传图片的网络请求也是在这个方法里面进行，这里我不再介绍具体怎么上传图片）
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage]; //通过key值获取到图片
    
    //上传图片到服务器--在这里进行图片上传的网络请求，这里不再介绍
    if (@available(iOS 11.0, *)) {
        @try{
            [self api_uploadImage:image imageURL:[info[UIImagePickerControllerImageURL] absoluteString]];
        }
        @catch(NSException *exception){
            [self api_uploadImage:image imageURL:[NSString stringWithFormat:@"image-%@.jpeg",[self stringFromDate:[NSDate date]]]];
        }
        @finally {
            
            
        }
    } else {
       //  Fallback on earlier versions
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        //1.选择的是图片资源
        if ([mediaType isEqualToString:@"public.image"]) {
            if (image !=nil) {
                //获取图片的名字
                __block NSString* imageFileName;
                NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
                DLog(@"imgurl:%@",imageURL);

                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                {
                    ALAssetRepresentation *representation = [myasset defaultRepresentation];
                    imageFileName = [representation filename];
                };

                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                [assetslibrary assetForURL:imageURL
                               resultBlock:resultblock
                              failureBlock:nil];
                @try{
                    [self api_uploadImage:image imageURL:[imageURL absoluteString]];
                }
                @catch(NSException *exception){
                    [self api_uploadImage:image imageURL:[NSString stringWithFormat:@"image-%@.jpeg",[self stringFromDate:[NSDate date]]]];
                }
                @finally {
                    
                    
                }
            }
        }
        
    }
}

- (NSString *)stringFromDate:(NSDate *)date
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
    return timeString;
}

//当用户取消选择的时候，调用该方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

- (void)printHTML
{
    NSString *title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('title-input').value"];
    NSString *html = [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('content').innerHTML"];
    NSString *script = [self.webView stringByEvaluatingJavaScriptFromString:@"window.alertHtml()"];
    [self.webView stringByEvaluatingJavaScriptFromString:script];
    DLog(@"Inner HTML: %@", html);
    
    if (html.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入内容" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好", nil];
        [alert show];
    }
    else
    {
        self.inHtmlString = html;
        //对输出的富文本进行处理后上传
        DLog(@"%@",[self changeString:self.inHtmlString]);
        
        if (self.saveCallback) {
            self.saveCallback(self.inHtmlString);
        }
    }
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
-(UIView *)downToolView{
    if (!_downToolView) {
        _downToolView = [[UIView alloc]init];
        [_downToolView addSubview:self.toolBarOverKeyboard];
    }
    return _downToolView;
}
-(HKToolBarOverKeyboard *)toolBarOverKeyboard{
    if (!_toolBarOverKeyboard) {
        _toolBarOverKeyboard = [HKToolBarOverKeyboard initWithFrame:CGRectZero itemImageNames:@[@"fontb1",@"tupian1a",@"downe"] inView:nil];
        _toolBarOverKeyboard.clickItemCallback = ^(NSInteger index) {
            switch (index) {
                case 0:
                {
                    //字体
                    
                }
                    break;
                case 1:
                {
                    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
                    
                    //自定义消息框
                    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消 " destructiveButtonTitle:nil otherButtonTitles:@"拍照:",@"从相册选择", nil];
                    //显示消息框
                    [sheet showInView:self.view];
                }
                    break;
                case 2:
                {
                    //收起键盘
                    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
                }
                    break;
                default:
                    break;
            }
        };
    }
    return _toolBarOverKeyboard;
}
-(UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc]init];
        _webView.delegate = self;
        _webView.scrollView.backgroundColor = [UIColor clearColor];
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.scrollView.bounces = NO;
        //html
        NSBundle *bundle = [NSBundle mainBundle];
        NSURL *indexFileURL = [bundle URLForResource:@"richTextEditor" withExtension:@"html"];
        //    [self.webView setKeyboardDisplayRequiresUserAction:NO];
        [_webView loadRequest:[NSURLRequest requestWithURL:indexFileURL]];
    }
    return _webView;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
