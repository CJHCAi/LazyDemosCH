//
//  GCUploadingAsset.h
//  Chute-SDK
//
//  Created by Aleksandar Trpeski on 5/14/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import "GCAsset.h"

@class GCUploadInfo;

@interface GCUploadingAsset : GCAsset

@property (nonatomic, strong) GCUploadInfo *uploadInfo;

@end
