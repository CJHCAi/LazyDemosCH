//
//  HKAfterSaleViewModel.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/4.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKAfterSaleViewModel.h"
#import "HKAfterSaleRespone.h"
#import "HKApplicationRefundTableViewCell.h"
#import "HKTAgreeableViewCell.h"
#import "HKPleaseReturnTableViewCell.h"
#import "HKAfterLogisticsTableViewCell.h"
#import "HKAddressListRespone.h"
#import "HK_NetWork.h"
#import "HKDateTools.h"
#import "HKDateTool.h"
#import "HKCancleTableViewCell.h"
#import "HKProofTableViewCell.h"
#import "HKAfterStaueTableViewCell.h"
@implementation HKAfterSaleViewModel

+(void)orderAfterSale:(NSDictionary*)parameter success:(void (^)( HKAfterSaleRespone* responde))success{
    [HK_BaseRequest buildPostRequest:get_orderAfterSale body:parameter success:^(id  _Nullable responseObject) {
        HKAfterSaleRespone *respone = [HKAfterSaleRespone mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        HKAfterSaleRespone *respone = [[HKAfterSaleRespone alloc]init];
        success(respone);
    }];
}
+(void)address:(NSDictionary*)parameter type:(int)type success:(void (^)( HKAddressListRespone* responde))success{
    NSString*url;
    if (type == 1) {
        url = get_getUserReturnAddressList;
    }else{
        url = get_userDeliveryAddressList;
    }
    [HK_BaseRequest buildPostRequest:url body:parameter success:^(id  _Nullable responseObject) {
        HKAddressListRespone *respone = [HKAddressListRespone mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        HKAddressListRespone *respone = [[HKAddressListRespone alloc]init];
        success(respone);
    }];
}
+(void)addUserReturnAddress:(NSDictionary*)parameter type:(BOOL)isRefund success:(void (^)( HKBaseResponeModel* responde))success{
    NSString*url ;
    if (isRefund ) {
        url =  get_addUserReturnAddress;
      
    }else{
        url=  get_addUserDeliveryAddress;
    }
    [HK_BaseRequest buildPostRequest:url body:parameter success:^(id  _Nullable responseObject) {
        HKBaseResponeModel*respone = [HKBaseResponeModel mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        HKBaseResponeModel*respone = [[HKBaseResponeModel alloc]init];
        success(respone);
    }];
}
+(void)agreeReturnGoods:(NSDictionary*)parameter type:(AfterSaleViewStatue)type success:(void (^)( HKBaseResponeModel* responde))success{
    NSString*url ;
    if (type == AfterSaleViewStatue_Application) {
        url = get_sellerApprovalOrder;
    }else{
        url = get_agreeReturnGoods;
    }
    [HK_BaseRequest buildPostRequest:url body:parameter success:^(id  _Nullable responseObject) {
        HKBaseResponeModel*respone = [HKBaseResponeModel mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        HKBaseResponeModel*respone = [[HKBaseResponeModel alloc]init];
        success(respone);
    }];
}

+(void)sellerRefuseOrder:(NSDictionary*)parameter imageArray:(NSMutableArray*)imageArrray success:(void (^)( HKBaseResponeModel* responde))success{
    if (imageArrray.count>0) {
        [HK_NetWork uploadEditImageURL:get_sellerRefuseOrder parameters:parameter images:imageArrray name:@"imgSrc" fileName:[HKDateTool getCurrentIMServerTime13] mimeType:@"jpeg" specifications:nil progress:^(NSProgress *progress) {
            
        } callback:^(id responseObject, NSError *error) {
            HKBaseResponeModel*respone = [HKBaseResponeModel mj_objectWithKeyValues:responseObject];
            success(respone);
        }];

        
    }else{
        [HK_BaseRequest buildPostRequest:get_sellerRefuseOrder body:parameter success:^(id  _Nullable responseObject) {
            HKBaseResponeModel*respone = [HKBaseResponeModel mj_objectWithKeyValues:responseObject];
            success(respone);
        } failure:^(NSError * _Nullable error) {
            HKBaseResponeModel*respone = [[HKBaseResponeModel alloc]init];
            success(respone);
        }];
        
    }
}
+(void)refuseReturnGoods:(NSDictionary*)parameter imageArray:(NSMutableArray*)imageArrray success:(void (^)( HKBaseResponeModel* responde))success{
   
        [HK_NetWork uploadEditImageURL:get_refuseReturnGoods parameters:parameter images:imageArrray name:@"imgSrc" fileName:[HKDateTool getCurrentIMServerTime13] mimeType:@"jpeg" specifications:nil progress:^(NSProgress *progress) {
            
        } callback:^(id responseObject, NSError *error) {
            HKBaseResponeModel*respone = [HKBaseResponeModel mj_objectWithKeyValues:responseObject];
            success(respone);
        }];
        
 
}
+(void)sellerProof:(NSDictionary*)parameter imageArray:(NSMutableArray*)imageArrray success:(void (^)( HKBaseResponeModel* responde))success{
    {
        
        [HK_NetWork uploadEditImageURL:get_sellerProof parameters:parameter images:imageArrray name:@"imgSrc" fileName:[HKDateTool getCurrentIMServerTime13] mimeType:@"jpeg" specifications:nil progress:^(NSProgress *progress) {
            
        } callback:^(id responseObject, NSError *error) {
            HKBaseResponeModel*respone = [HKBaseResponeModel mj_objectWithKeyValues:responseObject];
            success(respone);
        }];
        
        
    }
}
+(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section statue:(AfterSaleViewStatue)statue{
    
    return 0;
}
+(HKAfterBaseTableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath model:(HKAfterSaleRespone*)model{
    if (indexPath.section == 0) {
        HKAfterStaueTableViewCell *cell = [HKAfterStaueTableViewCell afterBaseTableViewCellWithTableView:tableView];
        return cell;
    }
    
    AfterSaleViewStatue statue = [model.data.cellArray[indexPath.row] intValue];
    
    
    switch (statue) {
        case AfterSaleViewStatue_Application:
        case AfterSaleViewStatue_ApplicationReturn:
        {
            HKApplicationRefundTableViewCell*cell = [HKApplicationRefundTableViewCell afterBaseTableViewCellWithTableView:tableView];
            return cell;
        }
            break;
        case AfterSaleViewStatue_Agree:
        case AfterSaleViewStatue_finish:
        case AfterSaleViewStatue_RefuseReturn:
        case AfterSaleViewStatue_Refuse:
        {
            HKTAgreeableViewCell*cell = [HKTAgreeableViewCell afterBaseTableViewCellWithTableView:tableView];
            return cell;
        }
            break;
        case AfterSaleViewStatue_SendReturnDelivery:
        case AfterSaleViewStatue_Complaint:
        {
           HKAfterLogisticsTableViewCell*cell = [HKAfterLogisticsTableViewCell afterBaseTableViewCellWithTableView:tableView];
            return cell;
        }
            break;
        case AfterSaleViewStatue_AgreeReturn:
        {
            HKPleaseReturnTableViewCell*cell = [HKPleaseReturnTableViewCell afterBaseTableViewCellWithTableView:tableView];
            return cell;
        }
            break;
        case AfterSaleViewStatue_ReturnFinish:
        {
            HKTAgreeableViewCell*cell = [HKTAgreeableViewCell afterBaseTableViewCellWithTableView:tableView];
            return cell;
        }
            break;
        case AfterSaleViewStatue_cancel:
        case AfterSaleViewStatue_cancelApplicationReturn:
        case AfterSaleViewStatue_cancelComplaint:
        {
            HKCancleTableViewCell*cell = [HKCancleTableViewCell afterBaseTableViewCellWithTableView:tableView];
            return cell;
        }
            break;
        case AfterSaleViewStatue_ProofOfBuyerseller:
        case AfterSaleViewStatue_ProofOfBuyer:
        {
            HKProofTableViewCell *cell = [HKProofTableViewCell afterBaseTableViewCellWithTableView:tableView];
            return cell;
        }
            break;
        default:
            break;
    }
    return nil;
}

@end
