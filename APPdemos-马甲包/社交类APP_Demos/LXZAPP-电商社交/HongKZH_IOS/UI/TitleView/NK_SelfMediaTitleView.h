//
//  NK_SelfMediaTitleView.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/4/18.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UtilHKProtocol.h"
@interface NK_SelfMediaTitleView : UIView
@property (nonatomic,weak) id<HK_SelfMediaLeftDelegate>leftdelegate;
@property (nonatomic,weak) id<HK_SelfMediaRightDelegate>rightdelegate;
@property (nonatomic,weak) id<HK_SelfMediaSeachDelegate>seachdelegate;
-(void)addtitle:(NSString *)title;
@end
