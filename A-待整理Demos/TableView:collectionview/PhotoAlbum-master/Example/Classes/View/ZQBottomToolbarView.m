//
//  ZQBottomToolbarView.m
//  PhotoAlbum
//
//  Created by ZhouQian on 16/5/29.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import "ZQBottomToolbarView.h"
#import <Photos/Photos.h>
#import "ZQPhotoModel.h"
#import "ZQPhotoPreviewVC.h"
#import "ZQPreviewCell.h"
#import "ZQPhotoFetcher.h"
#import "ZQAlbumNavVC.h"
#import "ProgressHUD.h"
#import "ViewUtils.h"
#import "ZQPublic.h"
#import "ZQTools.h"


@interface ZQBottomToolbarView ()
@property (nonatomic, strong) NSArray<ZQPhotoModel*> *selections;
@end


@implementation ZQBottomToolbarView


- (instancetype)init {
    return [self initWithFrame:CGRectMake(0, 0, kTPScreenWidth, kBottomToolbarHeight)];
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.7];
        
        self.vLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 0.5)];
        self.vLine.backgroundColor = HEXCOLOR(0xded8d7);
        [self addSubview:self.vLine];
        
        [self setupPreviewBtn:frame];
        [self setupFinishBtn:frame];
        [self setupSelectionCircle:frame];
        
        [self addSubview:self.btnCancel];
        self.btnCancel.hidden = YES;
    }
    return self;
}
- (void)setupPreviewBtn:(CGRect)frame {
    NSString *titlePreView = _LocalizedString(@"OPERATION_PREVIEW");
    self.btnPreview = [[UIButton alloc] init];
    [self.btnPreview setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [self.btnPreview setTitleColor:[UIColor grayColor] forState:(UIControlStateDisabled)];
    self.btnPreview.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.btnPreview setTitle:titlePreView forState:(UIControlStateNormal)];
    [self.btnPreview sizeToFit];
    self.btnPreview.frame = CGRectMake(ZQSide_X,
                                       0.5,
                                       self.btnPreview.width,
                                       frame.size.height);
    [self addSubview:self.btnPreview];
    self.btnPreview.enabled = NO;
    [self.btnPreview addTarget:self
                        action:@selector(preview)
              forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupFinishBtn:(CGRect)frame {
    self.btnFinish = [[UIButton alloc] init];
    [self.btnFinish setTitleColor:ZQAlbumBarTintColor forState:UIControlStateNormal];
    [self.btnFinish setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [self.btnFinish setTitle:_LocalizedString(@"OPERATION_FINISH") forState:(UIControlStateNormal)];
    self.btnFinish.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.btnFinish sizeToFit];
    self.btnFinish.frame = CGRectMake(frame.origin.x+frame.size.width-self.btnFinish.width-ZQSide_X,
                                      0.5,
                                      self.btnFinish.frame.size.width,
                                      frame.size.height);
    self.btnFinish.enabled = NO;
    [self addSubview:self.btnFinish];
    [self.btnFinish addTarget:self
                       action:@selector(finish)
             forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupSelectionCircle:(CGRect)frame {
    self.ivCircle = [[UIImageView alloc] initWithImage:_image(@"photo_number_icon")];
    CGFloat x = self.btnFinish.frame.origin.x - 5 - self.ivCircle.frame.size.width;
    CGFloat y = (frame.size.height - self.ivCircle.frame.size.height)/2;
    self.ivCircle.frame = CGRectMake(x,
                                     y,
                                     self.ivCircle.width,
                                     self.ivCircle.height);
    [self addSubview:self.ivCircle];
    self.ivCircle.hidden = YES;
    
    self.lblNumber = [[UILabel alloc] init];
    self.lblNumber.textColor = [UIColor whiteColor];
    self.lblNumber.font = [UIFont boldSystemFontOfSize:15];
    [self addSubview:self.lblNumber];
    self.lblNumber.center = self.ivCircle.center;
    self.lblNumber.size = CGSizeMake(5, 5);
}

- (void)setBSingleSelection:(BOOL)bSingleSelection {
    _bSingleSelection = bSingleSelection;
    
    if (bSingleSelection) {
        self.btnCancel.hidden = NO;
    }
    
}


- (void)setSelectedNum:(NSInteger)selectedNum {
    _selectedNum = selectedNum;
    if (selectedNum == 0) {
        self.btnPreview.enabled = NO;
        self.btnFinish.enabled = NO;
        self.lblNumber.hidden = YES;
        self.ivCircle.hidden = YES;
    }
    else {
        [self.btnPreview setEnabled:YES];
        self.btnFinish.enabled = YES;
        self.lblNumber.hidden = NO;
        self.lblNumber.text = [NSString stringWithFormat:@"%zd", selectedNum];
        [self.lblNumber sizeToFit];
        self.lblNumber.center = self.ivCircle.center;
        ______WS();
        self.ivCircle.hidden = NO;
        self.ivCircle.transform = CGAffineTransformMakeScale(0.01, 0.01);
        [UIView animateWithDuration:0.35 animations:^{
            wSelf.ivCircle.transform = CGAffineTransformIdentity;
        }];
    }
}


- (UIButton *)btnCancel {
    if (!_btnCancel) {
        _btnCancel = [[UIButton alloc] init];
        _btnCancel.titleLabel.font = [UIFont systemFontOfSize:15];
        [_btnCancel setTitle:_LocalizedString(@"OPERATION_CANCEL") forState:UIControlStateNormal];
        [_btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnCancel sizeToFit];
        _btnCancel.frame = CGRectMake(ZQSide_X, 0.5, self.btnCancel.width, self.frame.size.height);
        [_btnCancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnCancel;
}
- (void)cancel {
    [[self firstViewController].navigationController popViewControllerAnimated:YES];
}

- (void)selectionChange:(NSArray<ZQPhotoModel *> *)models {
    self.selections = models;
    self.selectedNum = models.count;
}


- (void)preview {
    ZQAlbumNavVC *nav = (ZQAlbumNavVC *)[self firstViewController].navigationController;
    
    ZQPhotoPreviewVC *vc = [[ZQPhotoPreviewVC alloc] init];
    vc.models = self.selections;
    vc.currentIdx = 0;
    vc.selected = [self.selections mutableCopy];
    vc.maxImagesCount = nav.maxImagesCount;
    UIViewController *pvc = [self firstViewController];
    vc.delegate = (id<ZQPhotoPreviewVCDelegate>)pvc;
    [pvc.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 选择图片后获取图片

- (void)finish {
    [ProgressHUD show];
    ______WS();
    
    if (self.bSingleSelection) {
        UIViewController *pvc = [self firstViewController];
        if ([pvc isKindOfClass:[ZQPhotoPreviewVC class]]) {
            [[pvc.view subviews] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([view isKindOfClass:[UICollectionView class]]) {
                    UICollectionView *cv = (UICollectionView *)view;
                    ZQPreviewCell *cell = [cv.visibleCells firstObject];
                    wSelf.selections = @[cell.mPhoto];
                }
            }];
        }
    }

    
    NSMutableArray *resultImg = [NSMutableArray new];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        __block dispatch_group_t group = dispatch_group_create();
        for (int i=0; i<wSelf.selections.count; i++) {
            dispatch_group_enter(group);
            ZQPhotoModel *model = wSelf.selections[i];

            //先调一次返回小图，再调一次返回大图
            [ZQPhotoFetcher getPhotoWithAssets:model.asset photoWidth:kTPScreenWidth completion:^(UIImage *image, NSDictionary *info) {
                NSLog(@"isMain: %d", [NSThread isMainThread]);
                if (info) {
                    //只存大图，可能没有requestID，但是有图
                    if ([[info objectForKey:PHImageResultIsDegradedKey] integerValue] == 0) {
                        if (image) {//可能为nil
                            [resultImg addObject:image];
                        }
                        dispatch_group_leave(group);
                    }
                    
                }
                else {
                    //info也没有是什么情况
                    //如果没有回调大图，group出不去，整个group会在超时时间60s后结束并返回
                }
            }];

        }
        dispatch_time_t timeout = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC));
        long ret = dispatch_group_wait(group, timeout);
        dispatch_async(dispatch_get_main_queue(), ^{
            [ProgressHUD hide];
            UIViewController *vc = [wSelf firstViewController];
            ZQAlbumNavVC *nav = (ZQAlbumNavVC *)vc.navigationController;
            [nav dismissViewControllerAnimated:YES completion:^{
                if (nav.didFinishPickingPhotosHandle) {
                    NSArray *images = resultImg;
                    if (images.count == 0 || ret != 0) {
                        NSString *msg = _LocalizedString(@"FETCH_PHOTO_ERROR");
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:(UIAlertControllerStyleAlert)];
                        UIAlertAction *ok = [UIAlertAction actionWithTitle:_LocalizedString(@"OPERATION_OK") style:(UIAlertActionStyleDefault) handler:nil];
                        [alert addAction:ok];
                        [[ZQTools rootViewController] presentViewController:alert animated:YES completion:nil];
                    }
                    nav.didFinishPickingPhotosHandle(images);
                }
            }];
            
            
        });
    });
}
@end
