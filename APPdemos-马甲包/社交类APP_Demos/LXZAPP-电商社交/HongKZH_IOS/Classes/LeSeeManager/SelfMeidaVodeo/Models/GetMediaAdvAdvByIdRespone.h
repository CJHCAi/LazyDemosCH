//
//Created by ESJsonFormatForMac on 18/09/19.
//

#import <Foundation/Foundation.h>
#import "HKBaseModelRespone.h"
@class GetMediaAdvAdvByIdsData,Photographys,GetMediaAdvAdvByIdTags,GetMediaAdvAdvByIdsAlbums,GetMediaAdvAdvByIdProducts;
@interface GetMediaAdvAdvByIdRespone : HKBaseModelRespone

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) GetMediaAdvAdvByIdsData *data;


@end
@interface GetMediaAdvAdvByIdsData : NSObject
@property(nonatomic, assign) BOOL isPlay;
@property (nonatomic, copy)NSString *playId;
@property (nonatomic, copy) NSString *nextMediaAdvId;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *coverImgWidth;

@property (nonatomic, copy) NSString *coverImgHeight;

@property (nonatomic, copy) NSString *introduce;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *seeking;

@property (nonatomic, assign) NSInteger level;

@property (nonatomic, copy) NSString *imgNote;

@property (nonatomic, copy) NSString *playCount;

@property (nonatomic, copy) NSString *uName;

@property (nonatomic, copy) NSString *collectionCount;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *commentCount;

@property (nonatomic, strong) NSArray<Photographys *> *photographys;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *praiseId;

@property (nonatomic, copy) NSString *imgLinks;

@property (nonatomic, copy) NSString *sex;

@property (nonatomic, copy) NSString *categoryName;

@property (nonatomic, copy) NSString *introduction;

@property (nonatomic, copy) NSString *height;

@property (nonatomic, copy) NSString *praiseCount;

@property (nonatomic, copy) NSString *rewardCount;

@property (nonatomic, copy) NSString *collectionId;

@property (nonatomic, copy) NSString *collectionState;

@property (nonatomic, copy) NSString *cityName;

@property (nonatomic, copy) NSString *remarks;

@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, strong) NSArray<GetMediaAdvAdvByIdTags *> *tags;

@property (nonatomic, copy) NSString *zhaopin;

@property (nonatomic, strong) NSArray<GetMediaAdvAdvByIdsAlbums *> *albums;

@property (nonatomic, copy) NSString *imgRank;

@property (nonatomic, copy) NSString *coverImgSrc;

@property (nonatomic, copy) NSString *praiseState;

@property (nonatomic, assign) NSInteger age;

@property (nonatomic, copy) NSString *imgSrc;

@property (nonatomic, strong) NSArray<GetMediaAdvAdvByIdProducts *> *products;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *headImg;

@property (nonatomic, copy) NSString *mediaType;


@property (nonatomic, copy)NSString *note;
@property (nonatomic, copy)NSString *utype;
@property (nonatomic, copy)NSString *cityAdvId;
@property (nonatomic, copy)NSString *isweb;

@property (nonatomic,assign) NSInteger  isRed;
@end

@interface Photographys : NSObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *imgSrc;

@end

@interface GetMediaAdvAdvByIdTags : NSObject

@property (nonatomic, copy) NSString *tagId;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *tagName;
@property (nonatomic, copy)NSString *name;

@end

@interface GetMediaAdvAdvByIdsAlbums : NSObject

@property (nonatomic, copy) NSString *imgSrc;

@end

@interface GetMediaAdvAdvByIdProducts : NSObject

@property (nonatomic, assign) NSInteger num;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *imgSrc;

@property (nonatomic, copy) NSString *productId;

@property (nonatomic, assign) NSInteger price;

@property (nonatomic, copy) NSString *createDate;

@end

