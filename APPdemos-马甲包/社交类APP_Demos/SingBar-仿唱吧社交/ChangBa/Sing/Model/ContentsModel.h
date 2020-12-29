//
//  ContentsModel.h
//  ChangBa
//
//  Created by V.Valentino on 16/9/21.
//  Copyright © 2016年 huyifan. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ContentsModel : JSONModel
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSArray *songs;
@property (nonatomic, strong) NSString *contentsIdentifier;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray *reliations;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *headPhoto;

@end
