//
//  ZJPhotoBrowser.m
//  ZJPhotoBrowserDemo
//
//  Created by 陈志健 on 2017/4/10.
//  Copyright © 2017年 chenzhijian. All rights reserved.
//

#import "ZJPhotoBrowser.h"
#import "ZJPhotoCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface ZJPhotoBrowser ()<UICollectionViewDelegate,UICollectionViewDataSource,ZJPhotoViewDelegate>

@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger tapIndex;//点击的图片下标
@property (nonatomic, strong) UICollectionView *contentView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableDictionary *photoDic;
@property (nonatomic, assign) NSInteger totalPhotoNub;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end


static NSString *identifier = @"ZJPhotoCellID";

@implementation ZJPhotoBrowser

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.contentView];
    [self.view addSubview:self.pageControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)prefersStatusBarHidden{
    
    return YES;
}
#pragma mark - 懒加载视图
- (UIPageControl *)pageControl {

    if (_pageControl == nil) {
        
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
        
        _pageControl.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height - _pageControl.frame.size.height);
        if (self.totalPhotoNub == 1) {
            
            _pageControl.numberOfPages = 0;

        }else {
        
            _pageControl.numberOfPages = self.totalPhotoNub;
        }
        _pageControl.currentPage = _tapIndex;

    }

    return _pageControl;
}

- (UICollectionView *)contentView {

    if (_contentView == nil) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.itemSize = CGSizeMake(self.view.frame.size.width + kPhotoImageEdgeWidth, self.view.frame.size.height);
        layout.minimumLineSpacing = 0.0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

        _contentView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame)+kPhotoImageEdgeWidth, CGRectGetHeight(self.view.frame)) collectionViewLayout:layout];
        [_contentView registerClass:[ZJPhotoCell class] forCellWithReuseIdentifier:identifier];
        _contentView.pagingEnabled = YES;
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.dataSource = self;
        _contentView.delegate = self;
        _contentView.showsHorizontalScrollIndicator = NO;
        
        if (_tapIndex < self.totalPhotoNub) {
            
            //滑到点击的图片
            [_contentView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_tapIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        }

    }

    return _contentView;
}

- (NSMutableDictionary *)photoDic {

    if (_photoDic == nil) {
        
        _photoDic = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    
    return _photoDic;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    int index = scrollView.contentOffset.x / scrollView.bounds.size.width;
    _pageControl.currentPage = index;
    _currentIndex = index;
}

#pragma mark - CollectionDetegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return  self.totalPhotoNub;

}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZJPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.zjPhotoView.photoDelegate = self;
    
    //添加photo,避免多次加载
    ZJPhoto *zjPhoto = [self.photoDic objectForKey:indexPath];
    
    if (zjPhoto == nil) {
        
        if ([self.delegate respondsToSelector:@selector(photoBrowser:photoAtIndex:)]) {
            
            zjPhoto = [self.delegate photoBrowser:self photoAtIndex:indexPath.row];
            [self.photoDic setObject:zjPhoto forKey:indexPath];
            if (indexPath.row == _tapIndex) {
                zjPhoto.isTapImage = YES;
            }
        }
    }

    cell.zjPhoto = zjPhoto;
    return cell;
}

#pragma mark - ZJPhotoViewDetegate
- (void)zjPhotoView:(ZJPhotoView *)photoView receiveTapWithZJPhotoTapType:(ZJPhotoTapTypeName)tapTypeName {

    if (tapTypeName == ZJPhotoTapTypeOne) {
        //单击  browser消失
        UIImageView *tempImageView = [[UIImageView alloc] init];
        tempImageView.frame = [photoView.imageView convertRect:photoView.imageView.bounds toView:nil];
        tempImageView.image = photoView.imageView.image;
        [self.view.window addSubview:tempImageView];
        
        [self dismissViewControllerAnimated:NO completion:nil];

        [UIView animateWithDuration:0.3 animations:^{
            
            tempImageView.frame = [photoView.zjPhoto.srcImageView convertRect:photoView.zjPhoto.srcImageView.bounds toView:photoView];

        } completion:^(BOOL finished) {
            
            [tempImageView removeFromSuperview];
        }];
        
    }else if (ZJPhotoTapTypeLong) {
    //长按
        //获取图片
        UIImage *image = photoView.imageView.image;
        ZJActionSheet *actionSheet = [[ZJActionSheet alloc] init];
        
        //默认添加<保存图片>事件
        ZJAction *savaPicAction = [[ZJAction alloc] initWithTitle:@"保存图片" action:^{
            [self saveImage:image];
            
        }];
        
        [actionSheet addAction:savaPicAction];
        
        //添加代理实现的事件
        if ([self.delegate respondsToSelector:@selector(longPressActionsInPhotoBrowser:image:)]) {
            
            NSArray *actionsArray = [self.delegate longPressActionsInPhotoBrowser:self image:image];
            for (int i = 0; i < actionsArray.count; i ++) {
                
                ZJAction *action = actionsArray[i];
                [actionSheet addAction:action];
            }
        }
        [actionSheet show];
    }
}
#pragma mark 保存图像
- (void)saveImage:(UIImage *)image {
    
    ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
    if (authStatus == ALAuthorizationStatusDenied || authStatus == ALAuthorizationStatusRestricted) {
        // 没有权限
        [self showAlert];
    }else{
        // 已经获取权限
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        
        _indicatorView = [[UIActivityIndicatorView alloc] init];
        _indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        _indicatorView.center = self.view.center;
        [[UIApplication sharedApplication].keyWindow addSubview:_indicatorView];
        [_indicatorView startAnimating];
    }

}
//保存图片的回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    [_indicatorView stopAnimating];
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.50f];
    label.layer.cornerRadius = 5;
    label.clipsToBounds = YES;
    label.bounds = CGRectMake(0, 0, 100, 40);
    label.center = self.view.center;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:14];
    [[UIApplication sharedApplication].keyWindow addSubview:label];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:label];
    if (error) {
        label.text = @"保存失败";
    }   else {
        label.text = @"保存成功";
    }
    [label performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.0];
}

#pragma mark - 弹出Browser
- (void)showWithSelectedIndex:(NSUInteger)index {
    
    if ([self.delegate respondsToSelector:@selector(numberOfPhotosInPhotoBrowser:)]) {
        
        self.totalPhotoNub = [self.delegate numberOfPhotosInPhotoBrowser:self];
    }
    self.tapIndex = index;
    //弹出
    UIViewController* topVC = [self currentViewController];
    [topVC presentViewController:self animated:NO completion:^{}];
}


//获取顶层的viewController
- (UIViewController *)currentViewController {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIViewController *vc = keyWindow.rootViewController;
    while (vc.presentedViewController) {
        vc = vc.presentedViewController;
        
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = [(UINavigationController *)vc visibleViewController];
        } else if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = [(UITabBarController *)vc selectedViewController];
        }
    }
    return vc;
}

//相册权限
- (void)showAlert {
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"相册权限未开启" message:@"请在iPhone的【设置】>【隐私】>【相册】中打开开关,开启相册权限" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"立即开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *version = [UIDevice currentDevice].systemVersion;
        if (version.doubleValue >= 8.0) {
            // iOS系统版本 >= 8.0 跳入当前App设置界面,
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];

        } else{
            //iOS系统版本 < 8.0
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"prefs:General&path=Reset"]];
        }
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];

    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
  
    [self presentViewController:alertController animated:YES completion:nil];
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
