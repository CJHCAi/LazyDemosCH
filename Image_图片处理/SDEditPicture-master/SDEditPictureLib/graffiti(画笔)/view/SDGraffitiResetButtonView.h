//
//  SDGraffitiResetButtonView.h
//  SDEditPicture
//
//  Created by shansander on 2017/7/26.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDGraffitiResetModel.h"

#import "SDCustomControl.h"

@interface SDGraffitiResetButtonView : SDCustomControl

@property (nonatomic, strong) SDGraffitiResetModel * graffitiResetModel;

@property (nonatomic, weak) UILabel * theResetLabel;

@property (nonatomic, weak) UIView * theLabelBgView;


@end
