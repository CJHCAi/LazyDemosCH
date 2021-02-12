//
//  IAPHelper.h
//
//  Original Created by Ray Wenderlich on 2/28/11.
//  Created by saturngod on 7/9/12.
//  Copyright 2011 Ray Wenderlich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StoreKit/StoreKit.h"


typedef void (^IAPProductsResponseBlock)(SKProductsRequest* request , SKProductsResponse* response);

typedef void (^IAPbuyProductCompleteResponseBlock)(SKPaymentTransaction* transcation);

typedef void (^checkReceiptCompleteResponseBlock)(NSString* response,NSError* error);

typedef void (^resoreProductsCompleteResponseBlock) (SKPaymentQueue* payment,NSError* error);

@interface IAPHelper : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property (nonatomic,strong) NSSet *productIdentifiers;
@property (nonatomic,strong) NSArray * products;
@property (nonatomic,strong) NSMutableSet *purchasedProducts;
@property (nonatomic,strong) SKProductsRequest *request;
@property (nonatomic) BOOL production;

//用产品标识符初始化
- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;

//产品列表
- (void)requestProductsWithCompletion:(IAPProductsResponseBlock)completion;


//购买产品
- (void)buyProduct:(SKProduct *)productIdentifier onCompletion:(IAPbuyProductCompleteResponseBlock)completion;

//恢复产品
- (void)restoreProductsWithCompletion:(resoreProductsCompleteResponseBlock)completion;

//是否被购买
- (BOOL)isPurchasedProductsIdentifier:(NSString*)productID;

//检查收据，但建议在服务器端使用，而不是使用这个函数
- (void)checkReceipt:(NSData*)receiptData onCompletion:(checkReceiptCompleteResponseBlock)completion;

- (void)checkReceipt:(NSData*)receiptData AndSharedSecret:(NSString*)secretKey onCompletion:(checkReceiptCompleteResponseBlock)completion;


//保存购买产品
- (void)provideContentWithTransaction:(SKPaymentTransaction *)transaction;

- (void)provideContent:(NSString *)productIdentifier __deprecated_msg("use provideContentWithTransaction: instead.");

//清除保存的产品
- (void)clearSavedPurchasedProducts;
- (void)clearSavedPurchasedProductByID:(NSString*)productIdentifier;


//用当地货币获得价格
- (NSString *)getLocalePrice:(SKProduct *)product;

@end
