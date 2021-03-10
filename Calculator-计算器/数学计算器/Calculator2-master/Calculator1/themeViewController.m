//
//  themeViewController.m
//  Calculator1
//
//  Created by ruru on 16/4/25.
//  Copyright © 2016年 ruru. All rights reserved.
//

#import "themeViewController.h"
#import "setViewController.h"

#define RGB(color)        [UIColor colorWithRed:(color>>16)/255.0 green:((color>>8)&0xff)/255.0 blue:(color&0xff)/255.0 alpha:1]
#define RGBA(color,alpha) [UIColor colorWithRed:(color>>16)/255.0 green:((color>>8)&0xff)/255.0 blue:(color&0xff)/255.0 alpha:alpha]
@interface themeViewController ()

@end

@implementation themeViewController{
    NSString *currentSelcetTheme;
    NSArray *themeArray;
    NSString *isSateDefine;
}

- (void)viewDidLoad {
    isSateDefine=nil;
    [super viewDidLoad];
    NSDictionary *themeDic=[Common configGetTheme:@"key_setting_theme"];

    if (!themeDic[@"theme_name"]) {
        currentSelcetTheme=@"默认";
    }else{
        currentSelcetTheme=themeDic[@"theme_name"];
    }

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    themeArray=[self loadTheme];
    [self loadThemeList];

}

-(NSArray *)loadTheme{
    return @[@{
                 @"theme_name":@"默认",
                 @"theme_icon_image":@"默认",//or @"aaa.jpg" //数组则为颜色；字符串则为图片
                 @"theme_background_color":@[@"0x223048",@"0.9"],
                 @"button_background_color":@[@"0x6D7989",@"0.9"],
                 @"button_Key_color":@[@"0xFA890D",@"0.9"],
                 @"font-color":@[@"0xC9CED5",@"1.0"],
                 @"specialButton_bg_color":@[@"0x4D5C6F",@"0.9"],
                 
                 },
                @{
                 @"theme_name":@"高雅紫",
                 @"theme_icon_image":@"高雅紫",//or @"aaa.jpg" //数组则为颜色；字符串则为图片
                 @"theme_background_color":@[@"0x722896",@"0.9"],
                 @"button_background_color":@[@"0xE8DAEF",@"0.9"],
                 @"button_Key_color":@[@"0xFA890D",@"0.9"],
                 @"font-color":@[@"0x2D3F64",@"1.0"],
                 @"specialButton_bg_color":@[@"0x965CB1",@"0.9"],
                 },
             
             @{
                 @"theme_name":@"橙色",
                 @"theme_icon_image":@"橙色",//or @"aaa.jpg" //数组则为颜色；字符串则为图片
                 @"theme_background_color":@[@"0xBB571D",@"0.9"],
                 @"button_background_color":@[@"0xF96E48",@"1.0"],
                 @"button_Key_color":@[@"0xF84F2B",@"0.9"],
                 @"font-color":@[@"0xFFF2F0",@"1.0"],
                 @"specialButton_bg_color":@[@"0xFBA563",@"0.9"],

                 },
             @{
                 @"theme_name":@"蓝色",
                 @"theme_icon_image":@"蓝色",//or @"aaa.jpg" //数组则为颜色；字符串则为图片
                 @"theme_background_color":@[@"0x2A557D",@"0.9"],
                 @"button_background_color":@[@"0x80AECA",@"0.9"],
                 @"button_Key_color":@[@"0x3D9BD8",@"0.9"],
                 @"font-color":@[@"0xE5EFF5",@"1.0"],
                 @"specialButton_bg_color":@[@"0x6299CC",@"0.9"],
                 },
             @{
                 @"theme_name":@"图片",
                 @"theme_icon_image":@"44",//or @"aaa.jpg" //数组则为颜色；字符串则为图片
                 @"theme_background_color":@"44",
                 @"button_background_color":@[@"0x6D7989",@"0.9"],
                 @"button_Key_color":@[@"0xFA890D",@"0.9"],
                 @"font-color":@[@"0xC9CED5",@"1.0"],
                 @"specialButton_bg_color":@[@"0x4D5C6F",@"0.9"],
                 },
             @{
                 @"theme_name":@"图片1",
                 @"theme_icon_image":@"back_sky_dark",//or @"aaa.jpg" //数组则为颜色；字符串则为图片
                 @"theme_background_color":@"back_sky_dark",
                 @"button_background_color":@[@"0x6D7989",@"0.9"],
                 @"button_Key_color":@[@"0xFA890D",@"0.9"],
                 @"font-color":@[@"0xC9CED5",@"1.0"],
                 @"specialButton_bg_color":@[@"0x4D5C6F",@"0.9"],
                 },
             @{
                 @"theme_name":@"图片2",
                 @"theme_icon_image":@"back_sky_yellow",//or @"aaa.jpg" //数组则为颜色；字符串则为图片
                 @"theme_background_color":@"back_sky_yellow",
                 @"button_background_color":@[@"0x6D7989",@"0.9"],
                 @"button_Key_color":@[@"0xFA890D",@"0.9"],
                 @"font-color":@[@"0xC9CED5",@"1.0"],
                 @"specialButton_bg_color":@[@"0x4D5C6F",@"0.9"],                 },
             @{
                 @"theme_name":@"图片3",
                 @"theme_icon_image":@"back_ocean",//or @"aaa.jpg" //数组则为颜色；字符串则为图片
                 @"theme_background_color":@"back_ocean",
                 @"button_background_color":@[@"0x6D7989",@"0.9"],
                 @"button_Key_color":@[@"0xFA890D",@"0.9"],
                 @"font-color":@[@"0xC9CED5",@"1.0"],
                 @"specialButton_bg_color":@[@"0x4D5C6F",@"0.9"],                 },
             @{
                 @"theme_name":@"图片4",
                 @"theme_icon_image":@"33",//or @"aaa.jpg" //数组则为颜色；字符串则为图片
                 @"theme_background_color":@"33",
                 @"button_background_color":@[@"0x6D7989",@"0.9"],
                 @"button_Key_color":@[@"0xFA890D",@"0.9"],
                 @"font-color":@[@"0xC9CED5",@"1.0"],
                 @"specialButton_bg_color":@[@"0x4D5C6F",@"0.9"],
                 },
             ];
}

