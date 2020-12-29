//
//  RecommendBannersModel.h
//  ChangBa
//
//  Created by V.Valentino on 16/9/21.
//  Copyright © 2016年 huyifan. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface RecommendBannersModel : JSONModel
@property (nonatomic, strong) NSString *target;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *recommendBannersIdentifier;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *bannershow_cb;
@property (nonatomic, strong) NSString *forwardType;
@property (nonatomic, strong) NSString *headPhoto;

@end
