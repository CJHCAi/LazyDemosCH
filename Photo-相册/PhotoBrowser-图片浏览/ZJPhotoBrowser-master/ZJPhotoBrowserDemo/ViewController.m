//
//  ViewController.m
//  ZJPhotoBrowserDemo
//
//  Created by 陈志健 on 2017/4/11.
//  Copyright © 2017年 chenzhijian. All rights reserved.
//

#import "ViewController.h"
#import "ZJPhotoBrowser.h"
@interface ViewController ()<ZJPhotoBrowerDelegate,UIViewControllerPreviewingDelegate>

@property (nonatomic, strong)NSArray *picsArray;

@property (nonatomic, strong)NSArray *viewArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(50, 100, 300, 300)];
    
    backView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:backView];
    
    _picsArray = @[@"http://pic1.win4000.com/wallpaper/b/58b6b658bdf15.jpg",
                   @"http://img.pconline.com.cn/images/upload/upc/tx/wallpaper/1207/05/c0/12233333_1341470829710.jpg",
                   @"http://pic1.win4000.com/wallpaper/1/58ae83b9b4538.jpg",
                   @"http://pic1.win4000.com/wallpaper/1/58d86dc4246e8.jpg",
                   @"http://pic1.win4000.com/wallpaper/0/587c355dc3292.jpg",
                   @"http://pic1.win4000.com/wallpaper/1/58d47bfeebebf.jpg",
                   @"http://pic1.win4000.com/wallpaper/7/58b66db8cf6d9.jpg",
                   @"http://pic1.win4000.com/wallpaper/9/58d5e2ccbdce9.jpg",
                   @"http://pic1.win4000.com/wallpaper/d/589ea2dd5870c.jpg"];
    
    CGFloat width = 100;
    CGFloat height = 100;
    NSMutableArray *mArray = [[NSMutableArray alloc] initWithCapacity:1];
    for (int i = 0; i < _picsArray.count; i++) {
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i%3*width, i/3*height, width, height)];
        imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"image_%d.jpg",i]];
        imgView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTapaction:)];
        imgView.tag = i;
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        
        [imgView addGestureRecognizer:tap];
        [backView addSubview:imgView];
        
        [mArray addObject:imgView];
    
    }
    
    self.viewArray = mArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imgTapaction:(UITapGestureRecognizer *)tap{
    
    ZJPhotoBrowser *photoBrowser = [[ZJPhotoBrowser alloc] init];
    photoBrowser.delegate = self;
    [photoBrowser showWithSelectedIndex:tap.view.tag];

}

#pragma mark - ZJPhotoBrowserDelegate
//需要显示的图片个数
- (NSUInteger)numberOfPhotosInPhotoBrowser:(ZJPhotoBrowser *)photoBrowser{
    
    return _picsArray.count;
}
//返回需要显示的图片对应的Photo实例,通过Photo类指定大图的URL,以及原始的图片视图
- (ZJPhoto *)photoBrowser:(ZJPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    
    ZJPhoto *zjPhoto = [[ZJPhoto alloc] init];
    zjPhoto.srcImageView = _viewArray[index];
    zjPhoto.url = [NSURL URLWithString:_picsArray[index]];
    return zjPhoto;
}
//返回长按的事件,默认有保存图片
- (NSArray<ZJAction *> *)longPressActionsInPhotoBrowser:(ZJPhotoBrowser *)photoBrowser image:(UIImage *)image{
    
    ZJAction* action =  [[ZJAction alloc] initWithTitle:@"自定义" action:^{
        NSLog(@"img%@", image);
        
    }];

    return @[action];
}
@end
