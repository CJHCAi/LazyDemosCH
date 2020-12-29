//
//  YXWWallPaperViewController.m
//  StarAlarm
//
//  Created by dllo on 16/3/30.
//  Copyright © 2016年 YXW. All rights reserved.
//

#import "YXWWallPaperViewController.h"
#import "YXWWPCollectionViewCell.h"
#import "YXWPreViewViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
@interface YXWWallPaperViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

//壁纸collectonView
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;


@property (nonatomic, strong) UIView *wallPaperView;
@property (nonatomic, strong) UILabel *wallLabel;
@property (nonatomic, strong) UIImageView *smallWPImageView;

//壁纸数组
@property (nonatomic, strong) NSMutableArray *wallpaperArray;


@end

@implementation YXWWallPaperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self.navigationController.navigationBar setBackgroundImage:[self imageWithBgColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0]] forBarMetrics:UIBarMetricsDefault];
    //导航左侧按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"smallGB.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(closeAction:)];
    self.view.backgroundColor = [UIColor clearColor];
    self.navigationItem.title = @"壁纸";
    [self creatCollection];
}

//导航透明
-(UIImage *)imageWithBgColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}
#pragma mark - 创建collection
-(void)creatCollection {
    
    
    self.wallpaperArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < 14; i++) {
        
        NSString *wpStr = [NSString stringWithFormat:@"BiZhi%02d",i];
        [self.wallpaperArray addObject:wpStr];
    }
    
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.flowLayout.itemSize = CGSizeMake((self.view.frame.size.width -60)/ 3, (self.view.frame.size.width - 60)/2);
    self.flowLayout.minimumInteritemSpacing = 10;
    self.flowLayout.minimumLineSpacing = 10;
    self.flowLayout.sectionInset = UIEdgeInsetsMake(64, 20, 0, 20);
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height ) collectionViewLayout:self.flowLayout];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    [self.collectionView registerClass:[YXWWPCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    [self.view addSubview:self.collectionView];
    
    
    UIView *customView =[[UIView alloc] initWithFrame:CGRectMake(self.flowLayout.itemSize.width * 2 + 40 ,self.flowLayout.itemSize.height * 4 + 105 , self.flowLayout.itemSize.width, self.flowLayout.itemSize.height)];
    customView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.199919181034483];
    [self.collectionView addSubview:customView];
    
    UIButton * customButton = [UIButton buttonWithType:UIButtonTypeSystem];
    customButton.frame = CGRectMake(self.flowLayout.itemSize.width * 2 + 40 ,self.flowLayout.itemSize.height * 4 +105 , self.flowLayout.itemSize.width, self.flowLayout.itemSize.height);
    
    [customButton setImage:[[UIImage imageNamed:@"add"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateNormal];
    [customButton addTarget:self action:@selector(cuttomButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.collectionView addSubview:customButton];
   
    
}
#pragma mark - 自定义选择壁纸
-(void)cuttomButtonAction:(UIButton *)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self.navigationController presentViewController:picker animated:YES completion:^{
        
    }];
    
}
#pragma mark - UIImagePickerController代理
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(image);
        }
        
        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
        
        //得到选择后沙盒中图片的完整路径
        filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
        
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:^{
            
        }];
        
        
    
    //通知中心
    [[NSNotificationCenter defaultCenter] postNotificationName:@"image" object:filePath];
    //存本地
    [[NSUserDefaults standardUserDefaults] setObject:filePath forKey:@"image"];

    }
    
    }

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    [picker dismissModalViewControllerAnimated:YES];
}
#pragma mark -  item 个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.wallpaperArray.count;
    
}
#pragma mark - collectioncell
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YXWWPCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
     cell.imageName = self.wallpaperArray[indexPath.item];
     return cell;
    
    
}
#pragma mark - 壁纸点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
   
    YXWPreViewViewController *preVC = [[YXWPreViewViewController alloc] init];
    preVC.imageName = self.wallpaperArray[indexPath.item];
    [self.navigationController pushViewController:preVC animated:YES];
}

#pragma mark - 关闭返回
-(void)closeAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 鉴测滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (self.collectionView.contentOffset.y > 0) {
//        [self.navigationController.navigationBar setBackgroundImage:[self imageWithBgColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.20078125]] forBarMetrics:UIBarMetricsDefault];
//    } else {
//        [self.navigationController.navigationBar setBackgroundImage:[self imageWithBgColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
//    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
