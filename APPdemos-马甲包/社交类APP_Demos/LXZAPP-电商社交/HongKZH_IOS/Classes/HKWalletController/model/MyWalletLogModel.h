//
//Created by ESJsonFormatForMac on 18/08/27.
//

#import <Foundation/Foundation.h>

@class WalletData,WalletList;
@interface MyWalletLogModel : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) WalletData *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface WalletData : NSObject

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger totalRow;

@property (nonatomic, assign) NSInteger pageNumber;

@property (nonatomic, assign) BOOL lastPage;

@property (nonatomic, assign) BOOL firstPage;

@property (nonatomic, strong) NSArray<WalletList *> *list;

@property (nonatomic, assign) NSInteger totalPage;

@end

@interface WalletList : NSObject

@property (nonatomic, copy) NSString *remarks;

@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, assign) double integral;;

@property (nonatomic, copy) NSString *logId;
//1是收入 0是支出
@property (nonatomic, copy) NSString *type;

@end

