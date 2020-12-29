//
//Created by ESJsonFormatForMac on 18/10/11.
//

#import <Foundation/Foundation.h>
#import "HKBaseModelRespone.h"
@class SearchGoodsData,HKSearchModels;
@interface SearchGoodsRespone : HKBaseModelRespone

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) SearchGoodsData *data;

//@property (nonatomic, assign) NSInteger code;

@end
@interface SearchGoodsData : NSObject

@property (nonatomic, strong) NSMutableArray<HKSearchModels*> *hosts;

@property (nonatomic, strong) NSMutableArray<HKSearchModels*> *historys;

@end

