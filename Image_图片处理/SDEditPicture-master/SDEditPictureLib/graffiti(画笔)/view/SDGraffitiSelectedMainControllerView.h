//
//  SDGraffitiSelectedMainControllerView.h
//  SDEditPicture
//
//  Created by shansander on 2017/7/26.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SDGraffitiResetModel;

@class SDGraffitiSelectedColorModel;

@interface SDGraffitiSelectedMainControllerView : UIView

@property (nonatomic, strong) SDGraffitiResetModel * graffitiResetModel;

@property (nonatomic, strong) SDGraffitiSelectedColorModel * graffitiSelectedColorModel;

@property (nonatomic, strong) NSArray * graffiti_size_list;

@property (nonatomic, strong) NSArray * graffiti_color_list;

- (void)showGraffitiSelectedColorView;


- (void)showbrushControllerView;

- (void)showEraserControllerView;

@end
