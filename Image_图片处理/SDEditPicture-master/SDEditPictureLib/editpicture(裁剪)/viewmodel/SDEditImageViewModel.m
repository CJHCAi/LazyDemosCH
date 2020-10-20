//
//  SDEditImageViewModel.m
//  SDEditPicture
//
//  Created by shansander on 2017/7/13.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import "SDEditImageViewModel.h"

#import "SDEditRichImageViewController.h"

#import "SDEditImageEnumModel.h"

@implementation SDEditImageViewModel

- (instancetype)initWithViewController:(UIViewController *)viewController
{
    self = [super initWithViewController:viewController];
    if (self) {
        
    }
    return self;
}

- (SDEditRichImageViewController * )targetViewController
{
    return (SDEditRichImageViewController * )self.viewController;
}

- (NSArray * )getEditEnumListByModel:(NSString * )model
{
    if (self.editInfo[model]) {
        return self.editInfo[model];
    }else{
        if ([model isEqualToString:KEditPhotoMain]) {
            NSArray * list = [self createMianEditEnumList];
            self.editInfo[model] = list;
            return list;
        }
    }
    return nil;
}

- (NSArray * )createMianEditEnumList
{
    
    @weakify_self;
    SDEditImageEnumModel * enum0 = [[SDEditImageEnumModel alloc] initWithAction:SDEditPhotoMainReset];
    
    [enum0.done_subject subscribeNext:^(SDEditImageEnumModel * x) {
        NSLog(@"reset");
    }];
    
    SDEditImageEnumModel * enum1 = [[SDEditImageEnumModel alloc] initWithAction:SDEditPhotoMainFilter];
    
    [enum1.done_subject subscribeNext:^(SDEditImageEnumModel * x) {
        NSLog(@"filter");
        @strongify_self;
        [[self targetViewController] pushFilterViewController];
        
    }];
    
    SDEditImageEnumModel * enum2 = [[SDEditImageEnumModel alloc] initWithAction:SDEditPhotoMainCut];
    
    [enum2.done_subject subscribeNext:^(SDEditImageEnumModel * x) {
        NSLog(@"cut");
        @strongify_self;
        [[self targetViewController] pushCutViewController];
    }];
    
    SDEditImageEnumModel * enum3 = [[SDEditImageEnumModel alloc] initWithAction:SDEditPhotoMainDecorate];
    [enum3.done_subject subscribeNext:^(SDEditImageEnumModel * x) {
        NSLog(@"decorate");
        @strongify_self;
        [[self targetViewController] pushDecorateViewController];
    }];
    SDEditImageEnumModel * enum4 = [[SDEditImageEnumModel alloc] initWithAction:SDEditPhotoMainGraffiti];
    [enum4.done_subject subscribeNext:^(SDEditImageEnumModel * x) {
        NSLog(@"graffiti");
        @strongify_self;
        [[self targetViewController] pushGraffitiViewController];
        
        
    }];
    return @[enum0,enum1,enum2,enum3,enum4];
}



- (NSMutableDictionary *)editInfo
{
    if (!_editInfo) {
        _editInfo = [[NSMutableDictionary alloc] init];
    }
    return _editInfo;
}

@end
