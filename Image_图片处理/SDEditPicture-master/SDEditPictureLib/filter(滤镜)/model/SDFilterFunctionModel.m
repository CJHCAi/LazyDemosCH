//
//  SDFilterFunctionModel.m
//  SDEditPicture
//
//  Created by shansander on 2017/7/18.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import "SDFilterFunctionModel.h"

#import "InstaFilters.h"

@implementation SDFilterFunctionModel

@synthesize imageFilter = _imageFilter;

- (instancetype)initWithFilterType:(SDFilterFunctionType)functionType
{
    self = [super init];
    if (self) {
        _functionType = functionType;
        
        [self displayFilterType];
        
        self.isSelected = false;
        
    }
    return self;
}



- (void)displayFilterType
{
    switch (self.functionType) {
        case SDfilter_1977:
            self.filterImageLink = @"camerasdk_filter_in1977@2x";
            self.filterTitle = @"创新";
            break;
        case SDfilter_amaro:
            self.filterImageLink = @"camerasdk_filter_amaro@2x";
            self.filterTitle = @"流年";
            break;
            
        case SDfilter_brannan:
            self.filterImageLink = @"camerasdk_filter_brannan@2x";
            self.filterTitle = @"淡雅";
            break;
        case SDfilter_earlybird:
            self.filterImageLink = @"camerasdk_filter_early_bird@2x";
            self.filterTitle = @"怡尚";
            break;
        case SDfilter_hefe:
            self.filterImageLink = @"camerasdk_filter_hefe@2x";
            self.filterTitle = @"优格";
            break;
        case SDfilter_hudson:
            self.filterImageLink = @"camerasdk_filter_hudson@2x";
            self.filterTitle = @"胶片";
            break;
        case SDfilter_inkwell:
            self.filterImageLink = @"camerasdk_filter_inkwell@2x";
            self.filterTitle = @"黑白";
            break;
        case SDfilter_lomofi:
            self.filterImageLink = @"camerasdk_filter_lomo@2x";
            self.filterTitle = @"个性";
            break;
        case SDfilter_LordKelvin:
            self.filterImageLink = @"camerasdk_filter_lord_kelvin@2x";
            self.filterTitle = @"回忆";
            break;
        case SDfilter_Nashville:
            self.filterImageLink = @"camerasdk_filter_nashville@2x";
            self.filterTitle = @"不羁";
            break;
        case SDfilter_Normal:
            self.filterImageLink = @"camerasdk_filter_normal@2x";
            self.filterTitle = @"森系";
            break;
        case SDfilter_Rise:
            self.filterImageLink = @"camerasdk_filter_rise@2x";
            self.filterTitle = @"清晰";
            break;
        case SDfilter_Sierra:
            self.filterImageLink = @"camerasdk_filter_sierra@2x";
            self.filterTitle = @"摩登";
            break;
        case SDfilter_Toaster:
            self.filterImageLink = @"camerasdk_filter_toaster@2x";
            self.filterTitle = @"绚丽";
            break;
        case SDfilter_Valencia:
            self.filterImageLink = @"camerasdk_filter_valencia@2x";
            self.filterTitle = @"优雅";
            break;
        case SDfilter_Walden:
            self.filterImageLink = @"camerasdk_filter_walden@2x";
            self.filterTitle = @"日系";
            break;
        case SDfilter_XproII:
            self.filterImageLink = @"camerasdk_filter_xproii@2x";
            self.filterTitle = @"新潮";
            break;
        default:
            self.filterImageLink = @"";
            self.filterTitle = @"无";
            break;
    }
}


- (IFImageFilter *)imageFilter
{
    if (!_imageFilter) {
        switch (self.functionType) {
            case SDfilter_1977:
                _imageFilter = [[IF1977Filter alloc] init];
                break;
            case SDfilter_amaro:
                _imageFilter = [[IFAmaroFilter alloc] init];
                break;
                
            case SDfilter_brannan:
                _imageFilter = [[IFBrannanFilter alloc] init];
                break;
            case SDfilter_earlybird:
                _imageFilter = [[IFEarlybirdFilter alloc] init];
                break;
            case SDfilter_hefe:
                _imageFilter = [[IFHefeFilter alloc] init];
                break;
            case SDfilter_hudson:
                _imageFilter = [[IFHudsonFilter alloc] init];
                break;
            case SDfilter_inkwell:
                _imageFilter = [[IFInkwellFilter alloc] init];
                break;
            case SDfilter_lomofi:
                _imageFilter = [[IFLomofiFilter alloc] init];
                break;
            case SDfilter_LordKelvin:
                _imageFilter = [[IFLordKelvinFilter alloc] init];
                break;
            case SDfilter_Nashville:
                _imageFilter = [[IFNashvilleFilter alloc] init];
                break;
            case SDfilter_Normal:
                _imageFilter = [[IFNormalFilter alloc] init];
                break;
            case SDfilter_Rise:
                _imageFilter = [[IFRiseFilter alloc] init];
                break;
            case SDfilter_Sierra:
                _imageFilter = [[IFSierraFilter alloc] init];
                break;
            case SDfilter_Toaster:
                _imageFilter = [[IFToasterFilter alloc] init];
                break;
            case SDfilter_Valencia:
                _imageFilter = [[IFValenciaFilter alloc] init];
                break;
            case SDfilter_Walden:
                _imageFilter = [[IFWaldenFilter alloc] init];
                break;
            case SDfilter_XproII:
                _imageFilter = [[IFXproIIFilter alloc] init];
                break;
            default:
                self.filterImageLink = @"";
                self.filterTitle = @"无";
                _imageFilter = nil;
                break;
        }
    }
    return _imageFilter;
}


@end
