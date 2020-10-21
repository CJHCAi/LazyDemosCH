//
//  HXPhotoViewPresentTransition.m
//  照片选择器
//
//  Created by 洪欣 on 2017/10/28.
//  Copyright © 2017年 洪欣. All rights reserved.
//

#import "HXPhotoViewPresentTransition.h"
#import "HXPhotoView.h"
#import "HXPhotoSubViewCell.h"
#import "HXPhotoView.h"
#import "HXPhotoPreviewViewController.h"
#import "HXPhotoPreviewBottomView.h"

@interface HXPhotoViewPresentTransition ()
@property (strong, nonatomic) HXPhotoView *photoView ;
@property (assign, nonatomic) HXPhotoViewPresentTransitionType type;
@property (weak , nonatomic) UIImageView *tempView;
@end

@implementation HXPhotoViewPresentTransition
+ (instancetype)transitionWithTransitionType:(HXPhotoViewPresentTransitionType)type photoView:(HXPhotoView *)photoView {
    return [[self alloc] initWithTransitionType:type photoView:photoView];
}

- (instancetype)initWithTransitionType:(HXPhotoViewPresentTransitionType)type photoView:(HXPhotoView *)photoView {
    self = [super init];
    if (self) {
        self.type = type;
        self.photoView = photoView;
    }
    return self;
}
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    if (self.type == HXPhotoViewPresentTransitionTypePresent) {
        return 0.45f;
    }else {
        return 0.25f;
    }
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    switch (self.type) {
        case HXPhotoViewPresentTransitionTypePresent:
            [self presentAnimation:transitionContext];
            break;
            
        case HXPhotoViewPresentTransitionTypeDismiss:
            [self dismissAnimation:transitionContext];
            break;
    }
}
- (void)presentAnim:(id<UIViewControllerContextTransitioning>)transitionContext Image:(UIImage *)image Model:(HXPhotoModel *)model FromVC:(UIViewController *)fromVC ToVC:(HXPhotoPreviewViewController *)toVC cell:(HXPhotoSubViewCell *)cell{
    if ((!image || (model.networkPhotoUrl && (model.downloadError || !model.downloadComplete))) && toVC.manager.configuration.customPreviewFromImage) {
        image = toVC.manager.configuration.customPreviewFromImage(toVC.currentModelIndex);
    }
    model.tempImage = image;
    UIView *containerView = [transitionContext containerView];
    UIImageView *tempView = [[UIImageView alloc] initWithImage:image];
    UIView *tempBgView = [[UIView alloc] initWithFrame:containerView.bounds];
    tempView.clipsToBounds = YES;
    tempView.contentMode = UIViewContentModeScaleAspectFill;
    tempView.frame = [cell.imageView convertRect:cell.imageView.bounds toView:containerView];
    if (!image) {
        tempView.image = cell.imageView.image;
    }
    if (!cell && toVC.manager.configuration.customPreviewFromView) {
        cell = (id)toVC.manager.configuration.customPreviewFromView(toVC.currentModelIndex);
        tempView.frame = [cell convertRect:cell.bounds toView:containerView];
    }
    [tempBgView addSubview:tempView];
    self.tempView = tempView;
    
    [containerView addSubview:toVC.view];
    [toVC.view insertSubview:tempBgView atIndex:0];
    toVC.collectionView.hidden = YES;
    if (!cell) {
        toVC.collectionView.hidden = NO;
        toVC.collectionView.alpha = 0;
    }
    model.endImageSize = CGSizeZero;
    CGFloat imgWidht = model.endImageSize.width;
    CGFloat imgHeight = model.endImageSize.height;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    toVC.navigationController.navigationBar.userInteractionEnabled = NO;
    UIColor *tempColor = toVC.view.backgroundColor;
    toVC.view.backgroundColor = [tempColor colorWithAlphaComponent:0];
    cell.hidden = YES;
    [toVC setupDarkBtnAlpha:0.f];
    [UIView animateWithDuration:0.2 animations:^{
        toVC.view.backgroundColor = [tempColor colorWithAlphaComponent:1.f];
        [toVC setupDarkBtnAlpha:1.f];
        if (!cell) {
            toVC.collectionView.alpha = 1;
        }
    }];
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:0.75f initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (imgHeight <= height) {
            tempView.frame = CGRectMake((width - imgWidht) / 2, (height - imgHeight) / 2, imgWidht, imgHeight);
        }else {
            tempView.frame = CGRectMake(0, 0, imgWidht, imgHeight);
        }
    } completion:^(BOOL finished) {
        cell.hidden = NO;
        toVC.collectionView.hidden = NO;
        [tempBgView removeFromSuperview];
        [tempView removeFromSuperview];
        toVC.navigationController.navigationBar.userInteractionEnabled = YES;
        [transitionContext completeTransition:YES];
    }];
}
/**
 *  实现present动画
 */
