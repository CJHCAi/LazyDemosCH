//
//  ImageProcessViewController.m
//  LuoChang
//
//  Created by Rick on 15/5/20.
//  Copyright (c) 2015年 Rick. All rights reserved.
//



#import "ImageProcessViewController.h"
#import "BigPreviewImageView.h"
#import "PendantImageView.h"
#import "ImageCropperView.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Utils.h"
#import "GifView.h"
#import "PIPCollectionViewCell.h"
#import "UIView+MJExtension.h"
#import "ImageFilterScrollView.h"
#import "PIPCollectionView.h"

@interface ImageProcessViewController ()<ImageFilterItemDelegate,PIPCollectionViewItemDelegate>
{

    NSDictionary *_selectedPipDic;
    ImageCropperView *_cropper;
    PendantImageView *_pendantImageView;

    ImageFilterScrollView *_imageFilterScrollView;
    ImageFilterItem *_selectedImageFilterItem;
    NSURL *_gifURL;
    CGRect _bigImageViewDefaultFrame;
    PIPCollectionView *_collectionView;
    CGFloat _scrollViewContentHeight;
    UIRotationGestureRecognizer *_rotateGes;
    UIPinchGestureRecognizer *_scaleGes;
    UIPanGestureRecognizer *_moveGes;

}
@property (strong, nonatomic)  UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIView *operationBarView;
@property (strong, nonatomic)  UIButton *pipImageBtn;
@property (strong, nonatomic)  UIButton *filterImageBtn;
@end

@implementation ImageProcessViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _scrollView = [[UIScrollView alloc]init];
    [self.view addSubview:_scrollView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;
    _scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height-50-64);
//    _scrollView.backgroundColor = [UIColor redColor];
    UIScreen *sc =[UIScreen mainScreen];
    _scrollViewContentHeight = _originalImage.size.height/sc.scale;
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH,_scrollViewContentHeight);

    self.view.backgroundColor = RGB(170, 170, 170);
    _pendantImageView = [[PendantImageView alloc] init];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    _bigPreviewImageView = [[BigPreviewImageView alloc]init];
    [_scrollView addSubview:_bigPreviewImageView];
    _bigPreviewImageView.image = [_originalImage copy];
    _bigPreviewImageView.contentMode = UIViewContentModeScaleToFill;
    if (_scrollViewContentHeight < _scrollView.frame.size.width) {
        _bigPreviewImageView.frame = CGRectMake(0, (CGRectGetHeight(_scrollView.frame)-_scrollViewContentHeight) * 0.5, _scrollView.frame.size.width , _scrollViewContentHeight);
    }else{
       _bigPreviewImageView.frame = CGRectMake(0, 0, _scrollView.frame.size.width, _originalImage.size.height/sc.scale);
    }
    _bigImageViewDefaultFrame = _bigPreviewImageView.frame;
    
    _pipImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_pipImageBtn setTitle:@"画中画" forState:UIControlStateNormal];
    _pipImageBtn.frame = CGRectMake(0, SCREEN_HEIGHT-55-64, SCREEN_WIDTH/2, 55);
    _pipImageBtn.backgroundColor = [UIColor orangeColor];
    [_pipImageBtn addTarget:self action:@selector(showPIPCollectionView:) forControlEvents:UIControlEventTouchUpInside];
    _filterImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_filterImageBtn setTitle:@"滤镜" forState:UIControlStateNormal];
    _filterImageBtn.frame = CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-55-64, SCREEN_WIDTH/2, 55);
    [_filterImageBtn addTarget:self action:@selector(showImageFilterScrollView:) forControlEvents:UIControlEventTouchUpInside];
    _filterImageBtn.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_pipImageBtn];
    [self.view addSubview:_filterImageBtn];
    [self.view bringSubviewToFront:_pipImageBtn];
    [self.view bringSubviewToFront:_filterImageBtn];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.navigationController.navigationBar.translucent = NO;
    
}


