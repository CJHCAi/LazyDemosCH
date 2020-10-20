//
//  SDDecorateEditImageViewModel.m
//  SDEditPicture
//
//  Created by shansander on 2017/7/25.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import "SDDecorateEditImageViewModel.h"
#import "SDEditImageEnumModel.h"

#import "SDDecorateFunctionViewController.h"

#import "SDDecorateFunctionModel.h"

@implementation SDDecorateEditImageViewModel

- (instancetype)initWithViewController:(UIViewController *)viewController
{
    self = [super initWithViewController:viewController];
    if (self) {
        [self sd_configViewModel];
    }
    return self;
}

- (SDDecorateFunctionViewController *)targetViewController
{
    return (SDDecorateFunctionViewController * )self.viewController;
    
}


- (void)sd_configViewModel
{
    SDDecorateFunctionModel * model0 = [[SDDecorateFunctionModel alloc] initWithFunctionType:SDDecorateFunctionReset];
    
    NSArray * imageList = @[@"sticker_1",@"sticker_2",@"sticker_3",@"sticker_4",@"sticker_5",@"sticker_6",@"sticker_7",@"sticker_8",@"sticker_9",@"sticker_10",@"sticker_11",@"sticker_12",@"sticker_13",@"sticker_14",@"sticker_15",@"sticker_16",@"sticker_17",@"sticker_18",@"sticker_19",@"sticker_20",@"sticker_33"];
    __block NSMutableArray * imageModelList = [[NSMutableArray alloc] init];
    [imageModelList addObject:model0];
    [imageList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString * link = obj;
        SDDecorateFunctionModel * model1 = [[SDDecorateFunctionModel alloc] initWithFunctionType:SDDecorateFunctionImage];
        model1.imageLink = link;
        [imageModelList addObject:model1];
    }];
    
    self.decorateList = [imageModelList copy];
    
    
    SDDecorateFunctionModel * model2 = [[SDDecorateFunctionModel alloc] initWithFunctionType:SDDecorateFunctionImage];
    model2.imageLink = @"editimagelefttagicon@3x";
    @weakify_self;
    [model2.done_subject subscribeNext:^(id x) {
        @strongify_self;
        [[self targetViewController] addTagModelForView:SDDecorationTagRight];
    }];
    
    SDDecorateFunctionModel * model3 = [[SDDecorateFunctionModel alloc] initWithFunctionType:SDDecorateFunctionImage];
    model3.imageLink = @"editimagerighttagicon@3x";
    [model3.done_subject subscribeNext:^(id x) {
        @strongify_self;
        [[self targetViewController] addTagModelForView:SDDecorationTagLeft];
    }];
    
    self.tagList = @[model0,model2,model3];
    
    [self addMonitor];
    
}

- (void)addMonitor
{
    @weakify_self;
    [self.decorateList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SDDecorateFunctionModel * model = obj;
        if (model.decorateType != SDDecorateFunctionReset) {
            [model.done_subject subscribeNext:^(id x) {
                @strongify_self;
                [[self targetViewController] addDecorateModelForView:model];
            }];
        }
    }];
    
   
    
}

- (SDEditImageEnumModel *)cancelModel
{
    if (!_cancelModel) {
        _cancelModel = [[SDEditImageEnumModel alloc] initWithAction:SDEditPhotoCancel];
        @weakify_self;
        [_cancelModel.done_subject subscribeNext:^(id x) {
            @strongify_self;
            [[self targetViewController] onCancelAction];
        }];
    }
    return _cancelModel;
}
- (SDEditImageEnumModel *)sureModel
{
    if (!_sureModel) {
        _sureModel = [[SDEditImageEnumModel alloc] initWithAction:SDEditPhotoSure];
        @weakify_self;
        [_sureModel.done_subject subscribeNext:^(id x) {
            @strongify_self;
            [[self targetViewController] onSureAction];
            
        }];
        
    }
    return _sureModel;
}

- (SDEditImageEnumModel *)decorateModel
{
    if (!_decorateModel) {
        _decorateModel = [[SDEditImageEnumModel alloc] initWithAction:SDEditPhotoDecorate];
        @weakify_self;
        [_decorateModel.done_subject subscribeNext:^(id x) {
            @strongify_self;
            [[self targetViewController] swtichToDecorateController];
        }];
    }
    return _decorateModel;
}

- (SDEditImageEnumModel *)tagModel
{
    if (!_tagModel) {
        _tagModel = [[SDEditImageEnumModel alloc] initWithAction:SDEditPhotoTag];
        @weakify_self;
        [_tagModel.done_subject subscribeNext:^(id x) {
            @strongify_self;
            [[self targetViewController] swtichToTagController];
        }];
    }
    return _tagModel;
}

@end
