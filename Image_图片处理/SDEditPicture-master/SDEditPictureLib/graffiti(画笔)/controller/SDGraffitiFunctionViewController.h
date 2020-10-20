//
//  SDGraffitiFunctionViewController.h
//  SDEditPicture
//
//  Created by shansander on 2017/7/26.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import "SDDiyBaseFunctionViewController.h"

@interface SDGraffitiFunctionViewController : SDDiyBaseFunctionViewController


@property (nonatomic, strong) UIColor * drawColor;

@property (nonatomic, assign) CGFloat drawSize;

- (void)showSelectedColorView;

- (void)showSelectedbrushView;

- (void)showSelectedEraserView;


@end