-(void)changePip:(NSDictionary *)dict{
    if (!_selectedPipDic && [dict[@"name"] isEqualToString:@"None"]) {
        [self.view removeGestureRecognizer:_moveGes];
        [self.view removeGestureRecognizer:_scaleGes];
        [self.view removeGestureRecognizer:_rotateGes];
        _moveGes = nil;
        _scaleGes = nil;
        _rotateGes = nil;
        return;
    }
    _selectedPipDic = dict;
    [_scrollView removeFromSuperview];
    _scrollView = nil;
    if(_backgroundView == nil && ![dict[@"name"] isEqualToString:@"None"]){
        _backgroundView = [[UIView alloc]init];
        [self.view addSubview:_backgroundView];
    }
    
    [_bigPreviewImageView removeFromSuperview];
    _bigPreviewImageView.frame = CGRectMake(0, 0 , SCREEN_WIDTH, SCREEN_WIDTH/320*192);
    _bigPreviewImageView.center = CGPointMake(SCREEN_WIDTH/2, (SCREEN_HEIGHT-64-50)/2);
    _backgroundView.frame = _bigPreviewImageView.frame;
 
    [_backgroundView addSubview:_bigPreviewImageView];
    _bigPreviewImageView.mj_y = 0;
    if (_rotateGes == nil) {
        _rotateGes = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateImage:)];
        [self.view addGestureRecognizer:_rotateGes];
    }
    
    if (_scaleGes == nil) {
        _scaleGes = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scaleImage:)];
        [self.view addGestureRecognizer:_scaleGes];
    }
    
    if (_moveGes == nil) {
        _moveGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveImage:)];
        [_moveGes setMinimumNumberOfTouches:1];
        [_moveGes setMaximumNumberOfTouches:1];
        [self.view addGestureRecognizer:_moveGes];
    }

    if (![dict[@"name"] isEqualToString:@"None"]) {
        if(_cropper == nil){
            _cropper = [[ImageCropperView alloc]init];
            [_bigPreviewImageView addSubview:_cropper];
            _cropper.frame = CGRectMake(0, 0, 100, 100);
            [_cropper setup];
        }
        
        [_cropper reset];
        
        NSString *name = dict[@"name"];
        BOOL hasPendant = [dict[@"hasPendant"] boolValue];
        if (hasPendant) {
            _pendantImageView.alpha = 1.0;
            NSURL *pendantImageURL = [[NSBundle mainBundle] URLForResource:dict[@"pendantName"] withExtension:nil];
            [_pendantImageView sd_setImageWithURL:pendantImageURL];
        }else{
            _pendantImageView.alpha = 0;
        }
        
        CGRect photoFrame = [dict[@"photoFrame"] CGRectValue];
        NSURL *backImageFileUrl = [[NSBundle mainBundle] URLForResource:name withExtension:nil];
        [_bigPreviewImageView sd_setImageWithURL:backImageFileUrl];
        
        BOOL layerMasksToBounds = [dict[@"layerMasksToBounds"] boolValue];
        if (layerMasksToBounds) {
            _cropper.layer.masksToBounds = YES;
            _cropper.layer.cornerRadius = [dict[@"cornerRadius"] doubleValue];
        }else{
            _cropper.layer.masksToBounds = YES;
            _cropper.layer.cornerRadius = 0;
        }
        
        BOOL isIrregular = [dict[@"isIrregular"] boolValue];
        if (isIrregular) {
            [_pendantImageView removeFromSuperview];
            if (hasPendant) {
                _pendantImageView.alpha =1;
                [_bigPreviewImageView addSubview:_pendantImageView];
            }
            
            //不规则的背景图
            _bigPreviewImageView.isIrregular = YES;
            _bigPreviewImageView.userInteractionEnabled = YES;
            [_cropper removeFromSuperview];
            [self.backgroundView addSubview:_cropper];
            [self.backgroundView bringSubviewToFront:_bigPreviewImageView];
            
            _cropper.frame = CGRectMake(CGRectGetMinX(_bigPreviewImageView.frame), CGRectGetMinY(_bigPreviewImageView.frame), _bigPreviewImageView.frame.size.width, SCREEN_WIDTH/320*192);
            
        }else{
            //规则背景图
            _bigPreviewImageView.userInteractionEnabled = YES;
            _bigPreviewImageView.isIrregular = NO;
            [_cropper removeFromSuperview];
            
            _cropper.frame = CGRectMake(SCREEN_WIDTH/320*photoFrame.origin.x, SCREEN_WIDTH/320*photoFrame.origin.y, SCREEN_WIDTH/320*photoFrame.size.width, SCREEN_WIDTH/320*photoFrame.size.height);
            [_bigPreviewImageView addSubview:_cropper];
            _pendantImageView.frame = CGRectMake(0, 0, _cropper.frame.size.width, _cropper.frame.size.height);
            _pendantImageView.userInteractionEnabled = YES;
            
            [_cropper addSubview:_pendantImageView];

        }
        
        if (_cropper.image == nil) {
            _cropper.image = [_originalImage copy];
        }

    }else{
        //取消画中画
        [self.view removeGestureRecognizer:_moveGes];
        [self.view removeGestureRecognizer:_scaleGes];
        [self.view removeGestureRecognizer:_rotateGes];
        _moveGes = nil;
        _scaleGes = nil;
        _rotateGes = nil;
        
        [_pendantImageView removeFromSuperview];
        _pendantImageView = nil;
        [_cropper removeFromSuperview];
        _bigPreviewImageView.image = [_cropper.image copy];
        _cropper = nil;
        _bigPreviewImageView.contentMode = UIViewContentModeScaleAspectFit;
        _selectedPipDic = nil;
        [_bigPreviewImageView removeFromSuperview];
        [_scrollView removeFromSuperview];
        _scrollView = nil;
        
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height-50);
        [self.view addSubview:_scrollView];

        UIScreen *sc =[UIScreen mainScreen];
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH,_scrollViewContentHeight);
        _bigPreviewImageView.contentMode = UIViewContentModeScaleToFill;
        if (_scrollViewContentHeight < _scrollView.frame.size.width) {
            _bigPreviewImageView.frame = CGRectMake(0, (CGRectGetHeight(_scrollView.frame)-_scrollViewContentHeight) * 0.5, _scrollView.frame.size.width , _scrollViewContentHeight);
        }else{
            _bigPreviewImageView.frame = CGRectMake(0, 0, _scrollView.frame.size.width, _originalImage.size.height/sc.scale);
        }
