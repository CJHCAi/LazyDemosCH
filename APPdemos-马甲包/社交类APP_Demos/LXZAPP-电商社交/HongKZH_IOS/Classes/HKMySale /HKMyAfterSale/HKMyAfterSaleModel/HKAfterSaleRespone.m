//
//Created by ESJsonFormatForMac on 18/09/04.
//

#import "HKAfterSaleRespone.h"
@implementation HKAfterSaleRespone
-(void)setCode:(NSString *)code{
    _code = code;
    if (code.length>0&&code.intValue == 0) {
        self.responeSuc = YES;
    }else{
        self.responeSuc = NO;
    }
}
-(void)setData:(HKAfterSaleModel *)data{
    _data = data;
    AfterSaleViewStatue statue = data.afterState.intValue;
    switch (statue) {
        case AfterSaleViewStatue_Application:
        {
            [self.data.cellArray addObject:@(AfterSaleViewStatue_Application)];
        }
            break;
        case AfterSaleViewStatue_cancel:
        {
            [self.data.cellArray addObject:@(AfterSaleViewStatue_cancel)];
         //如果买家拒绝过
            if (self.data.refuserefundDate.length >0) {
            [self.data.cellArray addObject:@(AfterSaleViewStatue_Refuse)];
            }
            [self.data.cellArray addObject:@(AfterSaleViewStatue_Application)];
            
        }
            break;
        case AfterSaleViewStatue_Agree:
        {
            
            [self.data.cellArray addObject:@(AfterSaleViewStatue_Agree)];
            [self.data.cellArray addObject:@(AfterSaleViewStatue_Application)];
            
        }
            break;
        case AfterSaleViewStatue_finish:
        {
            
            [self.data.cellArray addObject:@(AfterSaleViewStatue_finish)];
            [self.data.cellArray addObject:@(AfterSaleViewStatue_Agree)];
            [self.data.cellArray addObject:@(AfterSaleViewStatue_Application)];
            
        }
            break;
            
        case AfterSaleViewStatue_ApplicationReturn:
        {
            [self.data.cellArray addObject:@(AfterSaleViewStatue_ApplicationReturn)];
        }
            break;
        case AfterSaleViewStatue_SendReturnDelivery:
        {
            
            
            [self.data.cellArray addObject:@(AfterSaleViewStatue_SendReturnDelivery)];
            [self.data.cellArray addObject:@(AfterSaleViewStatue_AgreeReturn)];
            [self.data.cellArray addObject:@(AfterSaleViewStatue_ApplicationReturn)];
        }
            break;
        case AfterSaleViewStatue_AgreeReturn:
        {
            
            
            [self.data.cellArray addObject:@(AfterSaleViewStatue_AgreeReturn)];
            [self.data.cellArray addObject:@(AfterSaleViewStatue_ApplicationReturn)];
        }
            break;
        case AfterSaleViewStatue_ReturnFinish:
        {
            
            [self.data.cellArray addObject:@(AfterSaleViewStatue_ReturnFinish)];
            [self.data.cellArray addObject:@(AfterSaleViewStatue_SendReturnDelivery)];
            [self.data.cellArray addObject:@(AfterSaleViewStatue_AgreeReturn)];
            [self.data.cellArray addObject:@(AfterSaleViewStatue_Application)];
        }
            break;
        case AfterSaleViewStatue_Refuse:
        {
            
            [self.data.cellArray addObject:@(AfterSaleViewStatue_Refuse)];
     
            [self.data.cellArray addObject:@(AfterSaleViewStatue_Application)];
        }
            break;
        case AfterSaleViewStatue_RefuseReturn:
        {
            
            [self.data.cellArray addObject:@(AfterSaleViewStatue_RefuseReturn)];
            
            [self.data.cellArray addObject:@(AfterSaleViewStatue_ApplicationReturn)];
        }
            break;
        case AfterSaleViewStatue_Complaint:
        {
            
            [self.data.cellArray addObject:@(AfterSaleViewStatue_Complaint)];
            if (self.data.consignee.length>0) {
                //退货退款投诉
                [self.data.cellArray addObject:@(AfterSaleViewStatue_RefuseReturn)];
                
                [self.data.cellArray addObject:@(AfterSaleViewStatue_ApplicationReturn)];
            }else{
                //退款投诉
                
                [self.data.cellArray addObject:@(AfterSaleViewStatue_Refuse)];
                
                [self.data.cellArray addObject:@(AfterSaleViewStatue_Application)];
            }
           
        }
            break;
        case AfterSaleViewStatue_cancelComplaint:
        {
            [self.data.cellArray addObject:@(AfterSaleViewStatue_cancelComplaint)];
            if (self.data.buyerProofDate.length>0) {
                [self.data.cellArray addObject:@(AfterSaleViewStatue_ProofOfBuyer)];
            }
            if (self.data.sellerProofDate.length>0) {
                [self.data.cellArray addObject:@(AfterSaleViewStatue_ProofOfBuyerseller)];
            }
            [self.data.cellArray addObject:@(AfterSaleViewStatue_Complaint)];
            if (self.data.consignee.length>0) {
                //取消退货退款投诉
                [self.data.cellArray addObject:@(AfterSaleViewStatue_RefuseReturn)];
                
                [self.data.cellArray addObject:@(AfterSaleViewStatue_ApplicationReturn)];
            }else{
                //取消退款投诉

                [self.data.cellArray addObject:@(AfterSaleViewStatue_Refuse)];
                
                [self.data.cellArray addObject:@(AfterSaleViewStatue_Application)];
            }
            
        }
            break;
        case AfterSaleViewStatue_ProofOfBuyerseller:{
            
            if (self.data.consignee.length>0) {
                //退货退款投诉卖家
                [self.data.cellArray addObject:@(AfterSaleViewStatue_ProofOfBuyerseller)];
                [self.data.cellArray addObject:@(AfterSaleViewStatue_Complaint)];
                [self.data.cellArray addObject:@(AfterSaleViewStatue_RefuseReturn)];
                
                [self.data.cellArray addObject:@(AfterSaleViewStatue_ApplicationReturn)];
            }else{
                //退款投诉卖家
                 [self.data.cellArray addObject:@(AfterSaleViewStatue_ProofOfBuyerseller)];
                [self.data.cellArray addObject:@(AfterSaleViewStatue_Complaint)];
                [self.data.cellArray addObject:@(AfterSaleViewStatue_Refuse)];
                
                [self.data.cellArray addObject:@(AfterSaleViewStatue_Application)];
            }
            
        }
            break;
        case AfterSaleViewStatue_ProofOfBuyer:{
            [self.data.cellArray addObject:@(AfterSaleViewStatue_ProofOfBuyer)];
            [self.data.cellArray addObject:@(AfterSaleViewStatue_ProofOfBuyerseller)];
            [self.data.cellArray addObject:@(AfterSaleViewStatue_Complaint)];
            if (self.data.consignee.length>0) {
                //退货退款投诉买家
             
                [self.data.cellArray addObject:@(AfterSaleViewStatue_RefuseReturn)];
                
                [self.data.cellArray addObject:@(AfterSaleViewStatue_ApplicationReturn)];
            }else{
                //退款投诉买家
        
                [self.data.cellArray addObject:@(AfterSaleViewStatue_Refuse)];
                
                [self.data.cellArray addObject:@(AfterSaleViewStatue_Application)];
            }
            
        }
            break;
        case AfterSaleViewStatue_cancelApplicationReturn:
        {
            [self.data.cellArray addObject:@(AfterSaleViewStatue_cancelApplicationReturn)];
            
            if (self.data.buyerProofDate.length>0) {
              [self.data.cellArray addObject:@(AfterSaleViewStatue_ProofOfBuyer)];
            }
            if (self.data.sellerProofDate.length>0) {
              [self.data.cellArray addObject:@(AfterSaleViewStatue_ProofOfBuyerseller)];
            }
            if (self.data.complaintDate.length>0) {
//                已投诉
                [self.data.cellArray addObject:@(AfterSaleViewStatue_Complaint)];
            }
          //判断是买家主动取消 还是商家拒绝过
            if (self.data.refuseGoodsDate.length>0) {
                 [self.data.cellArray addObject:@(AfterSaleViewStatue_RefuseReturn)];
            }
            [self.data.cellArray addObject:@(AfterSaleViewStatue_ApplicationReturn)];
        }
            break;
        default:
            break;
    }
}
@end
@implementation HKAfterSaleModel
- (NSMutableArray *)cellArray
{
    if(_cellArray == nil)
    {
      _cellArray = [ NSMutableArray array];
    }
    return _cellArray;
}
@end


