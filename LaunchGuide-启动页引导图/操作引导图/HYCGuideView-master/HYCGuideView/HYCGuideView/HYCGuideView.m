//
//  GuideView.m
//  手图封装
//
//  Created by hyc on 2018/1/11.
//  Copyright © 2018年 hyc. All rights reserved.
//

#import "HYCGuideView.h"
@interface HYCGuideView()
@property (nonatomic,assign)NSInteger page;
@property (nonatomic,copy)NSArray <NSDictionary *>*ImageNameObject;
@property (nonatomic,assign)BOOL isDEBUG;
@property (nonatomic,strong)UIView *selfName;
@end
@implementation HYCGuideView

- (instancetype)initWithaddGuideViewOnWindowImageObject:(NSArray <NSDictionary *>*)ImageNameObject isDEBUG:(BOOL)isDEBUG
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.isDEBUG = isDEBUG;
        self.selfName = self;
        [self addGuideViewOnWindowImageObject:ImageNameObject];
        
        
    }
    return self.selfName?self:nil;
}
- (void)addGuideViewOnWindowImageObject:(NSArray <NSDictionary *>*)ImageNameObject{
    
    
    
    self.ImageNameObject = ImageNameObject;
    if (self.page < ImageNameObject.count) {
        NSValue * frameValue = (NSValue *)(ImageNameObject[self.page][@"frame"]);
        frameValue = frameValue ? : [NSValue valueWithCGRect:[UIScreen mainScreen].bounds];
        [self addOneGuideViewImageName:ImageNameObject[self.page][@"image"] andFrame:frameValue.CGRectValue andBGColor:ImageNameObject[self.page][@"color"] ? : [[UIColor blackColor] colorWithAlphaComponent:0.8] andImageNameObject:ImageNameObject];
    }else{
        self.selfName = nil;
        [self removeFromSuperview];
    }
}

- (void)addOneGuideViewImageName:(NSString *)ImageName andFrame:(CGRect)ImageFrame andBGColor:(UIColor *)BGColor andImageNameObject:(NSArray <NSDictionary *>*)ImageNameObject{
    
    if (self.isDEBUG){
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:[NSString stringWithFormat:@"HYC_%@_%@_HYC",ImageName,[[NSBundle mainBundle] bundleIdentifier]]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if (![[NSUserDefaults standardUserDefaults] boolForKey:
         [NSString stringWithFormat:@"HYC_%@_%@_HYC",ImageName,[[NSBundle mainBundle] bundleIdentifier]]
         ]) {
        UIView *view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        
        view.backgroundColor = BGColor;
        
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:ImageFrame];
        
        if (!ImageName.length) [self removeFromSuperview];
        
        [imageV setImage:[UIImage imageNamed:ImageName]];
        [view addSubview:imageV];
        view.userInteractionEnabled = YES;
        
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClick:)]];
        [[UIApplication sharedApplication].keyWindow addSubview:view];
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:view];
        
        //添加手图为yes
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"HYC_%@_%@_HYC",ImageName,[[NSBundle mainBundle] bundleIdentifier]]];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }else{
        
        self.page++;
        [self addGuideViewOnWindowImageObject:self.ImageNameObject];
    }
    
    
}
- (void)viewClick:(UIGestureRecognizer *)senter{
    self.page++;
    [senter.view removeFromSuperview];
    
    [self addGuideViewOnWindowImageObject:self.ImageNameObject];
}
@end
