//
//  LMHahaFilters.m
//  BeautifyCamera
//
//  Created by sky on 2017/2/14.
//  Copyright © 2017年 guikz. All rights reserved.
//

#import "LMHahaFilters.h"

// 哈哈镜filter
@interface LMVignetteFilterGroup : LMFilterGroup
@property (nonatomic) GPUImageVignetteFilter *filter;
@end

@implementation LMVignetteFilterGroup

-(instancetype) init{
    self = [super init];
    if (self) {
        self.filter =  [[GPUImageVignetteFilter alloc] init];
        self.initialFilters= @[self.filter];
        self.terminalFilter = self.filter;
    }
    return self;
}
@end

@interface LMSwirlFilterGroup : LMFilterGroup
@property (nonatomic) GPUImageSwirlFilter *filter;
@end

@implementation LMSwirlFilterGroup

-(instancetype) init{
    self = [super init];
    if (self) {
        self.filter =  [[GPUImageSwirlFilter alloc] init];
        self.filter.radius = 0.2;
        self.filter.angle = 0.3;
        self.initialFilters= @[self.filter];
        self.terminalFilter = self.filter;
    }
    return self;
}
@end

@interface LMBulgeDistortionlFilterGroup : LMFilterGroup
@property (nonatomic) GPUImageBulgeDistortionFilter *filter;
@end

@implementation LMBulgeDistortionlFilterGroup

-(instancetype) init{
    self = [super init];
    if (self) {
        self.filter =  [[GPUImageBulgeDistortionFilter alloc] init];
        self.initialFilters= @[self.filter];
        self.terminalFilter = self.filter;
    }
    return self;
}
@end

@interface LMPinchDistortionlFilterGroup : LMFilterGroup
@property (nonatomic) GPUImagePinchDistortionFilter *filter;
@end

@implementation LMPinchDistortionlFilterGroup

-(instancetype) init{
    self = [super init];
    if (self) {
        self.filter =  [[GPUImagePinchDistortionFilter alloc] init];
        self.initialFilters= @[self.filter];
        self.terminalFilter = self.filter;
    }
    return self;
}
@end

@interface LMStretchDistortionFilterGroup : LMFilterGroup
@property (nonatomic) GPUImageStretchDistortionFilter *filter;
@end

@implementation LMStretchDistortionFilterGroup

-(instancetype) init{
    self = [super init];
    if (self) {
        self.filter =  [[GPUImageStretchDistortionFilter alloc] init];
        self.initialFilters= @[self.filter];
        self.terminalFilter = self.filter;
    }
    return self;
}
@end

@interface LMGlassSphereFilterGroup : LMFilterGroup
@property (nonatomic) GPUImageGlassSphereFilter *filter;
@end

@implementation LMGlassSphereFilterGroup

-(instancetype) init{
    self = [super init];
    if (self) {
        self.filter =  [[GPUImageGlassSphereFilter alloc] init];
        self.filter.radius = 0.5;
        self.initialFilters= @[self.filter];
        self.terminalFilter = self.filter;
    }
    return self;
}
@end

@interface LMSphereRefractionFilterGroup : LMFilterGroup
@property (nonatomic) GPUImageSphereRefractionFilter *filter;
@end

@implementation LMSphereRefractionFilterGroup

-(instancetype) init{
    self = [super init];
    if (self) {
        self.filter =  [[GPUImageSphereRefractionFilter alloc] init];
        self.filter.radius = 0.5;
        self.initialFilters= @[self.filter];
        self.terminalFilter = self.filter;
    }
    return self;
}
@end

@implementation LMHahaFilters
+(LMFilterGroup *)  vignetteGroup{
    LMVignetteFilterGroup * group = [[LMVignetteFilterGroup alloc] init];
    group.title = @"晕影";
//    [group effectIcon];
    group.effectIcon = [UIImage imageNamed:@"shadow"];
    
    return group;
}

+(LMFilterGroup *)  swirlGroup{
    LMSwirlFilterGroup * group = [[LMSwirlFilterGroup alloc] init];
    group.title = @"漩涡";
//    [group effectIcon];
    group.effectIcon = [UIImage imageNamed:@"swirl"];
    
    return group;
}
+(LMFilterGroup *)  bulgeDistortionGroup{
    LMBulgeDistortionlFilterGroup * group = [[LMBulgeDistortionlFilterGroup alloc] init];
    group.title = @"鱼眼";
//    [group effectIcon];
    group.effectIcon = [UIImage imageNamed:@"bulge"];
    
    return group;
}

+(LMFilterGroup *)  pinchDistortionGroup{
    LMPinchDistortionlFilterGroup * group = [[LMPinchDistortionlFilterGroup alloc] init];
    group.title = @"凹镜";
//    [group effectIcon];
    group.effectIcon = [UIImage imageNamed:@"pinch"];
    
    return group;
}

+(LMFilterGroup *)  stretchDistortionGroup{
    LMStretchDistortionFilterGroup * group = [[LMStretchDistortionFilterGroup alloc] init];
    group.title = @"哈哈镜";
//    [group effectIcon];
    group.effectIcon = [UIImage imageNamed:@"haha"];
    
    return group;
}

+(LMFilterGroup *)  glassSphereGroup{
    LMGlassSphereFilterGroup * group = [[LMGlassSphereFilterGroup alloc] init];
    group.title = @"水晶球";
//    [group effectIcon];
    group.effectIcon = [UIImage imageNamed:@"sphere"];
    
    return group;
}

+(LMFilterGroup *)  sphereRefractionGroup{
    LMSphereRefractionFilterGroup * group = [[LMSphereRefractionFilterGroup alloc] init];
    group.title = @"球形倒立";
//    [group effectIcon];
    group.effectIcon = [UIImage imageNamed:@"resphere"];
    
    return group;
}

@end