//        _bigPreviewImageView.frame = _bigImageViewDefaultFrame;
        [_scrollView addSubview:_bigPreviewImageView];

    }
    
}

-(void)showPIPCollectionView:(UIButton *)btn{
    [self hidenImageFilterScrollView];
    btn.selected = !btn.selected;
    if (btn.selected) {
        if (!_collectionView) {
            UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
            _collectionView = [[PIPCollectionView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 111) collectionViewLayout:flowLayout];
            _collectionView.originalImage = _originalImage;
            _collectionView.pipDelegate = self;
            [self.view addSubview:_collectionView];
            [self.view bringSubviewToFront:_operationBarView];
            [UIView animateWithDuration:0.3 animations:^{
                _collectionView.frame = CGRectMake(CGRectGetMinX(btn.superview.frame), CGRectGetMinY(btn.frame)-111, SCREEN_WIDTH, 111);
            }];
        }
        
    }else{
        _pipImageBtn.selected = NO;

        [UIView animateWithDuration:0.3 animations:^{
            _collectionView.frame = CGRectMake(CGRectGetMinX(btn.superview.frame), SCREEN_HEIGHT, SCREEN_WIDTH, 111) ;
        } completion:^(BOOL finished) {
            [_collectionView removeFromSuperview];
            _collectionView = nil;
        }];
    }
}

/**
 *  点击画中画按钮 显示画中画列表
 *
 *  @param sender
 */
- (IBAction)pipAction:(UIButton *)sender {

    [self showPIPCollectionView:sender];
    
}

