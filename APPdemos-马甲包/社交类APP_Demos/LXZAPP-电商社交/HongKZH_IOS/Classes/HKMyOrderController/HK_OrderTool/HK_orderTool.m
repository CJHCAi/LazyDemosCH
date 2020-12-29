//
//  HK_orderTool.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/31.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_orderTool.h"
#import "HK_BaseRequest.h"
#import "HK_PaymentActionSheet.h"
#import "HK_PaymentActionSheetTwo.h"
@implementation HK_orderTool
//进入充值
+(void)pushReChargeController:(UIViewController *)controller {
    HK_RechargeController * reVc =[[HK_RechargeController alloc] init];
    [controller.navigationController pushViewController:reVc animated:YES];
    
}
//编辑收货地址
+(void)pushEditAdressContorller:(UIViewController *)controller withModel:(HK_orderInfo *)orderModel andTableView:(UITableView *)tableView {
    HK_AddressInfoView * infoVc =[[HK_AddressInfoView alloc] init];
    infoVc.delegate = controller;
    
    [controller.navigationController pushViewController:infoVc animated:YES];
}
+(void)showPayInfoViews:(UIViewController *)CurrentVc withOrderInfo:(HK_orderInfo *)mdoel {

}
//进入支付
+(void)payOrdersWithNumber:(NSString *)ordersNumber  andCurrentVc:(UIViewController *)vc {
    NSMutableDictionary * params =[[NSMutableDictionary alloc] init];
    [params setValue:LOGIN_UID forKey:@"loginUid"];
    [params setValue:ordersNumber forKey:@"ordersId"];
    [HK_BaseRequest buildPostRequest:get_payOrder_mediaShop body:params success:^(id  _Nullable responseObject) {
        NSInteger code =[responseObject[@"code"] integerValue];
        if (code) {
            NSString *msg  =responseObject[@"msg"];
            [EasyShowTextView showText:msg];
        }else {
            [EasyShowTextView showText:@"支付成功"];
            [vc.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
//充值
+(void)showSuPllyInfoView:(UIViewController *)CurrentVc withOrderInfo:(HK_orderInfo *)mdoel {

}
//删除订单
+(void)deleteOrdersWithOrderNumber:(NSString *)orderNumber handleBlock:(successBlock)successBlock failError:(fail)failBlock {
    NSMutableDictionary * params =[[NSMutableDictionary alloc] init];
    [params setValue:LOGIN_UID forKey:@"loginUid"];
    [params setValue:orderNumber forKey:@"orderNumber"];
    [HK_BaseRequest buildPostRequest:get_mediaShopDeleteuserOrder body:params success:^(id  _Nullable responseObject) {
        NSInteger code =[responseObject[@"code"] integerValue];
        if (code) {
            NSString *msg  =responseObject[@"msg"];
            failBlock(msg);
        }else {
            successBlock();
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
//取消订单
+(void)cancelUserOderWithOrderNumber:(NSString *)orderNumber handleBlock:(successBlock)successBlock failError:(fail)failBlock {
    NSMutableDictionary * params =[[NSMutableDictionary alloc] init];
    [params setValue:LOGIN_UID forKey:@"loginUid"];
    [params setValue:orderNumber forKey:@"orderNumber"];
    
    [HK_BaseRequest buildPostRequest:get_mediaShopcanceluserOrder body:params success:^(id  _Nullable responseObject) {
        
        NSInteger code =[responseObject[@"code"] integerValue];
        if (code) {
            NSString *msg  =responseObject[@"msg"];
            if (msg.length) {
                failBlock(msg);
            }else {
                failBlock(@"操作失败");
            }
        }else {
            successBlock();
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
//确认收货
+(void)confirmCollectGoodsWithOrderNumber:(NSString *)orderNumber handleBlock:(successBlock)successBlock failError:(fail)failBlock {
    NSMutableDictionary * params =[[NSMutableDictionary alloc] init];
    [params setValue:LOGIN_UID forKey:@"loginUid"];
    [params setValue:orderNumber forKey:@"orderNumber"];
    
    [HK_BaseRequest buildPostRequest:get_confirmCollectGoods body:params success:^(id  _Nullable responseObject) {
        NSInteger code =[responseObject[@"code"] integerValue];
        if (code) {
            NSString *msg  =responseObject[@"msg"];
           // [EasyShowTextView showText:msg];
            failBlock(msg);
        }else {
            successBlock ();
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
/**
 * 返回组数
 */
+(NSInteger)sectionCountWithOrderStates:(NSString *)state {
    //返回的组数和订单的状态有关系....
    if ([state isEqualToString:@"7"]) {
        //已完成....
        return  4 ;
    }else if ([state isEqualToString:@"9"]){
        //已转售
        return  3;
    }else if ([state isEqualToString:@"4"]){
        //暂存储
        return  3;
    }else if ([state isEqualToString:@"3"]){
        //待收货
        return  4;
    }else if ([state isEqualToString:@"1"]){
        //等待付款
        return 3;
    }
    return 3;
}

//返回footer高度
+(CGFloat)sectionFooterHightWithOrderStates:(NSString *)state andSection:(NSInteger)section{
    //返回的组数和订单的状态有关系....
    if ([state isEqualToString:@"7"]) {
        if (section==1) {
            return 0;
        }
    }else if ([state isEqualToString:@"9"]){
        //已转售
        if (section==1) {
            return 50;
        }
    }else if ([state isEqualToString:@"4"]){
        //暂存储
        if (section==0) {
            return 0;
        }
    }else if ([state isEqualToString:@"3"]){
        //待收货
        if (section==1) {
            return 0;
        }
    }else if ([state isEqualToString:@"1"]||[state isEqualToString:@"10"]||[state isEqualToString:@"8"]){
        //等待付款
        if (section==0) {
            return 0;
        }
    }
    return 10;
}
//返回组头高度
+(CGFloat)sectionHeaderHightWithOrderStates:(NSString *)state andSection:(NSInteger)section{
    //返回的组数和订单的状态有关系....
    if ([state isEqualToString:@"7"]) {
        if (section==2) {
            
            return 50;
        }
        return 0.01;
    }else if ([state isEqualToString:@"9"]){
        //已转售
        if (section==1) {
            return 50;
        }
        return  0.01;
    }else if ([state isEqualToString:@"4"]){
        //暂存储
        if (section==1) {
            return 50;
        }
        return  0.01;
    }else if ([state isEqualToString:@"3"]){
        //待收货
        if (section==2) {
            return 50;
        }
        return  0.01;
    }else if ([state isEqualToString:@"1"]||[state isEqualToString:@"10"]||[state isEqualToString:@"8"]){
        //等待付款
        if (section==1) {
            return 50;
        }
        return 0.01;
    }
    return 0.01;
    
}
//返回组头视图
+(UIView *)sectionHeaderViewWithOrderStates:(HK_orderInfo *)model andSection:(NSInteger)section {
    //获取每一组的 内容状态
    HK_orderShopHeaderView * headerView  =[[HK_orderShopHeaderView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,50)];
    
    [headerView setConfigueViewWithModel:model];
    //返回的组数和订单的状态有关系....
    if ([model.data.state isEqualToString:@"7"]) {
        if (section==2) {
            return  headerView;
        }
    }else if ([model.data.state isEqualToString:@"9"]){
        //已转售
        if (section==1) {
            return headerView;
        }
        return  nil;
    }else if ([model.data.state isEqualToString:@"4"]){
        //暂存储
        if (section==1) {
            return headerView;
        }
        return  nil;
    }else if ([model.data.state isEqualToString:@"3"]){
        //待收货
        if (section==2) {
            return headerView;
        }
    }else if ([model.data.state isEqualToString:@"1"]||[model.data.state isEqualToString:@"10"]||[model.data.state  isEqualToString:@"8"]){
        //等待付款
        if (section==1) {
            return headerView;
        }
    }
    return  nil;
}
//返回没组的行数
+(NSInteger)rowcountForSectionWithOrderState:(HK_orderInfo *)model andSection:(NSInteger)section {    
    //已完成
    if ([model.data.state isEqualToString:@"7"]) {
        if (section==0 ||section==1 ||section==3) {
            return  1;
        }
        return model.data.subList.count;
        
    }else if ([model.data.state isEqualToString:@"9"]){
        if (section==0 ||section==2) {
            return 1;
        }
        return  model.data.subList.count;
        
    }else if ([model.data.state isEqualToString:@"4"]){
        //暂存储
        if (section==0 ||section==2) {
            return 1;
        }
        return  model.data.subList.count;
        
    }else if ([model.data.state isEqualToString:@"3"]||[model.data.state isEqualToString:@"10"]){
        //待收货
        if (section==0 ||section==1 ||section==3) {
            return  1;
        }
        return model.data.subList.count;
    }else if ([model.data.state isEqualToString:@"1"]||[model.data.state isEqualToString:@"8"]){
        //等待付款
        if (section==0 ||section==2) {
            return 1;
        }
        return  model.data.subList.count;
        
        
    }
    return 0;
}
+(CGFloat)rowHightWithOrderState:(NSString *)state andSection:(NSInteger)section{
    //返回的组数和订单的状态有关系....
    switch (state.intValue) {
        case OrderFormStatue_finish:
        case OrderFormStatue_payed:
        {
            if (section==0) {
                return  70;
            }else if (section==1){
                return 60;
            }else if (section==2){
                return 102;
            }else if (section==3){
                
                return  255;
            }
        }
            break;
        case OrderFormStatue_waitPay:
        case OrderFormStatue_cancel:
        case OrderFormStatue_close:
        {
            //等待付款
            if (section==0) {
                return 70;
            }else if (section==1){
                return 102;
            }else if (section==2){
                return 255;
            }
        }
            break;
        case OrderFormStatue_resale:
        case OrderFormStatue_cnsignment:
        {
            //暂存储
            if (section==0) {
                return 60;
            }else if (section==1){
                return 102;
            }else if (section==2){
                return 255;
            }
        }
            break;
        default:
            break;
    }
        return 0;
}
//cell赋值
+(UITableViewCell *)configueTableView:(UITableView *)tableView WithOrderStates:(HK_orderInfo *)model andIndexPath:(NSIndexPath *)indexPath andEditDelegete:(id)editUserAddressDelegete {
    //已完成
    if ([model.data.state isEqualToString:@"7"]) {
        //第一组用地址模型
        if (indexPath.section==0) {
            HK_orderAddressCell * cell =[tableView dequeueReusableCellWithIdentifier:@"address" forIndexPath:indexPath];
            [cell setCellConfigueWithModel:model];
            return cell;
        }else if (indexPath.section==1) {
            HK_InfoTopCell * cell =[tableView dequeueReusableCellWithIdentifier:@"topInfo" forIndexPath:indexPath];
            [cell setConfigueWithModel:model];
            return cell;
        }else if (indexPath.section==2){
            HK_MyOrderCell *cell =[tableView dequeueReusableCellWithIdentifier:@"goodInfo" forIndexPath:indexPath];
            orderSubMitModel * order =[[orderSubMitModel alloc] init];
            NSDictionary *dict= (NSDictionary *)model.data.subList[indexPath.row];
            order.imgSrc =dict[@"imgSrc"];
            order.number = [dict[@"number"] integerValue];
            order.colorName =dict[@"colorName"];
            order.title =dict[@"title"];
            order.integral =[dict[@"integral"] doubleValue];
            order.state =dict[@"state"];
            order.specName =dict[@"specName"];
            order.activityType =dict[@"activityType"];
            id obj  =dict[@"activityPrice"];
            if ([obj isKindOfClass:[NSNull class]]) {
                
                order.activityPrice = 0;
            }else {
                NSInteger price =[obj integerValue];
                order.activityPrice =[NSString stringWithFormat:@"%ld",(long)price];
            }
            [cell setDetailOrderCell:order];
            
            return  cell;
        }else if (indexPath.section==3) {
            HK_orderInfoCell * infoCell =[tableView dequeueReusableCellWithIdentifier:@"orderInfo" forIndexPath:indexPath];
            [infoCell setOrderInfoCellWithModel:model];
            return infoCell;
        }
    }else if ([model.data.state isEqualToString:@"9"]){
        
        if (indexPath.section==0) {
            HK_InfoTopCell * cell =[tableView dequeueReusableCellWithIdentifier:@"topInfo" forIndexPath:indexPath];
            [cell setConfigueWithModel:model];
            cell.messageLabel.text =@"恭喜,您的物品已转售成功!";
            return cell;
        }else if (indexPath.section==2){
            HK_MyOrderCell *cell =[tableView dequeueReusableCellWithIdentifier:@"goodInfo" forIndexPath:indexPath];
            orderSubMitModel * order =[[orderSubMitModel alloc] init];
            NSDictionary *dict= (NSDictionary *)model.data.subList[indexPath.row];
            order.imgSrc =dict[@"imgSrc"];
            order.number = [dict[@"number"] integerValue];
            order.colorName =dict[@"colorName"];
            order.title =dict[@"title"];
            order.integral =[dict[@"integral"] doubleValue];
            order.specName =dict[@"specName"];
            order.activityType =dict[@"activityType"];
            id obj  =dict[@"activityPrice"];
            if ([obj isKindOfClass:[NSNull class]]) {
                
                order.activityPrice = 0;
            }else {
                NSInteger price =[obj integerValue];
                order.activityPrice =[NSString stringWithFormat:@"%zd",price];
            }
            [cell setDetailOrderCell:order];
            return  cell;
        }else if (indexPath.section==3) {
            HK_orderInfoCell * infoCell =[tableView dequeueReusableCellWithIdentifier:@"orderInfo" forIndexPath:indexPath];
            [infoCell setOrderInfoCellWithModel:model];
            return infoCell;
        }
        
    }else if ([model.data.state isEqualToString:@"4"]){
        //暂存储..
        //第一组用地址模型
        if (indexPath.section==0) {
            HK_orderAddressCell * cell =[tableView dequeueReusableCellWithIdentifier:@"address" forIndexPath:indexPath];
            [cell setCellConfigueWithModel:model];
             cell.delegete = editUserAddressDelegete;
            return cell;
        }else if (indexPath.section==1){
            HK_MyOrderCell *cell =[tableView dequeueReusableCellWithIdentifier:@"goodInfo" forIndexPath:indexPath];
            orderSubMitModel * order =[[orderSubMitModel alloc] init];
            NSDictionary *dict= (NSDictionary *)model.data.subList[indexPath.row];
            order.imgSrc =dict[@"imgSrc"];
            order.number = [dict[@"number"] integerValue];
            order.colorName =dict[@"colorName"];
            order.title =dict[@"title"];
            order.integral =[dict[@"integral"] doubleValue];
            order.specName =dict[@"specName"];
            order.activityType =dict[@"activityType"];
            id obj  =dict[@"activityPrice"];
            if ([obj isKindOfClass:[NSNull class]]) {
                
                order.activityPrice = 0;
            }else {
                NSInteger price =[obj integerValue];
                order.activityPrice =[NSString stringWithFormat:@"%zd",price];
            }
            [cell setDetailOrderCell:order];
            
            return  cell;
        }else if (indexPath.section==2) {
            HK_orderInfoCell * infoCell =[tableView dequeueReusableCellWithIdentifier:@"orderInfo" forIndexPath:indexPath];
            [infoCell setOrderInfoCellWithModel:model];
            return infoCell;
        }
    }else if ([model.data.state isEqualToString:@"3"]){
        //第一组用地址模型
        if (indexPath.section==0) {
            HK_orderAddressCell * cell =[tableView dequeueReusableCellWithIdentifier:@"address" forIndexPath:indexPath];
            [cell setCellConfigueWithModel:model];
            cell.delegete = editUserAddressDelegete;
            return cell;
        }else if (indexPath.section==1) {
            HK_InfoTopCell * cell =[tableView dequeueReusableCellWithIdentifier:@"topInfo" forIndexPath:indexPath];
            [cell setConfigueWithModel:model];
            cell.messageLabel.text =@"您提交了订单,请等待第三方卖家确认";
            return cell;
        }else if (indexPath.section==2){
            HK_MyOrderCell *cell =[tableView dequeueReusableCellWithIdentifier:@"goodInfo" forIndexPath:indexPath];
            orderSubMitModel * order =[[orderSubMitModel alloc] init];
            NSDictionary *dict= (NSDictionary *)model.data.subList[indexPath.row];
            order.imgSrc =dict[@"imgSrc"];
            order.number = [dict[@"number"] integerValue];
            order.colorName =dict[@"colorName"];
            order.title =dict[@"title"];
            order.integral =[dict[@"integral"] doubleValue];
            order.specName =dict[@"specName"];
            order.activityType =dict[@"activityType"];
            id obj  =dict[@"activityPrice"];
            if ([obj isKindOfClass:[NSNull class]]) {
                
                order.activityPrice = 0;
            }else {
                NSInteger price =[obj integerValue];
                order.activityPrice =[NSString stringWithFormat:@"%zd",price];
            }
            [cell setDetailOrderCell:order];
            
            return  cell;
            
        }else if (indexPath.section==3) {
            
            HK_orderInfoCell * infoCell =[tableView dequeueReusableCellWithIdentifier:@"orderInfo" forIndexPath:indexPath];
            [infoCell setOrderInfoCellWithModel:model];
            return infoCell;
        }
        
    }else if ([model.data.state isEqualToString:@"1"]||[model.data.state isEqualToString:@"10"]||[model.data.state isEqualToString:@"8"]){
        //第一组用地址模型
        if (indexPath.section==0) {
            HK_orderAddressCell * cell =[tableView dequeueReusableCellWithIdentifier:@"address" forIndexPath:indexPath];
            [cell setCellConfigueWithModel:model];
            
            [cell.editAddressBtn setImage:[UIImage imageNamed:@"dynamic_write"] forState:UIControlStateNormal];
            
            cell.delegete = editUserAddressDelegete;
            return cell;
        }else if (indexPath.section==1){
            HK_MyOrderCell *cell =[tableView dequeueReusableCellWithIdentifier:@"goodInfo" forIndexPath:indexPath];
            orderSubMitModel * order =[[orderSubMitModel alloc] init];
            NSDictionary *dict= (NSDictionary *)model.data.subList[indexPath.row];
            order.imgSrc =dict[@"imgSrc"];
            order.number = [dict[@"number"] integerValue];
            order.colorName =dict[@"colorName"];
            order.title =dict[@"title"];
            order.integral =[dict[@"integral"] doubleValue];
            order.state =dict[@"state"];
            order.specName =dict[@"specName"];
            order.activityType =dict[@"activityType"];
            
            id obj  =dict[@"activityPrice"];
            if ([obj isKindOfClass:[NSNull class]]) {

                order.activityPrice = 0;
            }else {
                 NSInteger price =[obj integerValue];
                order.activityPrice =[NSString stringWithFormat:@"%zd",price];
            }
            //获取当前商品的卖家
            order.mediaUserId =model.data.mediaUserId;
            cell.delegete = editUserAddressDelegete;
            [cell setDetailOrderCell:order];
            return  cell;
        }else if (indexPath.section==2) {
            HK_orderInfoCell * infoCell =[tableView dequeueReusableCellWithIdentifier:@"orderInfo" forIndexPath:indexPath];
            [infoCell setOrderInfoCellWithModel:model];
            return infoCell;
        }
    }
    return [[UITableViewCell alloc] init];
}
#pragma mark 投诉或者举证
+(void)pushrderComplainVc:(NSString *)orderNumber andCurrentVc:(UIViewController *)controller withType:(int)type {
    HK_orderComplainVc *  complainVc =[[HK_orderComplainVc alloc] init];
    complainVc.orderNumber = orderNumber;
    complainVc.type =type;
    [controller.navigationController pushViewController:complainVc animated:YES];
    
}

#pragma mark 查看物流
+(void)pushOrderLogisticsVc:(HK_orderInfo *)model andCurrentVc:(UIViewController *)controller{
    //查看物流
//    HKLogisticsViewController*vc = [[HKLogisticsViewController alloc]init];
//
//    HKOrderInfoData*modelInfo = [[HKOrderInfoData alloc]init];
//    modelInfo.courier = model.data.courier;
//    modelInfo.courierNumber = model.data.courierNumber;
//    vc.model = modelInfo;
//    [controller.navigationController pushViewController:vc animated:YES];
   
    HK_transFerController * tansVC =[[HK_transFerController alloc] init];
    tansVC.transModel = model;
    [controller.navigationController pushViewController:tansVC animated:YES];
}

+(void)pushOrderReFundVc:(NSString *)orderNumber orderStatus:(UserOrderStatus)status orderType:(NSString *)types  andCurrentVc:(UIViewController *)controller {
    
    HK_playRefundController * refundVc =[[HK_playRefundController alloc] initWithNibName:@"HK_playRefundController" bundle:nil];
    refundVc.orderStatus = status;
    refundVc.orderNumber = orderNumber;
    refundVc.types =types;
    [controller.navigationController pushViewController:refundVc animated:YES];

}
+(NSString *)getDataStringFromTimeCount:(NSTimeInterval)timeInterval {
    int days = (int)(timeInterval/(3600*24));
    int hours = (int)((timeInterval-days*24*3600)/3600);
    int minutes = (int)(timeInterval-days*24*3600-hours*3600)/60;
    int seconds = timeInterval-days*24*3600-hours*3600-minutes*60;
    
    NSString *dayStr;NSString *hoursStr;NSString *minutesStr;NSString *secondsStr;
    //天
    dayStr = [NSString stringWithFormat:@"%d",days];
    //小时
    hoursStr = [NSString stringWithFormat:@"%d",hours];
    //分钟
    if(minutes<10)
        minutesStr = [NSString stringWithFormat:@"0%d",minutes];
    else
        minutesStr = [NSString stringWithFormat:@"%d",minutes];
    //秒
    if(seconds < 10)
        secondsStr = [NSString stringWithFormat:@"0%d", seconds];
    else
        secondsStr = [NSString stringWithFormat:@"%d",seconds];
    if (hours<=0&&minutes<=0&&seconds<=0) {
        return @"支付时间截止";
    }
    //    if (days) {
    //        return [NSString stringWithFormat:@"支付:%@:%@:%@:%@", dayStr,hoursStr, minutesStr,secondsStr];
    //    }
    return [NSString stringWithFormat:@"支付 %@:%@:%@",hoursStr , minutesStr,secondsStr];
    
}
+(NSTimeInterval)AgetCountTimeWithString:(NSString *)limitTime andNowTime:(NSString *)currentTime {
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    // 截止时间date格式
    NSDate  *expireDate = [formater dateFromString:limitTime];
    NSDate  *nowDate = [formater dateFromString:currentTime];
    NSTimeInterval timeInterval =[expireDate timeIntervalSinceDate:nowDate];
    
    return timeInterval;
}
@end
