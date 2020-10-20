//
//  ExampleDataTool.m
//  drawDrawFamilyTree
//
//  Created by Nicole on 2018/3/16.
//  Copyright © 2018年 Nicole. All rights reserved.
//

#import "ExampleDataTool.h"
#import "NSObject+YYModel.h"

@implementation ExampleDataTool

+ (FamilyModel *)getFamilyModelFromLocalExampleData{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ExampleData" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    FamilyModel *model = [FamilyModel modelWithJSON:json];
    
    return model;
}

@end
