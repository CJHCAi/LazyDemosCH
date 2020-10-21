//
//  WZRemoteImageNavigationView.m
//  WZPhotoPicker
//
//  Created by admin on 17/6/9.
//  Copyright © 2017年 wizet. All rights reserved.
//

#import "WZRemoteImageNavigationView.h"

@implementation WZRemoteImageNavigationView

+ (instancetype)customAssetBrowseNavigationWithDelegate:(id<WZProtocolAssetBrowseNaviagtion>)delegate {
    WZRemoteImageNavigationView *navigation = [super customAssetBrowseNavigationWithDelegate:delegate];
    navigation.selectedButton.hidden = true;
    return navigation;
}

@end
