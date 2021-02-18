//
//  CreateFamModel.h
//  FamilyTree
//
//  Created by 王子豪 on 16/6/24.
//  Copyright © 2016年 王子豪. All rights rese

//

#import <Foundation/Foundation.h>



@class Data;
@interface CreateFamModel : NSObject


@property (nonatomic, strong) Data *data;

@property (nonatomic, strong) NSArray *Lz;

@property (nonatomic, strong) NSArray *Px;

@property (nonatomic, strong) NSArray *Fy;

@property (nonatomic, strong) NSArray *Ct;



@end

@interface Data : NSObject

@property (nonatomic, copy) NSString *GeContract;

@property (nonatomic, copy) NSString *GeKeepstr02;

@property (nonatomic, assign) NSInteger GeKeepnum01;

@property (nonatomic, copy) NSString *GeSurname;

@property (nonatomic, copy) NSString *GeUpdatetime;

@property (nonatomic, copy) NSString *GePrecepts;

@property (nonatomic, copy) NSString *GePhoto;

@property (nonatomic, copy) NSString *GeTree;

@property (nonatomic, copy) NSString *GeKeepstr01;

@property (nonatomic, copy) NSString *GeHoner;

@property (nonatomic, copy) NSString *GeTradition;

@property (nonatomic, copy) NSString *GeJpname;

@property (nonatomic, copy) NSString *GeLaw;

@property (nonatomic, copy) NSString *GeLegend;

@property (nonatomic, copy) NSString *GeWriter;

@property (nonatomic, copy) NSString *GeCustoms;

@property (nonatomic, copy) NSString *GeKeepdate;

@property (nonatomic, copy) NSString *GeCheckstate;

@property (nonatomic, copy) NSString *GeIsneedchk;

@property (nonatomic, assign) NSInteger GeCreatemeid;

@property (nonatomic, copy) NSString *GeName;

@property (nonatomic, assign) NSInteger GeId;

@property (nonatomic, copy) NSString *GeWords;

@property (nonatomic, copy) NSString *GeGrave;

@property (nonatomic, copy) NSString *GeOperuser;

@property (nonatomic, assign) NSInteger GeAreacodeid;

@property (nonatomic, copy) NSString *GeIntroduction;

@property (nonatomic, copy) NSString *GeBooks;

@property (nonatomic, copy) NSString *GeHold;

@property (nonatomic, copy) NSString *GeDisbut;

@property (nonatomic, copy) NSString *GeCover;

@property (nonatomic, copy) NSString *GeLogo;

@property (nonatomic, copy) NSString *GeIndex;

@property (nonatomic, copy) NSString *GeExtension;

@property (nonatomic, copy) NSString *GeClan;

@property (nonatomic, copy) NSString *GeCreatetime;

@property (nonatomic, assign) NSInteger GeKeepnum02;

@property (nonatomic, copy) NSString *GePreface;

@property (nonatomic, copy) NSString *GeMemo;

@property (nonatomic, copy) NSString *GeAncehall;

@end

