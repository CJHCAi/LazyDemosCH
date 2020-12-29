//
//Created by ESJsonFormatForMac on 18/09/08.
//

#import <Foundation/Foundation.h>

@class USerData;
@interface HK_UserInfoDataModel : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) USerData *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface USerData : NSObject

@property (nonatomic, assign) double integral;;

@end

