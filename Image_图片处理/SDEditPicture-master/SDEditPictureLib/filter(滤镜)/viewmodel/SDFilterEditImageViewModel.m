//
//  SDFilterEditImageViewModel.m
//  SDEditPicture
//
//  Created by shansander on 2017/7/18.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import "SDFilterEditImageViewModel.h"
#import "SDFilterFunctionViewController.h"

#import "SDEditImageEnumModel.h"

#import "SDFilterFunctionModel.h"

#import "InstaFilters.h"

@implementation SDFilterEditImageViewModel

- (instancetype)initWithViewController:(UIViewController * )viewController
{
    self = [super initWithViewController:viewController];
    if (self) {
        [self sd_configViewModel];
    }
    return self;
}

- (SDFilterFunctionViewController * )targetViewcontroller
{
    return (SDFilterFunctionViewController * )self.viewController;
}

- (void)sd_configViewModel
{
    SDFilterFunctionModel * model1 = [[SDFilterFunctionModel alloc] initWithFilterType:SDfilter_None];
    SDFilterFunctionModel * model2 = [[SDFilterFunctionModel alloc] initWithFilterType:SDfilter_1977];
    SDFilterFunctionModel * model3 = [[SDFilterFunctionModel alloc] initWithFilterType:SDfilter_amaro];
    SDFilterFunctionModel * model4 = [[SDFilterFunctionModel alloc] initWithFilterType:SDfilter_brannan];
    SDFilterFunctionModel * model5 = [[SDFilterFunctionModel alloc] initWithFilterType:SDfilter_earlybird];
    SDFilterFunctionModel * model6 = [[SDFilterFunctionModel alloc] initWithFilterType:SDfilter_hefe];
    SDFilterFunctionModel * model7 = [[SDFilterFunctionModel alloc] initWithFilterType:SDfilter_hudson];
    SDFilterFunctionModel * model8 = [[SDFilterFunctionModel alloc] initWithFilterType:SDfilter_inkwell];
    SDFilterFunctionModel * model9 = [[SDFilterFunctionModel alloc] initWithFilterType:SDfilter_lomofi];
    SDFilterFunctionModel * model10 = [[SDFilterFunctionModel alloc] initWithFilterType:SDfilter_LordKelvin];
    SDFilterFunctionModel * model11 = [[SDFilterFunctionModel alloc] initWithFilterType:SDfilter_Nashville];
    SDFilterFunctionModel * model12 = [[SDFilterFunctionModel alloc] initWithFilterType:SDfilter_Normal];
    SDFilterFunctionModel * model13 = [[SDFilterFunctionModel alloc] initWithFilterType:SDfilter_Rise];
    SDFilterFunctionModel * model14 = [[SDFilterFunctionModel alloc] initWithFilterType:SDfilter_Sierra];
    SDFilterFunctionModel * model15 = [[SDFilterFunctionModel alloc] initWithFilterType:SDfilter_Toaster];
    SDFilterFunctionModel * model16 = [[SDFilterFunctionModel alloc] initWithFilterType:SDfilter_Valencia];
    SDFilterFunctionModel * model17 = [[SDFilterFunctionModel alloc] initWithFilterType:SDfilter_Walden];
    SDFilterFunctionModel * model18 = [[SDFilterFunctionModel alloc] initWithFilterType:SDfilter_XproII];

    self.filterList = @[model1,model2,model3,model4,model5,model6,model7,model8,model9,model10,model11,model12,model13,model14,model15,model16,model17,model18];
    [self addRACObserveModel];
    
}
- (void)addRACObserveModel
{
    @weakify_self;
    [self.filterList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SDFilterFunctionModel * filterModel = obj;
        
        [[RACObserve(filterModel, isSelected) distinctUntilChanged] subscribeNext:^(id x) {
            @strongify_self;
            BOOL selected = [x boolValue];
            if (selected) {
                IFImageFilter * imageFilter = [filterModel imageFilter];
                if (imageFilter) {
                    [[self targetViewcontroller] changeImageFilter:imageFilter];
                }else{
                    [[self targetViewcontroller] showOriginImageFilter];
                }

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
            NSLog(@"cancel");
            @strongify_self;
            [[self targetViewcontroller] onCancelAction];
            
        }];
        
    }
    return _cancelModel;
}

- (SDEditImageEnumModel *)filterModel
{
    if (!_filterModel) {
        _filterModel = [[SDEditImageEnumModel alloc] initWithAction:SDEditPhotoFilter];
       
        
    }
    return _filterModel;
}
- (SDEditImageEnumModel *)sureModel
{
    if (!_sureModel) {
        _sureModel = [[SDEditImageEnumModel alloc] initWithAction:SDEditPhotoSure];
        @weakify_self;
        [_sureModel.done_subject subscribeNext:^(id x) {
            NSLog(@"sure ");
            @strongify_self;
            [[self targetViewcontroller] onSureAction];
        }];
    }
    return _sureModel;
}
@end
