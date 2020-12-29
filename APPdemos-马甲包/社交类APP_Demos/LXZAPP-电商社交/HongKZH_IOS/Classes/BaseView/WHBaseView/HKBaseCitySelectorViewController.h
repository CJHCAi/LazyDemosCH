//
//  HKBaseCitySelectorViewController.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/5.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewController.h"
#import "HKChinaModel.h"
#import "HKWHUrl.h"
#import "HKProvinceModel.h"
#import "HKCityModel.h"
#import "getChinaList.h"
typedef void(^ConfirmBlock)(HKProvinceModel*proCode,HKCityModel*cityCode,getChinaListAreas*areaCode);
@protocol HKBaseCitySelectorViewControllerDelegate <NSObject>

@optional
-(void)confirmWithProCode:(NSString*)proCode cityCode:(NSString*)cityCode areaCode:(NSString*)areaCode;
-(void)cancle;

@end
@interface HKBaseCitySelectorViewController : HKBaseViewController
+(void)showCitySelectorWithProCode:(NSString*)proCode cityCode:(NSString*)cityCode areaCode:(NSString*)areaCode navVc:(UIViewController*)navVc ConfirmBlock:(ConfirmBlock)confirmBlock;

@property (nonatomic, copy)NSString *proCode;

@property (nonatomic, copy)NSString *cityCode;

@property (nonatomic, copy)NSString *areaCode;
@property (nonatomic,weak) id<HKBaseCitySelectorViewControllerDelegate> delegate;
@property (nonatomic, copy)ConfirmBlock confirmBlock;
@end
