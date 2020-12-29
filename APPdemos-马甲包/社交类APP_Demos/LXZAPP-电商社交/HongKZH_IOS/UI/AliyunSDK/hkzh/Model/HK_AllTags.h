//
//Created by ESJsonFormatForMac on 18/07/27.
//

#import <Foundation/Foundation.h>

@class HK_AllTagsData,HK_AllTagsHis,HK_AllTagsCircles,HK_AllTagsRecommends;
@interface HK_AllTags : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HK_AllTagsData *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface HK_AllTagsData : NSObject

@property (nonatomic, strong) NSArray<HK_AllTagsHis *> *his;

@property (nonatomic, strong) NSArray<HK_AllTagsCircles *> *circles;

@property (nonatomic, strong) NSArray<HK_AllTagsRecommends *> *recommends;

@end

@interface HK_AllTagsHis : NSObject     //[tagId 标签id tag 名称 type 1圈子 2用户 3自定义] 

@property (nonatomic, copy) NSString *tagId;

@property (nonatomic, copy) NSString *tag;

@property (nonatomic, copy) NSString *type;

@end

@interface HK_AllTagsCircles : NSObject

@property (nonatomic, copy) NSString *tagId;

@property (nonatomic, assign) NSInteger allCount;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *tag;

@end

@interface HK_AllTagsRecommends : NSObject

@property (nonatomic, copy) NSString *tagId;

@property (nonatomic, assign) NSInteger allCount;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *tag;

@end

