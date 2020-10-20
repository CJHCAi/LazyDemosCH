//
//  SDDecorateFunctionViewController.h
//  SDEditPicture
//
//  Created by shansander on 2017/7/25.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import "SDDiyBaseFunctionViewController.h"
#import "SDTagView.h"

@class SDDecorateFunctionModel;

@interface SDDecorateFunctionViewController : SDDiyBaseFunctionViewController


- (void)addDecorateModelForView:(SDDecorateFunctionModel *)model;

- (void)swtichToTagController;

- (void)swtichToDecorateController;

- (void)addTagModelForView:(SDDecorationTagModel)tagModel;

@end