- (IBAction)showImageFilterScrollView:(UIButton *)btn {
    [self hidenCollectionView];
    btn.selected = !btn.selected;
    if (btn.selected) {
        if (_imageFilterScrollView == nil) {
            _imageFilterScrollView = [[ImageFilterScrollView alloc]initWithImage:_originalImage];
            _imageFilterScrollView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 111);
            _imageFilterScrollView.imageFilterItemdelegate = self;
            
            [self.view addSubview:_imageFilterScrollView];
            [self.view bringSubviewToFront:_operationBarView];
            [UIView animateWithDuration:0.3f animations:^{
                _imageFilterScrollView.frame = CGRectMake(0, SCREEN_HEIGHT-111-50-64, SCREEN_WIDTH, 111);
            } completion:^(BOOL finished) {
                
            }];
            
        }
    }else{
        
        [UIView animateWithDuration:0.3f animations:^{
            _imageFilterScrollView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 80);
        } completion:^(BOOL finished) {
            [_imageFilterScrollView removeFromSuperview];
            _imageFilterScrollView = nil;
            _filterImageBtn.selected = NO;
            _selectedImageFilterItem = nil;
        }];
        
        
    }
}


#pragma mark - 画中画点击代理
-(void)pipItemClick:(NSIndexPath *)indexPath pipDict:(NSDictionary *)pipDict{
    [self changePip:pipDict];
    _pipImageBtn.selected = NO;
    [_collectionView removeFromSuperview];
    _collectionView = nil;
    _scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height-50);
}


#pragma mark 图片滤镜处理代理
-(void)imageFilterItemClick:(ImageFilterItem *)itemView filterDict:(NSDictionary *)filterDict{
    [MBHUD hudShow:@"处理中……" inView:self.view];
    if (_selectedImageFilterItem) {
        _selectedImageFilterItem.selected = NO;
    }
    _selectedImageFilterItem = itemView;
    NSString *filterNameKey = [filterDict allKeys].firstObject;

    if ([filterNameKey isEqualToString:@"NONE"]) {
        if (_selectedPipDic) {
            _cropper.image = [_originalImage copy];
        }else{
            _bigPreviewImageView.image = [_originalImage copy];
        }
        [hud hide:YES];
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *newimage = [UIImage filteredImage:[_originalImage copy] withFilterName:filterNameKey];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_selectedPipDic) {
                _cropper.image = newimage;
            }else{
                _bigPreviewImageView.image = newimage;
            }
            [hud hide:YES];
        });
    });
}


-(void)addWaterAction:(UIImage *)image{
    NSDate *date = [NSDate date];
    if (_selectedPipDic) {
        if ([_selectedPipDic[@"isGIF"] boolValue]) {
            //读取本地GIF图中每一帧图像的信息
            NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:_selectedPipDic[@"name"] withExtension:nil];
            NSDictionary *dic = [GifView getGifInfo:fileUrl];
            NSMutableArray *imageArray = [NSMutableArray array];
            
            //在gif图的每一帧上面添加一段文字
            for(int index=0;index<[dic[@"images"] count];index++)
            {
                //绘制view 已GIf图中的某一帧为背景并在view上添加文字
                UIView *tempView = [[UIView alloc] initWithFrame:CGRectFromString(dic[@"bounds"])];
                tempView.backgroundColor = [UIColor colorWithPatternImage:dic[@"images"][index]];
                UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
                CGRect photoFrame = [_selectedPipDic[@"photoFrame"] CGRectValue];
                imageView.frame = CGRectMake(photoFrame.origin.x*2, photoFrame.origin.y*2, photoFrame.size.width*2, photoFrame.size.height*2);
                [tempView addSubview:imageView];
                
                //将UIView转换为UIImage
                UIGraphicsBeginImageContextWithOptions(tempView.bounds.size, NO, tempView.layer.contentsScale);
                [tempView.layer renderInContext:UIGraphicsGetCurrentContext()];
                UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
                [imageArray addObject:image];
                UIGraphicsEndImageContext();
            }
            //生成GIF图 -- loopCount 为0表示无限播放
            NSString *path = [GifView exportGifImages:[imageArray copy] delays:dic[@"delays"] loopCount:0];
            NSURL *gifURL = [NSURL fileURLWithPath:path];
            _gifURL = gifURL;
            _afterFilterImage = [UIImage imageWithContentsOfFile:path];
            NSLog(@"图片生成路劲：%@",path);
        }else{
 
            UIGraphicsBeginImageContextWithOptions(_backgroundView.bounds.size, NO, 0);
            [_backgroundView.layer renderInContext:UIGraphicsGetCurrentContext()];
            _afterFilterImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            _gifURL = nil;
          }
    }else{
        _gifURL = nil;
       _afterFilterImage = _bigPreviewImageView.image;
    }
    
    MJLog(@"合成图用时：%f秒",[[NSDate date] timeIntervalSinceDate:date]);
    
}


