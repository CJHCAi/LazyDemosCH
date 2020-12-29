//
//Created by ESJsonFormatForMac on 18/09/21.
//

#import <Foundation/Foundation.h>
#import "HKBaseModelRespone.h"
@class AllProductByUsersDatas,AllProductByUsersList;
@interface AllProductByUserRespone : HKBaseModelRespone

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) AllProductByUsersDatas *data;

//@property (nonatomic, assign) NSInteger code;

@end
@interface AllProductByUsersDatas : NSObject

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger totalRow;

@property (nonatomic, assign) NSInteger pageNumber;

@property (nonatomic, assign) BOOL lastPage;

@property (nonatomic, assign) BOOL firstPage;

@property (nonatomic, strong) NSArray<AllProductByUsersList *> *list;

@property (nonatomic, assign) NSInteger totalPage;

@end

@interface AllProductByUsersList : NSObject

@property (nonatomic, copy) NSString *imgSrc;

@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, assign) NSInteger price;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *rank;

@property (nonatomic, assign) NSInteger orderNum;

@property (nonatomic, assign) NSInteger preorderNum;

@property (nonatomic, copy) NSString *state;

@end

