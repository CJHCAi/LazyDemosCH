//
//  ImageFilterScrollView.m
//  LuoChang
//
//  Created by Rick on 15/9/14.
//  Copyright (c) 2015年 Rick. All rights reserved.
//

#import "ImageFilterScrollView.h"
#import "ImageFilterItem.h"
#import "UIImage+Utils.h"

@implementation ImageFilterScrollView 

-(instancetype)initWithImage:(UIImage *)originalImage{
    self = [super init];
    if (self) {
        self.itemImageArray = [NSMutableArray array];
        UIImage *iconThumbnail = [originalImage aspectFill:CGSizeMake(50*[[UIScreen mainScreen] scale], 50*[[UIScreen mainScreen] scale])];
        self.contentSize = CGSizeMake(100*self.filterNamesArray.count-10, 111);
        for (NSInteger i = 0 ; i<_filterNamesArray.count; i++) {
            NSDictionary *dict = _filterNamesArray[i];
            NSDictionary *filterDict = [dict allValues].firstObject;
            //                NSString *filterNameValue = filterDict[@"name"];
            NSString *filterTitle = filterDict[@"title"];
            NSString *filterNameKey = [dict allKeys].firstObject;
            ImageFilterItem *btnItem = [[ImageFilterItem alloc]init];
            btnItem.filterDict = dict;
            btnItem.frame = CGRectMake(i*100, 0, 100, 111);
            btnItem.imageView.layer.borderWidth = 1.0f;
            btnItem.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
            btnItem.backgroundColor = RGB(235, 237, 237);
            btnItem.titleLabel.text = filterTitle;
            btnItem.delegate = self;
            [self.itemImageArray addObject:btnItem];
            [self addSubview:btnItem];
            if (i==0) {
                btnItem.iconImage = [iconThumbnail copy];
                [btnItem setIconImage:[iconThumbnail copy]];
            }else{
                if (btnItem.iconImage == nil) {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        UIImage *iconImage = [UIImage filteredImage:iconThumbnail withFilterName:filterNameKey];
                        [btnItem performSelectorOnMainThread:@selector(setIconImage:) withObject:iconImage waitUntilDone:NO];
                    });
                }
            }
            
        }

    }
    return self;
}

-(NSArray *)filterNamesArray{
    if (!_filterNamesArray) {
        NSMutableArray *filterArray = [NSMutableArray array];
        NSDictionary *dict0 = @{@"NONE":@{@"name":@"None",@"title":@"无"}};
        NSDictionary *dict1 = @{@"CISRGBToneCurveToLinear":@{@"name":@"Linear",@"title":@"诺坎普瑰丽"}};
        NSDictionary *dict2 = @{@"CIVignetteEffect":@{@"name":@"Effect",@"title":@"梅阿查冷艳"}};
        NSDictionary *dict3 = @{@"CIPhotoEffectInstant":@{@"name":@"Instant",@"title":@"安菲尔德红"}};
        NSDictionary *dict4 = @{@"CIPhotoEffectProcess":@{@"name":@"Process",@"title":@"蓝桥魔幻"}};
        NSDictionary *dict5 = @{@"CIPhotoEffectTransfer":@{@"name":@"Transfer",@"title":@"伯纳乌动感"}};
        NSDictionary *dict6 = @{@"CISepiaTone":@{@"name":@"Tone",@"title":@"怀旧圣西罗"}};
        NSDictionary *dict7 = @{@"CIPhotoEffectChrome":@{@"name":@"Chrome",@"title":@"白鹿巷净白"}};
        NSDictionary *dict8 = @{@"CIPhotoEffectFade":@{@"name":@"Fade",@"title":@"阿尔陴淡雅"}};
        NSDictionary *dict9 = @{@"CILinearToSRGBToneCurve":@{@"name":@"Curve",@"title":@"天体热浪"}};
        NSDictionary *dict10 = @{@"CIPhotoEffectTonal":@{@"name":@"Tonal",@"title":@"埃兰路记忆"}};
        NSDictionary *dict11 = @{@"CIPhotoEffectNoir":@{@"name":@"Noir",@"title":@"情歌古典"}};
        //    NSDictionary *dict12 = @{@"CIPhotoEffectMono":@{@"name":@"Mono",@"title":@"Mono"}};
        //    NSDictionary *dict13 = @{@"CIColorInvert":@{@"name":@"Invert",@"title":@"Invert"}};
        [filterArray  addObject:dict0];
        [filterArray  addObject:dict1];
        [filterArray  addObject:dict2];
        [filterArray  addObject:dict3];
        [filterArray  addObject:dict4];
        [filterArray  addObject:dict5];
        [filterArray  addObject:dict6];
        [filterArray  addObject:dict7];
        [filterArray  addObject:dict8];
        [filterArray  addObject:dict9];
        [filterArray  addObject:dict10];
        [filterArray  addObject:dict11];
        //    [_filterNamesArray  addObject:dict12];
        //    [_filterNamesArray  addObject:dict13];
        _filterNamesArray = [filterArray copy];
    }
    return _filterNamesArray;
}


-(void)imageFilterItemClick:(ImageFilterItem *)itemView filterDict:(NSDictionary *)filterDict{
    if ([self.imageFilterItemdelegate respondsToSelector:@selector(imageFilterItemClick:filterDict:)]) {
        [self.imageFilterItemdelegate imageFilterItemClick:itemView filterDict:filterDict];
    }
}

@end
