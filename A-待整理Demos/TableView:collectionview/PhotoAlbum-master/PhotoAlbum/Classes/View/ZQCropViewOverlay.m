//
//  ZQCropViewOverlay.m
//  PhotoAlbum
//
//  Created by ZhouQian on 16/6/17.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import "ZQCropViewOverlay.h"
#import "ZQCropView.h"
#import "ZQPhotoPreviewVC.h"
#import "ViewUtils.h"
#import "Typedefs.h"
#import "ZQPublic.h"
#import "NSString+Size.h"
#import "ZQAlbumNavVC.h"

@interface ZQCropBottomBar ()
@property (nonatomic, strong) UIButton *btnCancel;
@property (nonatomic, strong) UIButton *btnSelect;
@end
@implementation ZQCropBottomBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kDarkBottomBarBGColor;//[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        self.btnCancel = [[UIButton alloc] init];
        [self.btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btnCancel setTitle:_LocalizedString(@"OPERATION_CANCEL") forState:UIControlStateNormal];
        [self addSubview:self.btnCancel];
        CGSize size = [self.btnCancel.titleLabel.text textSizeWithFont:self.btnCancel.titleLabel.font constrainedToSize:CGSizeMake(frame.size.width/2, bottomBarHeight) lineBreakMode:NSLineBreakByTruncatingTail];
        self.btnCancel.frame = CGRectMake(ZQSide_X, 0, size.width+ZQSide_X*2, bottomBarHeight);
        [self.btnCancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        
        self.btnSelect = [[UIButton alloc] init];
        [self.btnSelect setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btnSelect setTitle:_LocalizedString(@"OPERATION_SELECT") forState:UIControlStateNormal];
        [self addSubview:self.btnSelect];
        self.btnSelect.frame = CGRectMake(frame.size.width - 2*ZQSide_X-size.width, 0, size.width+ZQSide_X*2, bottomBarHeight);
        [self.btnSelect addTarget:self action:@selector(select) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
- (void)cancel {
    [[self firstViewController].navigationController popViewControllerAnimated:YES];
}
- (void)select {
    ZQPhotoPreviewVC *vc = (ZQPhotoPreviewVC *)[self firstViewController];
    [self.superview.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([view isKindOfClass:[ZQCropView class]]) {
            ZQCropView *crop = (ZQCropView *)view;
            [vc getCurrentCrop:crop.cropRect];
        }
    }];
    
}
@end


@interface ZQCropViewOverlay ()
@property (nonatomic, strong) ZQCropBottomBar *bar;
@end

@implementation ZQCropViewOverlay

- (instancetype)init {
    return [self initWithFrame:[UIScreen mainScreen].bounds];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        ZQCropView *cropView = [[ZQCropView alloc] initWithFrame:frame];
        [self addSubview:cropView];
        
        CGRect rect = CGRectMake(0, frame.size.height - bottomBarHeight, frame.size.width, bottomBarHeight);
        self.bar = [[ZQCropBottomBar alloc] initWithFrame:rect];
        [self addSubview:self.bar];
        
        
    }
    return self;
}


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    BOOL pointInside = NO;
    
    if (CGRectContainsPoint(self.bar.frame, point)) pointInside = YES;
    
    return pointInside;
}

@end
