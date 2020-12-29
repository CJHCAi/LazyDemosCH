//
//Created by ESJsonFormatForMac on 18/09/12.
//

#import <Foundation/Foundation.h>

@class UserTagData,HK_Systemlabels,HK_Childrenlabels;
@interface HK_UserTagResponse : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) UserTagData *data;

@property (nonatomic, assign) NSInteger code;


@end
@interface UserTagData : NSObject

@property (nonatomic, strong) NSArray * userlabels;

@property (nonatomic, strong) NSArray<HK_Systemlabels *> *systemlabels;

@end


@interface HK_Systemlabels : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSArray<HK_Childrenlabels *> *childrenlabels;

@property (nonatomic, copy) NSString * ID;

@end

@interface HK_Childrenlabels : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *ID;

@end

