//
//  EditHeadView.m
//  FamilyTree
//
//  Created by 姚珉 on 16/6/13.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "EditHeadView.h"
#import "HeadImageView.h"
#import "UIView+getCurrentViewController.h"

@interface EditHeadView()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
/** 中间背景框*/
@property (nonatomic, strong) UIImageView *bgIV;
/** 头像预览*/
@property (nonatomic, strong) HeadImageView *headIV;
/** 头像数组*/
@property (nonatomic, strong) NSMutableArray<NSString *> *headStrArr;
@end


@implementation EditHeadView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        //设置背景图
        self.bgIV = [[UIImageView alloc]initWithFrame:CGRectMake(0.04375*CGRectW(self), 0.2989*CGRectH(self), 0.9125*CGRectW(self), 0.5692*CGRectH(self))];
        self.bgIV.image = MImage(@"xiuGaitouxiang_bg");
        self.bgIV.userInteractionEnabled = YES;
        [self addSubview:self.bgIV];
        //返回按钮
        UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.90*CGRectW(self), 0.275*CGRectH(self), 0.1*CGRectW(self), 0.1*CGRectW(self))];
        [backBtn setImage:MImage(@"close") forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(clickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backBtn];
        
        //头像预览
        [self initHeadIV];
        
        //选择头像
        self.headStrArr = [NSMutableArray array];
        for (int i = 0; i < 12; i++) {
            [self.headStrArr addObject:[NSString stringWithFormat:@"tx_%d",i+1]];
        }
        [self initChooseHead];
        
        //自定义与相框选择按钮
        [self initCustomAndChooseBorderBtn];
        
        //vip解锁进度
        [self initVipUnlockProgressView];

    }
    return self;
}

-(void)initHeadIV{
    self.headIV = [[HeadImageView alloc]initWithFrame:CGRectMake(0.0616*CGRectW(self.bgIV), 0.0772*CGRectH(self.bgIV), 0.2397*CGRectW(self.bgIV), 0.2703*CGRectH(self.bgIV))];
    //加载首先访问本地沙盒是否存在相关图片
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"headImage"];
    UIImage *headImage = [UIImage imageWithContentsOfFile:fullPath];
    if (!headImage)
    {
        //默认头像
        self.headIV.headInsideIV.image = MImage(@"xiuGaitouxiang_sel1");
    }
    else
    {
        self.headIV.headInsideIV.image = headImage;
    }

    [self.bgIV addSubview:self.headIV];
}

-(void)initChooseHead{
    for (int i = 0; i < 12; i++) {
        UIButton *headBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.3630*CGRectW(self.bgIV)+0.1473*CGRectW(self.bgIV)*(i-4*[@[@0,@1,@2][i/4] intValue]), 0.0927*CGRectH(self.bgIV)+0.1506*CGRectH(self.bgIV)*[@[@0,@1,@2][i/4] intValue], 0.1164*CGRectW(self.bgIV), 0.1158*CGRectH(self.bgIV))];
        [headBtn setBackgroundImage:MImage(self.headStrArr[i]) forState:UIControlStateNormal];
        headBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        headBtn.tag = 555+i;
        [headBtn addTarget:self action:@selector(chooseHeadBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgIV addSubview:headBtn];
    }
    
    
}