- (void)presentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    HXPhotoPreviewViewController *toVC = (HXPhotoPreviewViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UICollectionView *collectionView = (UICollectionView *)self.photoView.collectionView;
    if ([fromVC isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)fromVC;
        fromVC = nav.viewControllers.lastObject;
    }else if ([fromVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBar = (UITabBarController *)fromVC;
        if ([tabBar.selectedViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav = (UINavigationController *)tabBar.selectedViewController;
            fromVC = nav.viewControllers.lastObject;
        }else {
            fromVC = tabBar.selectedViewController;
        }
    }
    HXPhotoSubViewCell *cell = (HXPhotoSubViewCell *)[collectionView cellForItemAtIndexPath:self.photoView.currentIndexPath];
    HXPhotoModel *model = cell.model;
    if (!model && toVC.currentModelIndex >= 0 && toVC.modelArray.count > 0 && toVC.currentModelIndex < toVC.modelArray.count) {
        model = toVC.modelArray[toVC.currentModelIndex];
    }
    [self presentAnim:transitionContext Image:model.thumbPhoto Model:model FromVC:fromVC ToVC:toVC cell:cell];
}

/**
 *  实现dimiss动画
 */
- (void)dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    HXPhotoPreviewViewController *fromVC = (HXPhotoPreviewViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    if (!fromVC.modelArray.count) {
        UIView *containerView = [transitionContext containerView];
        [containerView addSubview:fromVC.view];
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromVC.view.alpha = 0;
            fromVC.view.transform = CGAffineTransformMakeScale(1.5, 1.5);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
        return;
    }
    HXPhotoModel *model = [fromVC.modelArray objectAtIndex:fromVC.currentModelIndex];
    HXPhotoPreviewViewCell *fromCell = [fromVC currentPreviewCell:model];
    UIImageView *tempView;
    if (model.type == HXPhotoModelMediaTypeCameraPhoto) {
        tempView = [[UIImageView alloc] initWithImage:model.thumbPhoto];
    }else {
        tempView = [[UIImageView alloc] initWithImage:fromCell.previewContentView.image];
    }
    UICollectionView *collectionView = (UICollectionView *)self.photoView.collectionView;
    
    HXPhotoSubViewCell *cell = (HXPhotoSubViewCell *)[collectionView cellForItemAtIndexPath:[self.photoView currentModelIndexPath:model]];
    if (!tempView.image) {
        tempView = [[UIImageView alloc] initWithImage:cell.imageView.image];
    }
    tempView.clipsToBounds = YES;
    tempView.contentMode = UIViewContentModeScaleAspectFill;
    
    
    UIView *containerView = [transitionContext containerView];
    tempView.frame = [fromCell.previewContentView convertRect:fromCell.previewContentView.bounds toView:containerView];
    [containerView addSubview:tempView];
    
    CGRect rect = [cell convertRect:cell.bounds toView:containerView];
    if (!cell && fromVC.manager.configuration.customPreviewToView) {
        cell = (id)fromVC.manager.configuration.customPreviewToView(fromVC.currentModelIndex);
        rect = [cell convertRect:cell.bounds toView:containerView];
    }
    cell.hidden = YES;
    fromVC.collectionView.hidden = YES;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromVC.view.alpha = 0;
        if (cell) {
            tempView.frame = rect;
        }else {
            tempView.alpha = 0;
            tempView.transform = CGAffineTransformMakeScale(1.3, 1.3);
        }
    } completion:^(BOOL finished) {
        cell.hidden = NO;
        [tempView removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
}
@end
