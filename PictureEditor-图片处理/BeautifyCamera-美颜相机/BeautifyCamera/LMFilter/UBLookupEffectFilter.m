//
//  HBLookupEffectFilter.m
//  BeautifyCamera
//
//  Created by sky on 2017/2/8.
//  Copyright © 2017年 guikz. All rights reserved.
//

#import "UBLookupEffectFilter.h"
#import <GPUImage/GPUImage.h>


@interface UBLookupEffectFilter ()
@property (nonatomic,strong) GPUImagePicture *currentLookupPicture;

@end

@implementation UBLookupEffectFilter
+(instancetype) initWithImage:(UIImage *) image name:(NSString *) name{
    UBLookupEffectFilter * filter = [[UBLookupEffectFilter alloc] init];
    filter.title = name;
    filter.currentLookupPicture = [[GPUImagePicture alloc] initWithImage:image smoothlyScaleOutput:NO];
    
    GPUImageLookupFilter *lookupFilter = [[GPUImageLookupFilter alloc] init];
    [filter.currentLookupPicture addTarget:lookupFilter atTextureLocation:1];
    [filter.currentLookupPicture processImage];
    
    [filter addFilter:lookupFilter];
    filter.initialFilters = @[lookupFilter];
    filter.terminalFilter = lookupFilter;
    
    return filter;
}

-(void)useNextFrameForImageCapture{
    [self.currentLookupPicture processImage];
    [super useNextFrameForImageCapture];
}

+(NSArray *) loadLookupFilter{
    NSMutableArray * array = [NSMutableArray new];
    
    UIImage * image1 = [UIImage imageNamed:@"lookup_amatorka"];
    UBLookupEffectFilter * filter1 = [UBLookupEffectFilter initWithImage:image1 name:@"amatorka"];
//    [filter1 effectIcon];
    filter1.effectIcon = [UIImage imageNamed:filter1.title];
    [array addObject:filter1];
    
    
    UIImage * image2 = [UIImage imageNamed:@"lookup_miss_etikate"];
    UBLookupEffectFilter * filter2 = [UBLookupEffectFilter initWithImage:image2 name:@"etikate"];
//    [filter2 effectIcon];
    filter2.effectIcon = [UIImage imageNamed:filter2.title];
    [array addObject:filter2];
    
    UIImage * image3 = [UIImage imageNamed:@"lookup_soft_elegance_1"];
    UBLookupEffectFilter * filter3 = [UBLookupEffectFilter initWithImage:image3 name:@"eleganceA"];
//    [filter3 effectIcon];
    filter3.effectIcon = [UIImage imageNamed:filter3.title];
    [array addObject:filter3];
    
    
    UIImage * image4 = [UIImage imageNamed:@"lookup_soft_elegance_2"];
    UBLookupEffectFilter * filter4 = [UBLookupEffectFilter initWithImage:image4 name:@"eleganceB"];
//    [filter4 effectIcon];
    filter4.effectIcon = [UIImage imageNamed:filter4.title];
    [array addObject:filter4];
    
    return array;
}

@end
