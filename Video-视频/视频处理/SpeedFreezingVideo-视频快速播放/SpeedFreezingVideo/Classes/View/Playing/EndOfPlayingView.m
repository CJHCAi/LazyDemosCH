//
//  EndOfPlayingView.m
//  SpeedFreezingVideo
//
//  Created by lzy on 16/8/14.
//  Copyright © 2016年 lzy. All rights reserved.
//

#import "EndOfPlayingView.h"
#import "UIColor+hexColor.h"
#import "UIView+ExtendTouchArea.h"

#define BUTTON_MARGIN_GAP 50
#define BUTTON_TITLE_LABEL_MARGIN 30
#define BUTTON_TOUCH_EXTEND_INSET UIEdgeInsetsMake(0, -30, -40, -30)

@interface EndOfPlayingView ()

@end
@implementation EndOfPlayingView
- (instancetype)initWithVideoOrientation:(VideoOrientation)orientation
                                delegate:(id<EndOfPlayingViewDelegate>)delegate {
    self = [super init];
    if (self) {
        _delegate = delegate;
        [self setupWithVideoOrientation:orientation];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupWithVideoOrientation:VideoOrientationPortrait];
    }
    return self;
}

- (void)setupWithVideoOrientation:(VideoOrientation)orientation {
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    CGFloat topMargin = 0.15 * screenHeight;
    CGFloat bottomMargin = 0.15 * screenHeight;
    switch (orientation) {
        case VideoOrientationPortrait:
            topMargin = 0.15 * screenHeight;
            bottomMargin = 0.15 * screenHeight;
            break;
        case VideoOrientationLandscape:
            topMargin = 0.05 * screenHeight;
            bottomMargin = 0.09 * screenHeight;
            break;
        default:
            break;
    }
    [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
    [self setFrame:[[UIScreen mainScreen] bounds]];
    
    //Labels
    UILabel *topLabel = [[UILabel alloc] init];
    [topLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [topLabel setText:@"THIS VIDEO WAS"];
    [topLabel setFont:[UIFont systemFontOfSize:15.f]];
    [topLabel setTextColor:[UIColor whiteColor]];
    [self addSubview:topLabel];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:topLabel attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [titleLabel setText:@"Browse Finished"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:40.f]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [self addSubview:titleLabel];
    
    UILabel *subTitleLabel = [[UILabel alloc] init];
    [subTitleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [subTitleLabel setText:@"Then you can do the next step as follows"];
    [subTitleLabel setFont:[UIFont systemFontOfSize:12.f]];
    [subTitleLabel setTextColor:[UIColor whiteColor]];
    [self addSubview:subTitleLabel];
    NSDictionary *layoutLabels = NSDictionaryOfVariableBindings(topLabel, titleLabel, subTitleLabel);
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%d-[topLabel]-5-[titleLabel]-30-[subTitleLabel]", (int)topMargin] options:NSLayoutFormatAlignAllCenterX metrics:nil views:layoutLabels]];
    
    //Buttons
    UIButton *backToEditButton = [[UIButton alloc] init];
    [backToEditButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [backToEditButton setTouchExtendInset:BUTTON_TOUCH_EXTEND_INSET];
    [backToEditButton setImage:[UIImage imageNamed:@"editing_button"] forState:UIControlStateNormal];
    [backToEditButton addTarget:self action:@selector(backToEditing) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backToEditButton];
    
    UIButton *replayButton = [[UIButton alloc] init];
    [replayButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [replayButton setTouchExtendInset:BUTTON_TOUCH_EXTEND_INSET];
    [replayButton setImage:[UIImage imageNamed:@"replay_button"] forState:UIControlStateNormal];
    [replayButton addTarget:self action:@selector(replayVideo) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:replayButton];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:replayButton attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:replayButton attribute:NSLayoutAttributeBottom multiplier:1.f constant:bottomMargin]];
    
    UIButton *saveButton = [[UIButton alloc] init];
    [saveButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [saveButton setTouchExtendInset:BUTTON_TOUCH_EXTEND_INSET];
    [saveButton setImage:[UIImage imageNamed:@"save_button"] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveVideo) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:replayButton];
    [self addSubview:saveButton];
    NSDictionary *layoutButtons = NSDictionaryOfVariableBindings(backToEditButton, replayButton, saveButton);
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[backToEditButton]-%d-[replayButton]-%d-[saveButton]", BUTTON_MARGIN_GAP, BUTTON_MARGIN_GAP] options:NSLayoutFormatAlignAllBottom metrics:nil views:layoutButtons]];
    
    //ButtonTitles
    UILabel *backToEditLabel = [[UILabel alloc] init];
    [backToEditLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [backToEditLabel setTextColor:[UIColor hexColor:@"797979"]];
    [backToEditLabel setText:@"BACK TO EDIT"];
    [backToEditLabel setFont:[UIFont systemFontOfSize:14.f]];
    [self addSubview:backToEditLabel];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:backToEditButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:backToEditLabel attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:backToEditButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:backToEditLabel attribute:NSLayoutAttributeBottom multiplier:1.f constant:-BUTTON_TITLE_LABEL_MARGIN]];
    
    UILabel *replayLabel = [[UILabel alloc] init];
    [replayLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [replayLabel setTextColor:[UIColor hexColor:@"797979"]];
    [replayLabel setText:@"REPLAY"];
    [replayLabel setFont:[UIFont systemFontOfSize:14.f]];
    [self addSubview:replayLabel];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:replayButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:replayLabel attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:replayButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:replayLabel attribute:NSLayoutAttributeBottom multiplier:1.f constant:-BUTTON_TITLE_LABEL_MARGIN]];
    
    UILabel *saveLabel = [[UILabel alloc] init];
    [saveLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [saveLabel setTextColor:[UIColor hexColor:@"797979"]];
    [saveLabel setText:@"SAVE"];
    [saveLabel setFont:[UIFont systemFontOfSize:14.f]];
    [self addSubview:saveLabel];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:saveButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:saveLabel attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:saveButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:saveLabel attribute:NSLayoutAttributeBottom multiplier:1.f constant:-BUTTON_TITLE_LABEL_MARGIN]];
}

- (void)backToEditing {
    if ([_delegate respondsToSelector:@selector(didClickBackToEditButton)]) {
        [_delegate didClickBackToEditButton];
    }
}

- (void)replayVideo {
    if ([_delegate respondsToSelector:@selector(didClickReplayButton)]) {
        [_delegate didClickReplayButton];
    }
    [self removeFromSuperview];
}

- (void)saveVideo {
    if ([_delegate respondsToSelector:@selector(didClickSaveButton)]) {
        [_delegate didClickSaveButton];
    }
}

@end
