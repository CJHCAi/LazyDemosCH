//
//Created by ESJsonFormatForMac on 18/09/04.
//

#import <Foundation/Foundation.h>

@class HKAfterSaleModel;
@interface HKAfterSaleRespone : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HKAfterSaleModel *data;
@property (nonatomic, copy) NSString* code;

@property (nonatomic,assign) BOOL responeSuc;
  
@end
@interface HKAfterSaleModel : NSObject

@property (nonatomic, copy) NSString *buyerProofDesc;

@property (nonatomic, copy) NSString *refuseGoodsDate;

@property (nonatomic, copy) NSString *provinceId;

@property (nonatomic, copy) NSString *courier;

@property (nonatomic, strong) NSArray *refuseregoodsImgs;

@property (nonatomic, copy) NSString *refundTelephone;

@property (nonatomic, strong) NSArray *refuserefundImgs;

@property (nonatomic, copy) NSString *limitDate;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, strong) NSArray *sellerImgs;

@property (nonatomic, copy) NSString *refundcontact;

@property (nonatomic, copy) NSString *refuserefundDate;

@property (nonatomic, copy) NSString *agreeRefundDate;

@property (nonatomic, strong) NSArray *complaintsImgs;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *buyerProof;

@property (nonatomic, copy) NSString *consignee;

@property (nonatomic, copy) NSString *currentTime;

@property (nonatomic, copy) NSString *cancelRefundDate;

@property (nonatomic, copy) NSString *cancelDate;

@property (nonatomic, copy) NSString *refundsDate;

@property (nonatomic, copy) NSString *afterState;

@property (nonatomic, copy) NSString *refundAmount;

@property (nonatomic, copy) NSString *complaintReason;

@property (nonatomic, copy) NSString *courierNumber;

@property (nonatomic, strong) NSArray *buyerImgs;

@property (nonatomic, copy) NSString *sellerProofDate;

@property (nonatomic, copy) NSString *approvalRefundDate;

@property (nonatomic, copy) NSString *cityId;

@property (nonatomic, copy) NSString *refuserefundReason;

@property (nonatomic, copy) NSString *complaintDesc;

@property (nonatomic, copy) NSString *sellerProofDesc;

@property (nonatomic, copy) NSString *afterId;

@property (nonatomic, copy) NSString *buyerProofDate;

@property (nonatomic, copy) NSString *sellerProof;

@property (nonatomic, copy) NSString *complaintDate;

@property (nonatomic, copy) NSString *refundReason;

@property (nonatomic, copy) NSString *refusereGoodsReason;

@property (nonatomic, copy) NSString *courierDate;

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *applyDate;

@property (nonatomic, copy) NSString *areaId;
@property (nonatomic, strong)NSMutableArray *cellArray;
@end

