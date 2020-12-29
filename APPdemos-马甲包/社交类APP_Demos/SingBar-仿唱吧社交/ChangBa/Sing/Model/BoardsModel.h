//
//  BoardsModel.h
//  ChangBa
//
//  Created by V.Valentino on 16/9/21.
//  Copyright © 2016年 huyifan. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface BoardsModel : JSONModel
@property (nonatomic, strong) NSString *boardsIdentifier;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *headPhoto;
@property (nonatomic, strong) NSString *title;

@end