- (IBAction)nextSetup:(UIBarButtonItem *)sender {
    if (_selectedPipDic) {
        [MBHUD hudShow:@"处理中……" inView:self.view];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image;
            UIGraphicsBeginImageContextWithOptions(_cropper.bounds.size, NO, 0);
            [_cropper.layer renderInContext:UIGraphicsGetCurrentContext()];
            image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            [self addWaterAction:image];
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hide:YES];
                [self performSegueWithIdentifier:@"ImageProcessNextSetup" sender:nil];
            });
        });
    }else{
        [self performSegueWithIdentifier:@"ImageProcessNextSetup" sender:nil];
    }
    
}


//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    if ([segue.identifier isEqualToString:@"ImageProcessNextSetup"]) {
//        StatusPublishViewController *publishVC = segue.destinationViewController;
//        UIImage *image;
//        if (!_selectedPipDic) {
//            image = _bigPreviewImageView.image;
//        }else{
//            image = _afterFilterImage;
//            if ([_selectedPipDic[@"isGIF"] boolValue]) {
//                publishVC.gifURL = _gifURL;
//                publishVC.isGIF = YES;
//            }
//        }
//        publishVC.processedImage = image;
//     
//        [publishVC RefreshPopVC:^{
//            UIViewController *vc = self.navigationController.viewControllers.firstObject;
//            if ([vc isKindOfClass:[StatusMainViewController class]]) {
//                StatusMainViewController *mainVC = (StatusMainViewController *)vc;
//                NSUInteger index = mainVC.segmentedControl.selectedSegmentIndex;
//                NSArray *controllers = [mainVC valueForKey:@"controllers"];
//                UIViewController *vc = controllers[index];
//                if ([vc isKindOfClass:[ShuaShuaViewController class]]) {
//                    ShuaShuaViewController *shuaVC = (ShuaShuaViewController *)vc;
//                    [shuaVC.tableView.header beginRefreshing];
//                }else if ([vc isKindOfClass:[HomeViewController class]]){
//                    HomeViewController *homeVC = (HomeViewController *)vc;
//                    [homeVC.tableView.header beginRefreshing];
//                }
//            }
//            
//        }];
//    }
//}

-(void)hidenImageFilterScrollView{
    if (_imageFilterScrollView) {
        [UIView animateWithDuration:0.3f animations:^{
            _imageFilterScrollView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 80);
        } completion:^(BOOL finished) {
            [_imageFilterScrollView removeFromSuperview];
            _imageFilterScrollView = nil;
            _filterImageBtn.selected = NO;
            _selectedImageFilterItem = nil;
        }];
    }
}

-(void)hidenCollectionView{
    if (_collectionView) {
        [UIView animateWithDuration:0.3 animations:^{
            _collectionView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 111) ;
        } completion:^(BOOL finished) {
            _pipImageBtn.selected = NO;
            [_collectionView removeFromSuperview];
            _collectionView = nil;
        }];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self hidenImageFilterScrollView];
    [self hidenCollectionView];
}


#pragma mark 图片放大缩小
- (void)moveImage:(UIPanGestureRecognizer *)sender{
    [_cropper moveImage:sender];
}
- (void)scaleImage:(UIPinchGestureRecognizer *)sender{
    [_cropper scaleImage:sender];
}
- (void)rotateImage:(UIRotationGestureRecognizer *)sender{
    [_cropper rotateImage:sender];
}

@end
