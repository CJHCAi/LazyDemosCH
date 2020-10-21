

//  http://www.cnblogs.com/yingkong1987/archive/2013/03/18/2965278.html//

#import "LMCameraFilters.h"


#import "LMBeautifyFilter.h"


// 饱和度filter
@interface LMSaturationFilterGroup : LMFilterGroup
@property (nonatomic) GPUImageSaturationFilter *filter;
@end

@implementation LMSaturationFilterGroup

-(instancetype) init{
    self = [super init];
    if (self) {
        //saturation: The degree of saturation or desaturation to apply to the image (0.0 - 2.0, with 1.0 as the default)
        self.filter = [[GPUImageSaturationFilter alloc] init]; //饱和度
        self.filter.saturation = 2.0f;
        [self setInitialFilters:@[self.filter]];
        [self setTerminalFilter:self.filter];
    }
    return self;
}

-(CGFloat)combiIntensity{
    return self.filter.saturation /2.0f;
}

-(void) setCombiIntensity:(CGFloat)combiIntensity{
    self.filter.saturation = combiIntensity * 2.0f;
}

@end

@interface LMExposureFilterGroup : LMFilterGroup
@property (nonatomic) GPUImageExposureFilter *filter;
@end

@implementation LMExposureFilterGroup

-(instancetype) init{
    self = [super init];
    if (self) {
        //  exposure: The adjusted exposure (-10.0 - 10.0, with 0.0 as the default)
        self.filter = [[GPUImageExposureFilter alloc] init]; //曝光
        self.filter.exposure = 0.5f;
        [self setInitialFilters:@[self.filter]];
        [self setTerminalFilter:self.filter];
    }
     return self;
}

-(CGFloat)combiIntensity{
    return (self.filter.exposure +2)/4.0f;
}

-(void) setCombiIntensity:(CGFloat)combiIntensity{
    self.filter.exposure = combiIntensity * 4.0f - 2.0f;
}

@end

@interface LMContrastFilterGroup : LMFilterGroup
@property (nonatomic) GPUImageContrastFilter *filter;
@end

@implementation LMContrastFilterGroup

-(instancetype) init{
    self = [super init];
    if (self) {
        //  contrast: The adjusted contrast (0.0 - 4.0, with 1.0 as the default)
        self.filter = [[GPUImageContrastFilter alloc] init]; //对比度
        self.filter.contrast = 2.0f;
        [self setInitialFilters:@[self.filter]];
        [self setTerminalFilter:self.filter];
    }
     return self;
}

-(CGFloat)combiIntensity{
    return self.filter.contrast /4.0f;
}

-(void) setCombiIntensity:(CGFloat)combiIntensity{
    self.filter.contrast = combiIntensity * 4.0f;
}

@end


@interface LMTestFilterGroup : LMFilterGroup
@property (nonatomic) GPUImageExposureFilter *filterA;
@property (nonatomic) GPUImageSaturationFilter *filterB;
@property (nonatomic) GPUImageContrastFilter *filterC;
@end

@implementation LMTestFilterGroup

-(instancetype) init{
    self = [super init];
    if (self) {
        self.filterA = [[GPUImageExposureFilter alloc] init];
        self.filterA.exposure = 0.0f;
        self.filterB = [[GPUImageSaturationFilter alloc] init];
        self.filterB.saturation = 2.0f;
        self.filterC = [[GPUImageContrastFilter alloc] init];
        self.filterC.contrast = 2.0f;
        
        [self.filterA addTarget:self.filterB];
        [self.filterB addTarget:self.filterC];
        
        [self setInitialFilters:@[self.filterA]];
        [self setTerminalFilter:self.filterC];
    }
     return self;
}

-(CGFloat)combiIntensity{
    return self.filterC.contrast /4.0f;
}

-(void) setCombiIntensity:(CGFloat)combiIntensity{
    self.filterC.contrast = combiIntensity * 4.0f;
}

@end


@implementation LMCameraFilters

+ (LMFilterGroup *)normal {
    GPUImageFilter *filter = [[GPUImageFilter alloc] init]; //默认
    LMFilterGroup *group = [[LMFilterGroup alloc] init];
    [(GPUImageFilterGroup *) group setInitialFilters:[NSArray arrayWithObject: filter]];
    [(GPUImageFilterGroup *) group setTerminalFilter:filter];
    group.title = @"正常";

//    [group effectIcon];
    group.effectIcon = [UIImage imageNamed:@"normal"];

    return group;
}

+ (LMFilterGroup *)saturation {
    LMSaturationFilterGroup *group = [[LMSaturationFilterGroup alloc] init]; //饱和度
    group.title = @"饱和度";

//    [group effectIcon];
    group.effectIcon = [UIImage imageNamed:@"saturation"];
    return group;
}

+ (LMFilterGroup *)exposure {
    LMExposureFilterGroup *group = [[LMExposureFilterGroup alloc] init];
    group.title = @"曝光";

//    [group effectIcon];
     group.effectIcon = [UIImage imageNamed:@"exposure"];
    return group;
}

+ (LMFilterGroup *)contrast {
    LMContrastFilterGroup *group = [[LMContrastFilterGroup alloc] init];
    group.title = @"对比度";

//    [group effectIcon];
    group.effectIcon = [UIImage imageNamed:@"contrast"];

    return group;
}

+ (LMFilterGroup *)testGroup1 {
    LMTestFilterGroup *group = [[LMTestFilterGroup alloc] init];
    group.title = @"组合";

//    [group effectIcon];
    group.effectIcon = [UIImage imageNamed:@"testGroup1"];
    return group;
}

+ (LMFilterGroup *)beautyGroup{
    LMBeautifyFilter *group =  [[LMBeautifyFilter alloc] init];
    group.title = @"美肤";

//    [group effectIcon];
    group.effectIcon = [UIImage imageNamed:@"beautyGroup"];

    return  group;
}

@end
