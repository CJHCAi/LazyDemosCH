//
//  SDGraffitiEditImageViewModel.m
//  SDEditPicture
//
//  Created by shansander on 2017/7/26.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import "SDGraffitiEditImageViewModel.h"

#import "SDEditImageEnumModel.h"

#import "SDGraffitiFunctionViewController.h"

#import "SDGraffitiResetModel.h"

#import "SDGraffitiSelectedColorModel.h"

#import "SDGraffitiColorModel.h"

#import "SDGraffitiSizeModel.h"



@implementation SDGraffitiEditImageViewModel


- (instancetype)initWithViewController:(UIViewController *)viewController
{
    self = [super initWithViewController:viewController];
    if (self) {
        [self sd_configViewModel];
        
    }
    return self;
}


- (SDGraffitiFunctionViewController *)targetViewController
{
    return (SDGraffitiFunctionViewController *)self.viewController;
}

- (void)sd_configViewModel
{
    self.graffitiResetModel = [[SDGraffitiResetModel alloc] init];
    
    self.graffitiSelectedColorModel = [[SDGraffitiSelectedColorModel alloc] init];
    @weakify_self;
    [self.graffitiSelectedColorModel.done_subject subscribeNext:^(id x) {
        @strongify_self;
        
        [[self targetViewController] showSelectedColorView];
        
    }];
    
    
    SDGraffitiSizeModel * sizemodel0 = [[SDGraffitiSizeModel alloc] initWithSize:MAXSize(20)];
    
    [sizemodel0.done_subject subscribeNext:^(id x) {
        @strongify_self;
        [self targetViewController].drawSize = MAXSize(20);
        
        [self setGraffitiSizeColor:self.graffitiSelectedColorModel.graffitiColor atIndex:0];
    }];
    SDGraffitiSizeModel * sizemodel1 = [[SDGraffitiSizeModel alloc] initWithSize:MAXSize(30)];
    [sizemodel1.done_subject subscribeNext:^(id x) {
        @strongify_self;
        [self targetViewController].drawSize = MAXSize(30);
        [self setGraffitiSizeColor:self.graffitiSelectedColorModel.graffitiColor atIndex:1];

    }];
    SDGraffitiSizeModel * sizemodel2 = [[SDGraffitiSizeModel alloc] initWithSize:MAXSize(40)];
    [sizemodel2.done_subject subscribeNext:^(id x) {
        @strongify_self;
        [self targetViewController].drawSize = MAXSize(40);
        [self setGraffitiSizeColor:self.graffitiSelectedColorModel.graffitiColor atIndex:2];


    }];
    SDGraffitiSizeModel * sizemodel3 = [[SDGraffitiSizeModel alloc] initWithSize:MAXSize(50)];
    [sizemodel3.done_subject subscribeNext:^(id x) {
        @strongify_self;
        [self targetViewController].drawSize = MAXSize(50);
        [self setGraffitiSizeColor:self.graffitiSelectedColorModel.graffitiColor atIndex:3];


    }];
    SDGraffitiSizeModel * sizemodel4 = [[SDGraffitiSizeModel alloc] initWithSize:MAXSize(60)];
    [sizemodel4.done_subject subscribeNext:^(id x) {
        @strongify_self;
        [self targetViewController].drawSize = MAXSize(60);
        [self setGraffitiSizeColor:self.graffitiSelectedColorModel.graffitiColor atIndex:4];

    }];
    
    self.graffiti_size_list = @[sizemodel0,sizemodel1,sizemodel2,sizemodel3,sizemodel4];
    
    
    SDGraffitiColorModel * colorModel0 = [[SDGraffitiColorModel alloc] initWithColor:[UIColor colorWithHexRGB:0xff1744]];
    [colorModel0.done_subject subscribeNext:^(id x) {
        @strongify_self;
        self.graffitiSelectedColorModel.graffitiColor = colorModel0.graffitiColor;
        
        [self targetViewController].drawColor = colorModel0.graffitiColor;
        
        [self setGraffitiSizeColor:self.graffitiSelectedColorModel.graffitiColor atIndex:self.graffitiSelectedColorModel.graffitiIndex];

    }];
    SDGraffitiColorModel * colorModel1 = [[SDGraffitiColorModel alloc] initWithColor:[UIColor colorWithHexRGB:0xff3d00]];
    [colorModel1.done_subject subscribeNext:^(id x) {
        @strongify_self;
        self.graffitiSelectedColorModel.graffitiColor = colorModel1.graffitiColor;
        [self targetViewController].drawColor = colorModel1.graffitiColor;
        
        [self setGraffitiSizeColor:self.graffitiSelectedColorModel.graffitiColor atIndex:self.graffitiSelectedColorModel.graffitiIndex];

    }];
    SDGraffitiColorModel * colorModel2 = [[SDGraffitiColorModel alloc] initWithColor:[UIColor colorWithHexRGB:0xffc400]];
    [colorModel2.done_subject subscribeNext:^(id x) {
        @strongify_self;
        self.graffitiSelectedColorModel.graffitiColor = colorModel2.graffitiColor;
        [self targetViewController].drawColor = colorModel2.graffitiColor;
        [self setGraffitiSizeColor:self.graffitiSelectedColorModel.graffitiColor atIndex:self.graffitiSelectedColorModel.graffitiIndex];

    }];
    SDGraffitiColorModel * colorModel3 = [[SDGraffitiColorModel alloc] initWithColor:[UIColor colorWithHexRGB:0x00e5ff]];
    [colorModel3.done_subject subscribeNext:^(id x) {
        @strongify_self;
        self.graffitiSelectedColorModel.graffitiColor = colorModel3.graffitiColor;
        [self targetViewController].drawColor = colorModel3.graffitiColor;
        [self setGraffitiSizeColor:self.graffitiSelectedColorModel.graffitiColor atIndex:self.graffitiSelectedColorModel.graffitiIndex];

    }];
    SDGraffitiColorModel * colorModel4 = [[SDGraffitiColorModel alloc] initWithColor:[UIColor colorWithHexRGB:0x3d5afe]];
    [colorModel4.done_subject subscribeNext:^(id x) {
        @strongify_self;
        self.graffitiSelectedColorModel.graffitiColor = colorModel4.graffitiColor;
        [self targetViewController].drawColor = colorModel4.graffitiColor;
        [self setGraffitiSizeColor:self.graffitiSelectedColorModel.graffitiColor atIndex:self.graffitiSelectedColorModel.graffitiIndex];

    }];
    SDGraffitiColorModel * colorModel5 = [[SDGraffitiColorModel alloc] initWithColor:[UIColor colorWithHexRGB:0xffffff]];
    [colorModel5.done_subject subscribeNext:^(id x) {
        @strongify_self;
        self.graffitiSelectedColorModel.graffitiColor = colorModel5.graffitiColor;
        [self targetViewController].drawColor = colorModel5.graffitiColor;
        [self setGraffitiSizeColor:self.graffitiSelectedColorModel.graffitiColor atIndex:self.graffitiSelectedColorModel.graffitiIndex];

    }];
    self.graffiti_color_list = @[colorModel0,colorModel1,colorModel2,colorModel3,colorModel4,colorModel5];
    self.graffitiSelectedColorModel.graffitiColor = colorModel0.graffitiColor;

    self.graffitiSelectedColorModel.graffitiIndex = 0;
    
    
    [self setGraffitiSizeColor:self.graffitiSelectedColorModel.graffitiColor atIndex:self.graffitiSelectedColorModel.graffitiIndex];
}

- (void)sd_configGraffitiColor
{
}


- (void)setGraffitiSizeColor:(UIColor *)color atIndex:(NSInteger)index
{
    
    self.graffitiSelectedColorModel.graffitiIndex = index;
    
    [self.graffiti_size_list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SDGraffitiSizeModel * model = obj;
        if (idx == index) {
            model.graffitiColor = color;
           
        }else{
            [model defineGraffitiColor];
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

- (SDEditImageEnumModel *)brushModel
{
    if (!_brushModel) {
        _brushModel = [[SDEditImageEnumModel alloc] initWithAction:SDEditPhotoBrush];
        @weakify_self;
        [_brushModel.done_subject subscribeNext:^(id x) {
            @strongify_self;
            [[self targetViewController] showSelectedbrushView];
        }];
    }
    return _brushModel;
}
- (SDEditImageEnumModel *)eraserModel
{
    if (!_eraserModel) {
        _eraserModel = [[SDEditImageEnumModel alloc] initWithAction:SDEditPhotoEraser];
        @weakify_self;
        [_eraserModel.done_subject subscribeNext:^(id x) {
            @strongify_self;
            [[self targetViewController] showSelectedEraserView];
        }];
        
    }
    return _eraserModel;
}

@end
