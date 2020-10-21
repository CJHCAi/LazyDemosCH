//
//  ImagePickerCell.m
//  Ps
//
//  Created by Deon Botha on 10/12/2013.
//  Copyright (c) 2013 dbotha. All rights reserved.
//

#import "OLInstagramImagePickerCell.h"
#import "UIImageView+InstagramFadeIn.h"
#import "OLInstagramImage.h"
#import <UIColor+HexString.h>

#define kThumbnailLength    78.0f
#define kThumbnailSize      CGSizeMake(kThumbnailLength, kThumbnailLength)
#

@interface OLInstagramImagePickerCell ()
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL disabled;
@property (nonatomic, strong) OLInstagramImage *instagramMedia;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *checkImageView;
@property (nonatomic, strong) UIView *selectedDisabledOverlayView;
@end

@implementation OLInstagramImagePickerCell

@synthesize fullURL;

static UIFont *titleFont = nil;

static CGFloat titleHeight;
static UIColor *titleColor;
static UIImage *checkedIcon;
static UIColor *selectedColor;
static UIColor *disabledColor;

+ (void)initialize {
    titleFont       = [UIFont systemFontOfSize:12];
    titleHeight     = 20.0f;
    titleColor      = [UIColor whiteColor];
    checkedIcon     = [UIImage imageNamed:(!(floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)) ? @"CTAssetsPickerChecked~iOS6" : @"CTAssetsPickerChecked"];
    selectedColor   = [UIColor colorWithWhite:1 alpha:0.3];
    disabledColor   = [UIColor colorWithWhite:1 alpha:0.9];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.opaque = YES;
        self.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
        CGRect f = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.imageView = [[UIImageView alloc] initWithFrame:f];
        self.checkImageView = [[UIImageView alloc] initWithImage:checkedIcon];
        self.selectedDisabledOverlayView = [[UIView alloc] initWithFrame:f];
        self.selectedDisabledOverlayView.backgroundColor = selectedColor;
        self.selectedDisabledOverlayView.opaque = YES;
        self.selectedDisabledOverlayView.hidden = YES;
        
        self.checkImageView.frame = CGRectMake(f.size.width - checkedIcon.size.width, 0, self.checkImageView.frame.size.width, self.checkImageView.frame.size.height);
        self.checkImageView.hidden = YES;
        
        [self addSubview:self.imageView];
        [self addSubview:self.selectedDisabledOverlayView];
        [self addSubview:self.checkImageView];
    }
    
    return self;
}

- (void)bind:(OLInstagramImage *)media {
    self.instagramMedia = media;
    self.fullURL = media.fullURL;
    [self.imageView setAndFadeInInstagramImageWithURL:media.thumbURL];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.selectedDisabledOverlayView.hidden = !selected;
    self.checkImageView.hidden = !selected;
}

@end
