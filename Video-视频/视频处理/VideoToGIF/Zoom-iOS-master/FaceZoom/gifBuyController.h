//
//  gifBuyController.h
//  Zoom
//
//  Created by Ben Taylor on 6/15/15.
//  Copyright (c) 2015 Ben Taylor. All rights reserved.
//
#import "HSImageSidebarView.h"

@protocol thisProtocol <NSObject>


-(void)applyCloudLayerAnimation;

@end


@interface gifBuyController : UIViewController <HSImageSidebarViewDelegate, UIActionSheetDelegate>


@property(nonatomic, assign) id delegate;
@property(nonatomic, retain) HSImageSidebarView *sidebarx;
@property(nonatomic, retain) NSMutableArray *images;
@property(nonatomic, retain) UIImage *originalImage;
@property (copy) void (^actionSheetBlock)(NSUInteger);
@property(nonatomic, retain) NSMutableArray *offsets;
@property(nonatomic, strong) UIImageView *mainImageView;
@property(nonatomic, strong) NSTimer *gifTimer;
@property(nonatomic, strong) UIButton *playButton;
@property(nonatomic, strong) UIImage *playImage;
@property(nonatomic, strong) UIImage *pauseImage;
//@property(nonatomic, strong) UIView *lineAdjuster;
@property(nonatomic, strong) UIButton *plusThing;
@property(nonatomic, strong) UIButton *minusThing;

@end