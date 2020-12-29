//
//  HK_VipUserHeadview.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKNewPerSonTypeResponse.h"

@protocol UserHeaderSectionDelegete <NSObject>

-(void)clickHeaderSectionWithTypeId:(NSString *)typeId withTag:(NSInteger)tag;
@end

@interface HK_VipUserHeadview : UIView
@property (nonatomic, strong)HKNewPerSonTypeResponse *response;
@property (nonatomic, weak) id <UserHeaderSectionDelegete>delegete;
@end
