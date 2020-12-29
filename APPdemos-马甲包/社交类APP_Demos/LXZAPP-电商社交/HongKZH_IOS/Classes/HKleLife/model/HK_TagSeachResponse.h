//
//Created by ESJsonFormatForMac on 18/09/25.
//

#import <Foundation/Foundation.h>

@class HK_SeachData;
@interface HK_TagSeachResponse : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) NSArray<HK_SeachData *> *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface HK_SeachData : NSObject

@property (nonatomic, copy) NSString *tag;

@property (nonatomic, assign) NSInteger allCount;

@property (nonatomic, copy) NSString *type;

@end

