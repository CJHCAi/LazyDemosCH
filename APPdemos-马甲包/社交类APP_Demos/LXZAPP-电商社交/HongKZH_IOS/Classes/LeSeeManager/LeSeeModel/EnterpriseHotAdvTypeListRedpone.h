//
//Created by ESJsonFormatForMac on 18/09/13.
//

#import <Foundation/Foundation.h>

@class EnterpriseHotAdvTypeListModel;
@interface EnterpriseHotAdvTypeListRedpone : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) NSArray<EnterpriseHotAdvTypeListModel *> *data;

@property (nonatomic, copy) NSString* code;

@property (nonatomic,assign) BOOL responeSuc;
@property (nonatomic,assign) NSInteger selectIndex;
@property (nonatomic,assign) NSInteger selectItem;
@property (nonatomic,assign) NSInteger difference;
@end
@interface EnterpriseHotAdvTypeListModel : NSObject

@property (nonatomic, copy) NSString *typeId;

@property (nonatomic, assign) NSInteger currentHour;

@property (nonatomic, copy) NSString *currentTime;

@property (nonatomic, assign) NSInteger endDate;

@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic, assign) NSInteger sortDate;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger beginDate;



@end

