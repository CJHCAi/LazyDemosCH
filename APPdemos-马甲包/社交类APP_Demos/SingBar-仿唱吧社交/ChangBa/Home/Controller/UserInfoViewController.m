//
//  UserInfoViewController.m
//  新闻练习
//
//  Created by tarena on 16/8/22.
//  Copyright © 2016年 tarena. All rights reserved.
//
#import <UIImageView+AFNetworking.h>
#import "UserInfoViewController.h"
#import <MBProgressHUD.h>

@interface UserInfoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headIV;
@property (weak, nonatomic) IBOutlet UITextField *nickTF;
@property (nonatomic, strong)NSData *imageData;
@end

@implementation UserInfoViewController
#pragma mark - 方法 Methods

- (IBAction)clicked:(UIButton *)sender {
    if (sender.tag==0) {//选择图片
        UIImagePickerController *vc = [UIImagePickerController new];
        vc.delegate = self;
        [self presentViewController:vc animated:YES completion:nil];
    }else{//保存
        BmobUser *user = [BmobUser currentUser];
        [user setObject:self.nickTF.text forKey:@"nick"];
        if (self.imageData) {
            //上传图片 得到图片地址
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [hud setMode:MBProgressHUDModeDeterminateHorizontalBar];
            hud.label.text = @"开始上传。。。";

            [BmobFile filesUploadBatchWithDataArray:@[@{@"filename":@"abc.jpg",@"data":self.imageData}] progressBlock:^(int index, float progress) {
                hud.progress = progress;
                hud.label.text = @(progress).stringValue;
                NSLog(@"进度：%d-%f",index,progress);
            } resultBlock:^(NSArray *array, BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    //得到上传完成的图片地址
                    BmobFile *file = [array firstObject];
                    NSString *headPath = file.url;
                    //把图片地址作为用户的头像 保存
                    [user setObject:headPath forKey:@"headPath"];
                    [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                        if (isSuccessful) {
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    }];
                }
            }];
        }else{//没有头像
            //更新用户信息
            [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        }
    }
}
#pragma mark - 生命周期 Life Cilcle
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    BmobUser *user = [BmobUser currentUser];
    self.nickTF.text = [user objectForKey:@"nick"];
    [self.headIV setImageWithURL:[NSURL URLWithString:[user objectForKey:@"headPath"]]];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.title = @"设置头像和称昵";
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSString *imageURLPath = [[info objectForKey:UIImagePickerControllerReferenceURL] description];
    if ([imageURLPath hasSuffix:@"PNG"]) {
        self.imageData = UIImagePNGRepresentation(image);
    }else{//jpg
        //后面的数字代表压缩率 0-1为不压缩
        self.imageData = UIImageJPEGRepresentation(image, .1);
    }
    self.headIV.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