-(UIView *)makeThemeCell:(NSDictionary  *)theme{//绘制主题单元格
    UIView *cell=[[[NSBundle mainBundle]loadNibNamed:@"themeCell" owner:self options:nil]lastObject];//@"themeCell"是.xib的名字
    UIButton * button=[cell viewWithTag:1000];
    UILabel *themeTitle=[cell viewWithTag:1001];
    UIImageView *selectTheme=[cell viewWithTag:1002];
    [button setBackgroundImage:[UIImage imageNamed:theme[@"theme_icon_image"]] forState:UIControlStateNormal];
    themeTitle.text=theme[@"theme_name"];
    
    if ([currentSelcetTheme isEqualToString:theme[@"theme_name"]]) {
        selectTheme.hidden=NO;
        [themeTitle setTextColor:RGB(0x000000)];
        themeTitle.alpha=0.7;
    }
    [button addTarget:self action:@selector(themeClick:) forControlEvents:UIControlEventTouchUpInside];//绑定button事件
    return cell;
}

-(void)themeClick:(UIButton *)button{
    
    int index = (int)button.superview.tag - 5000;
    NSDictionary * dict = themeArray[index];
    NSLog(@"%@",dict);
    currentSelcetTheme = dict[@"theme_name"];
    
    for (UIView * view in self.scrollView.subviews) {
        if(view.tag>=5000){
            [view removeFromSuperview];
        }
    }
    [Common configSet:@"key_setting_theme" value:dict];
    isSateDefine=@"0";
    NSLog(@"isSateDefine%@",isSateDefine);
    [Common configSet:@"theme_Define_background" value:isSateDefine];

    [self loadThemeList];
}

