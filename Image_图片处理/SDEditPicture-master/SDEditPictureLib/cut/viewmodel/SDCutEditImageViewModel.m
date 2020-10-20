//
//  SDCutEditImageViewModel.m
//  SDEditPicture
//
//  Created by shansander on 2017/7/25.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import "SDCutEditImageViewModel.h"

#import "SDCutFunctionViewController.h"

#import "SDEditImageEnumModel.h"

#import "SDCutFunctionModel.h"

@implementation SDCutEditImageViewModel

- (instancetype)initWithViewController:(UIViewController *)viewController
{
    self = [super initWithViewController:viewController];
    if (self) {
        [self sd_configViewModel];
    }
    return self;
}

- (SDCutFunctionViewController *)cutViewController
{
    return (SDCutFunctionViewController *)self.viewController;
}

- (void)sd_configViewModel
{
    SDCutFunctionModel * model1 = [[SDCutFunctionModel alloc] initWithFunctionModel:SDCutFunctionReset];
    SDCutFunctionModel * model2 = [[SDCutFunctionModel alloc] initWithFunctionModel:SDCutFunctionFree];
    model2.isSelected = YES;
    SDCutFunctionModel * model3 = [[SDCutFunctionModel alloc] initWithFunctionModel:SDCutFunction1_1];
    SDCutFunctionModel * model4 = [[SDCutFunctionModel alloc] initWithFunctionModel:SDCutFunction16_9];
    SDCutFunctionModel * model5 = [[SDCutFunctionModel alloc] initWithFunctionModel:SDCutFunction3_2];
    SDCutFunctionModel * model6 = [[SDCutFunctionModel alloc] initWithFunctionModel:SDCutFunction4_3];
    SDCutFunctionModel * model7 = [[SDCutFunctionModel alloc] initWithFunctionModel:SDCutFunction5_4];
    
    self.cutList = @[model1,model2,model3,model4,model5,model6,model7];
    
    
    [self addMonitor];
    
}


- (void)addMonitor
{
    @weakify_self;
    [self.cutList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SDCutFunctionModel * model = obj;
    
        [[RACObserve(model, isSelected) distinctUntilChanged] subscribeNext:^(id x) {
            @strongify_self;
            BOOL selected = [x boolValue];
            if (selected) {
                [self cutViewController].aspectRatioPreset = model.cutModel;
            }
        }];
        
    }];
}


- (SDEditImageEnumModel *)cancelModel
{
    if (!_cancelModel) {
        _cancelModel = [[SDEditImageEnumModel alloc] initWithAction:SDEditPhotoCancel];
        @weakify_self;
        [_cancelModel.done_subject subscribeNext:^(id x) {
            @strongify_self;
            [[self cutViewController] onCancelAction];
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
            [[self cutViewController] onSureAction];
        }];
    }
    return _sureModel;
}

- (SDEditImageEnumModel *)cutModel
{
    if (!_cutModel) {
        _cutModel = [[SDEditImageEnumModel alloc] initWithAction:SDEditPhotoCut];
    }
    return _cutModel;
}

@end
