//
//  SDFilterFunctionViewController.m
//  SDEditPicture
//
//  Created by shansander on 2017/7/18.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import "SDFilterFunctionViewController.h"
#import "SDRevealView.h"
#import "SDFilterEditImageViewModel.h"
#import "SDFilterEditPhotoControllerItemsView.h"
#import "InstaFilters.h"

@interface SDFilterFunctionViewController ()

@property (nonatomic, strong) SDFilterEditImageViewModel * filterViewModel;

@property (nonatomic, weak) SDRevealView * theRevealView;

@property (nonatomic, weak) SDFilterEditPhotoControllerItemsView * filterFunctionView;

@end

@implementation SDFilterFunctionViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self sd_configData];
    
    [self sd_configView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sd_configData
{
    self.filterViewModel = (SDFilterEditImageViewModel *)[SDFilterEditImageViewModel modelViewController:self];
    self.originImage = self.showImageView;
    
}

- (void)sd_configView
{
    // 展示图片
    self.theRevealView.revealImage = self.showImageView;
    
    // 设置cancel
    self.filterFunctionView.cancelModel = self.filterViewModel.cancelModel;
    // 设置sure
    self.filterFunctionView.sureModel = self.filterViewModel.sureModel;
    // 设置标题
    self.filterFunctionView.filterModel = self.filterViewModel.filterModel;
    
    self.filterFunctionView.filterList = self.filterViewModel.filterList;
    
    
}

- (void)changeImageFilter:(IFImageFilter * )imageFilter
{
    if (imageFilter){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            UIImage * image = [UIImage imageWithCGImage:self.originImage.CGImage];
              self.showImageView = [imageFilter imageByFilteringImage:image];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.showImageView) {
                    self.theRevealView.revealImage = self.showImageView;
                }else{
                    self.theRevealView.revealImage = self.originImage;
                }
            });
        });
    }else{
        NSAssert(false, @"not filter image");
    }
    
}
- (void)showOriginImageFilter
{
    self.theRevealView.revealImage = [UIImage imageWithCGImage:self.originImage.CGImage];
}

- (void)onCancelAction
{
    [self dismissViewControllerAnimated:false completion:^{
        
    }];
}
- (void)onSureAction
{
    [self dismissViewControllerAnimated:false completion:^{
        
    }];
    if (self.diyFinishBlock) {
        self.diyFinishBlock(self.showImageView);
    }
}



#pragma mark - getter
- (SDRevealView *)theRevealView
{
    if (!_theRevealView) {
        SDRevealView * theView = [[SDRevealView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT - MAXSize(466))];
        [self.view addSubview:theView];
        _theRevealView = theView;
    }
    return _theRevealView;
}

- (SDFilterEditPhotoControllerItemsView *)filterFunctionView
{
    if (!_filterFunctionView) {
        SDFilterEditPhotoControllerItemsView * theView = [[SDFilterEditPhotoControllerItemsView alloc] init];
        [self.view addSubview:theView];
        _filterFunctionView = theView;
    }
    return _filterFunctionView;
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
