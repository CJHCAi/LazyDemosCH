//
//Created by ESJsonFormatForMac on 18/08/07.
//

#import <Foundation/Foundation.h>

@class HKMyVideoCategoryData;
@interface HKMyVideoCategory : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) NSArray<HKMyVideoCategoryData *> *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface HKMyVideoCategoryData : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *categoryId;

@end

