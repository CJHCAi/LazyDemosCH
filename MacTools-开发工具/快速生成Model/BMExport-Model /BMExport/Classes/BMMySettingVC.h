//
//  BMMySettingVC.h
//  BMExport
//
//  Created by ___liangdahong on 2017/12/8.
//  Copyright © 2017年 ___liangdahong. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef void(^BMSettingVCBlock)(BOOL add, BOOL alignment);

@interface BMMySettingVC : NSViewController

@property (nonatomic, copy) BMSettingVCBlock block; ///< block
@property (nonatomic, assign) BOOL add; ///< <#Description#>
@property (nonatomic, assign) BOOL alignment; ///< <#Description#>

@end
