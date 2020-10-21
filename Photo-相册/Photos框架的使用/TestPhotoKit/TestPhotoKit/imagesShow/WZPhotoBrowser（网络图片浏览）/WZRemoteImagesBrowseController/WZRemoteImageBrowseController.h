//
//  WZRemoteImageBrowseController.h
//  WZPhotoPicker
//
//  Created by admin on 17/6/9.
//  Copyright © 2017年 wizet. All rights reserved.
//

#import "WZAssetBrowseController.h"
#import "WZRemoteImageNavigationView.h"

@interface WZRemoteImageBrowseController : WZAssetBrowseController

@property (nonatomic, strong) UIImageView *mediumImageView;

+ (void)showRemoteImagesWithURLArray:(NSArray <NSURL *>*)urlArray loactedVC:(UIViewController *)locatedVC;

+ (NSArray <NSURL *>*)fetchUrlArrayAccordingStringArray:(NSArray <NSString *>*)stringArray;

@end
