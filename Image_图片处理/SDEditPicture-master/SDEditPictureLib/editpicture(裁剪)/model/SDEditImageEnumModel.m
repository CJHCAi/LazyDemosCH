//
//  SDEditImageEnumModel.m
//  SDEditPicture
//
//  Created by shansander on 2017/7/13.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import "SDEditImageEnumModel.h"

#import "SDEditImageEnumModel.h"

#import "SDEditImageViewModel.h"
#import "AppFileComment.h"

@implementation SDEditImageEnumModel

- (instancetype)init 
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithAction:(SDEditPhotoAction )photoAction
{
    self = [super init];
    if (self) {
        self.photoAction = photoAction;
    }
    return self;
}

- (void)setPhotoAction:(SDEditPhotoAction)photoAction
{
    _photoAction = photoAction;
    [self configMainEnumModel];
}


- (void)configMainEnumModel
{
    switch (self.photoAction) {
        case SDEditPhotoMainReset:
            [self createMainResetModel];
            break;
        case SDEditPhotoMainFilter:
            [self createMainFilterModel];
            break;
        case SDEditPhotoMainCut:
            [self createMainCutModel];
            break;
        case SDEditPhotoMainDecorate:
            [self createMainDecoirateModel];
            break;
        case SDEditPhotoMainGraffiti:
            [self createMainGraffitiModel];
            break;
        case SDEditPhotoFilter:
            [self createMainFilterModel];
            break;
        case SDEditPhotoCut:
            [self createMainCutModel];
            break;
        case SDEditPhotoDecorate:
            [self createDecorateModel];
            break;
        case SDEditPhotoTag:
            [self createTagsModel];
            break;
        case SDEditPhotoBrush:
            [self createBrushModel];
            break;
        case SDEditPhotoEraser:
            [self createEraserModel];
            break;
        default:
            break;
    }
}


- (void)createMainResetModel
{
    self.enumText = @"重置";
}
- (void)createMainFilterModel
{
    self.imageLink = [AppFileComment imagePathStringWithImagename:@"editimagefiltericon@2x"];
    self.enumText = @"滤镜";
}
- (void)createMainCutModel
{
    self.imageLink = [AppFileComment imagePathStringWithImagename:@"editimagecuticon@2x"];
    self.enumText = @"裁剪";
}

- (void)createMainDecoirateModel
{
    
    self.imageLink = [AppFileComment imagePathStringWithImagename:@"editimagedecorationicon@2x"];
    self.enumText = @"装饰";
}

- (void)createMainGraffitiModel
{
    self.imageLink = [AppFileComment imagePathStringWithImagename:@"editimagedrawicon@2x"];
    self.enumText = @"涂鸦";
}

- (void)createDecorateModel
{
    self.imageLink = [AppFileComment imagePathStringWithImagename:@"editimagestickersicon@2x"];
    
    self.enumText = @"贴纸";
}

- (void)createTagsModel
{
    self.imageLink = [AppFileComment imagePathStringWithImagename:@"editimagetagicon@2x"];
    self.enumText = @"标签";
}
- (void)createBrushModel{
    self.imageLink = [AppFileComment imagePathStringWithImagename:@"editimagebrushicon@2x"];
    
    self.enumText = @"画笔";
}
- (void)createEraserModel
{
    self.imageLink = [AppFileComment imagePathStringWithImagename:@"editimageerasericon@2x"];
    
    self.enumText = @"橡皮擦";
}




@end
