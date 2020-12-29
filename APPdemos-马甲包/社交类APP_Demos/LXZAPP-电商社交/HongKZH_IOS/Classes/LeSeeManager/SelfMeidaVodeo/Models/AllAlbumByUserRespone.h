//
//Created by ESJsonFormatForMac on 18/09/21.
//

#import <Foundation/Foundation.h>
#import "HKBaseModelRespone.h"
@class AllAlbumByUserDatas,AllAlbumByUserDataModel;
@interface AllAlbumByUserRespone : HKBaseModelRespone

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) AllAlbumByUserDatas *data;

//@property (nonatomic, assign) NSInteger code;

@end
@interface AllAlbumByUserDatas : NSObject

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger totalRow;

@property (nonatomic, assign) NSInteger pageNumber;

@property (nonatomic, assign) BOOL lastPage;

@property (nonatomic, assign) BOOL firstPage;

@property (nonatomic, strong) NSArray<AllAlbumByUserDataModel *> *list;

@property (nonatomic, assign) NSInteger totalPage;

@end

@interface AllAlbumByUserDataModel : NSObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *coverPhoto;

@property (nonatomic, strong) NSArray *details;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *rank;

@property (nonatomic, assign) NSInteger viewCount;

@end