-(void)loadThemeList{
    int rowHight=0;
    int rowNum=0;
    for (int i=0; i<themeArray.count; i++) {
        UIView *themeCell=[self makeThemeCell:themeArray[i]];
        int row=self.view.frame.size.width/themeCell.frame.size.width;//每行可以放多少个
        int currentRow=i/row;//当前第几行
        int currentCol=i%row;//当前第几列
        int marginLeft = (self.view.frame.size.width-themeCell.frame.size.width*row)/(row+1);//计算间隙大小
        
        rowNum=row;
        rowHight=themeCell.frame.size.height;
        
        //当前themeCell的位置
        CGRect frame=themeCell.frame;
        frame.origin.x=(themeCell.frame.size.width)*currentCol+marginLeft;
        frame.origin.y=themeCell.frame.size.height*currentRow;
        themeCell.frame=frame;
        themeCell.tag=5000+i;
        [self.scrollView addSubview:themeCell];
    }

    int dockInheight = rowHight * ceil(themeArray.count/rowNum);//scrollView可滚动范围
    UIButton *ThemeDefineBtn=[[UIButton alloc]init];
//    UIButton *ThemeDefineBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    ThemeDefineBtn.frame=CGRectMake(20, dockInheight+20, 50, 50);
    ThemeDefineBtn.backgroundColor=RGB(0xC1C1C1);
    ThemeDefineBtn.layer.cornerRadius=25;
    ThemeDefineBtn.layer.masksToBounds=YES;
    [ThemeDefineBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:10]];
    [ThemeDefineBtn setTitle:@"自定义" forState:UIControlStateNormal];
    [ThemeDefineBtn setTitleColor:RGB(0xffffff) forState:UIControlStateNormal];
    ThemeDefineBtn.alpha=0.6;
    [ThemeDefineBtn addTarget:self action:@selector(ThemeClick:) forControlEvents:UIControlEventTouchUpInside];
    CGSize size=self.scrollView.contentSize;
    size = CGSizeMake(self.scrollView.frame.size.width,dockInheight+100);
    self.scrollView.contentSize=size;
    [self.scrollView addSubview:ThemeDefineBtn];
}

-(void)ThemeClick:(UIButton *)sender{
    if (IOS8) {
        UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"获取图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        //判断是否支持相机（模拟机没有相机）
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIAlertAction *defaultAction=[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                //相机
                UIImagePickerController *imagePickControll=[[UIImagePickerController alloc]init];
                imagePickControll.delegate=self;
                imagePickControll.allowsEditing=YES;
                imagePickControll.sourceType=UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imagePickControll animated:YES completion:^{}];
            }];
            [alertController addAction:defaultAction];
        }
        UIAlertAction *defaultAction1=[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //相册
            UIImagePickerController *imagePickController=[[UIImagePickerController alloc]init];
            imagePickController.delegate=self;
            imagePickController.allowsEditing=YES;
            imagePickController.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePickController animated:YES completion:^{}];
        }];
        UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:defaultAction1];
        //弹出视图 使用UIViewController的方法
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
#pragma mark=====保存图片到沙盒
-(void)saveImage:(UIImage *)currentImage withName:(NSString *)imageName{
    NSData *imageDate=UIImageJPEGRepresentation(currentImage, 1);//1为不缩放保存，取值（0.0-1.0）
    // 获取沙盒目录
    NSString *fullPath=[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    //将图片写入文件
    [imageDate writeToFile:fullPath atomically:NO];
}
#pragma mark=====ios7 ios8都要调用方法，选择完成后调用该方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary*)info{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
    isSateDefine=@"1";
    [Common configSet:@"theme_Define_background" value:isSateDefine];
    NSLog(@"isSateDefine%@",isSateDefine);
    [self saveImage:image withName:@"backgroundImage.png"];
}
#pragma mark=====ios7 ios8都要调用方法，按取消调用该方法
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)gotoBack:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}



@end