-(void)initCustomAndChooseBorderBtn{
    UIButton *customBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.0890*CGRectW(self.bgIV), 0.3840*CGRectH(self.bgIV), 0.1713*CGRectW(self.bgIV), 0.0772*CGRectH(self.bgIV))];
    [customBtn setTitle:@"自定义" forState:UIControlStateNormal];
    [customBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    customBtn.titleLabel.font = MFont(11);
    customBtn.backgroundColor = LH_RGBCOLOR(219, 222, 220);
    customBtn.layer.cornerRadius = 3.0;
    [customBtn addTarget:self action:@selector(clickCustomBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgIV addSubview:customBtn];
    
    UIButton *ChooseBorderBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectX(customBtn), 0.4981*CGRectH(self.bgIV), CGRectW(customBtn), CGRectH(customBtn))];
    [ChooseBorderBtn setTitle:@"相框选择" forState:UIControlStateNormal];
    [ChooseBorderBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    ChooseBorderBtn.titleLabel.font = MFont(11);
    ChooseBorderBtn.backgroundColor = LH_RGBCOLOR(219, 222, 220);
    ChooseBorderBtn.layer.cornerRadius = 3.0;
    [ChooseBorderBtn addTarget:self action:@selector(clickChooseBorderBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgIV addSubview:ChooseBorderBtn];
}

-(void)initVipUnlockProgressView{
    //图
    UIImageView *unlockIV = [[UIImageView alloc]initWithFrame:CGRectMake(0.0822*CGRectW(self.bgIV), 0.6178*CGRectH(self.bgIV), 0.8288*CGRectW(self.bgIV), 0.1506*CGRectH(self.bgIV))];
    unlockIV.image = MImage(@"xiuGaitouxiang_ji");
    [self.bgIV addSubview:unlockIV];
    //文字描述
    NSArray *detailArr = @[@"普通用户",@"VIP1-5",@"VIP6-8",@"每月之星"];
    NSArray *unlockStateArr = @[@NO,@NO,@NO,@NO];
    for (int i = 0; i < 4; i++) {
        //因为间距不一样，加代码做调整
        UILabel *detailLB = [[UILabel alloc]init];
        if (i < 2) {
            detailLB.frame = CGRectMake(0.1062*CGRectW(self.bgIV)+0.2192*CGRectW(self.bgIV)*i, 0.7992*CGRectH(self.bgIV), 0.1541*CGRectW(self.bgIV), 0.0656*CGRectH(self.bgIV));
        }else{
            detailLB.frame = CGRectMake(0.1062*CGRectW(self.bgIV)+0.2102*CGRectW(self.bgIV)*i, 0.7992*CGRectH(self.bgIV), 0.1541*CGRectW(self.bgIV), 0.0656*CGRectH(self.bgIV));
        }
        detailLB.text = detailArr[i];
        detailLB.font = MFont(11);
        detailLB.textAlignment = NSTextAlignmentCenter;
        [self.bgIV addSubview:detailLB];
        CGRect frame = detailLB.frame;
        frame.origin.y = frame.origin.y + frame.size.height;
        UILabel *unlockStateLB = [[UILabel alloc]initWithFrame:frame];
        unlockStateLB.text = unlockStateArr[i]?@"已解锁":@"未解锁";
        unlockStateLB.font = MFont(11);
        unlockStateLB.textAlignment = NSTextAlignmentCenter;
        [self.bgIV addSubview:unlockStateLB];
    }
}

-(void)clickBackBtn:(UIButton *)sender{
    //保存设置
    [self.delegate editHeadView:self HeadInsideImage:self.headIV.headInsideIV.image];
    if (self.headIV.headInsideIV.image) {
        UIImage *list = self.headIV.headInsideIV.image;
        NSData *imageData = UIImageJPEGRepresentation(list, 0.5);
        NSString *encodeimageStr =[imageData base64EncodedString];
        NSDictionary *params =@{@"userid":GetUserId,@"imgbt":encodeimageStr};
        [TCJPHTTPRequestManager POSTWithParameters:params requestID:GetUserId requestcode:kRequestCodeUploadMemimg success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
            if (succe) {
                MYLog(@"图片上传成功");
                
            }
        } failure:^(NSError *error) {
            
        }];
        //保存图片进入沙盒中
        [self saveImage:self.headIV.headInsideIV.image withName:@"headImage"];
        

    }
    [self removeFromSuperview];
}

-(void)clickCustomBtn:(UIButton *)sender{
    MYLog(@"自定义");
    [self iconImageAction];
}

-(void)clickChooseBorderBtn:(UIButton *)sender{
    MYLog(@"相框选择");
    
}

-(void)chooseHeadBtn:(UIButton *)sender{
    self.headIV.headInsideIV.image = MImage(self.headStrArr[sender.tag-555]);
    //让选中的添加边框
    for (int i = 0 ; i < 12; i++) {
        UIButton *button =(UIButton *)[self viewWithTag:555+i];
        button.selected = NO;
        sender.selected = YES;
        if (button.selected) {
            button.layer.borderColor = LH_RGBCOLOR(110, 96, 90).CGColor;
            button.layer.borderWidth = 1;
            MYLog(@"添加边框");
        }else{
            button.layer.borderColor = [UIColor clearColor].CGColor;
        }
    }

    
    
}

#pragma mark- ===== 更换头像 =====
- (void)iconImageAction {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择" message:@"获取头像" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //打开 图片编辑器 用相机的形式打开
        [self chooseHeadImage:(UIImagePickerControllerSourceTypeCamera)];
    }];
    
    UIAlertAction *photoLibrary = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //打开 图片编辑器 用相册的形式打开
        [self chooseHeadImage:(UIImagePickerControllerSourceTypePhotoLibrary)];
    }];
    
    [alert addAction:cancel];
    [alert addAction:camera];
    [alert addAction:photoLibrary];
    [[self viewController] presentViewController:alert animated:YES completion:nil];
}

-(void)chooseHeadImage:(UIImagePickerControllerSourceType)type {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    //允许编辑图片
    imagePicker.allowsEditing = YES;
    //类型 是 相机  或  相册
    imagePicker.sourceType = type;
    //设置代理
    imagePicker.delegate = self;
    [[self viewController] presentViewController:imagePicker animated:YES completion:nil];
    
}

#pragma mark- =====更换头像 Delegate =====
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //   Original: 原始的
    self.headIV.headInsideIV.image = info[UIImagePickerControllerOriginalImage];
    //获取编辑后的图片
    if (picker.allowsEditing) {
        self.headIV.headInsideIV.image = info[UIImagePickerControllerEditedImage];
    }
    //保存图片进入沙盒中
    [self saveImage:self.headIV.headInsideIV.image withName:@"headImage"];
    //上传服务器
    
    //如果实现了此协议,那么弹出的图片选择控制器不会自动消失
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 保存头像图片进入沙盒
-(void)saveImage:(UIImage *)headImage withName:(NSString *)imageName{
    NSData *imageData = UIImageJPEGRepresentation(headImage, 0.8);
    
    // 获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
}


@end
