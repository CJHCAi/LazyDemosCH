//
//  GenealogyInfoModel.m
//  FamilyTree
//
//  Created by 姚珉 on 16/7/14.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "GenealogyInfoModel.h"

@implementation GenealogyInfoModel
-(NSArray *)getTextMenuArr{
    NSMutableArray *menuArr = [@[] mutableCopy];
    if (!IsNilString(self.data.GeWords)) {
        [menuArr addObject:@"谱论"];
    }
    if (!IsNilString(self.data.GeIntroduction)) {
        [menuArr addObject:@"凡例"];
    }
    if (!IsNilString(self.data.GeTradition)) {
        [menuArr addObject:@"家风"];
    }
    if (!IsNilString(self.data.GeLaw)) {
        [menuArr addObject:@"家法"];
    }
    if (!IsNilString(self.data.GePrecepts)) {
        [menuArr addObject:@"家训"];
    }
    if (!IsNilString(self.data.GeWriter)) {
        [menuArr addObject:@"修谱名目"];
    }
    if (!IsNilString(self.data.GeLegend)) {
        [menuArr addObject:@"传记"];
    }
    if (!IsNilString(self.data.GeCustoms)) {
        [menuArr addObject:@"风俗礼仪"];
    }
    if (!IsNilString(self.data.GeClan)) {
        [menuArr addObject:@"族产"];
    }
    if (!IsNilString(self.data.GeContract)) {
        [menuArr addObject:@"契约"];
    }
    if (!IsNilString(self.data.GeBooks)) {
        [menuArr addObject:@"艺文著述"];
    }
    if (!IsNilString(self.data.GeHold)) {
        [menuArr addObject:@"领谱字号"];
    }
    if (!IsNilString(self.data.GeDisbut)) {
        [menuArr addObject:@"堂号分布"];
    }
    return [menuArr copy];
}

-(NSArray *)getTextInfoArr{
    NSMutableArray *infoArr = [@[] mutableCopy];
    if (!IsNilString(self.data.GeWords)) {
        [infoArr addObject:self.data.GeWords];
    }
    if (!IsNilString(self.data.GeIntroduction)) {
        [infoArr addObject:self.data.GeIntroduction];
    }
    if (!IsNilString(self.data.GeTradition)) {
        [infoArr addObject:self.data.GeTradition];
    }
    if (!IsNilString(self.data.GeLaw)) {
        [infoArr addObject:self.data.GeLaw];
    }
    if (!IsNilString(self.data.GePrecepts)) {
        [infoArr addObject:self.data.GePrecepts];
    }
    if (!IsNilString(self.data.GeWriter)) {
        [infoArr addObject:self.data.GeWriter];
    }
    if (!IsNilString(self.data.GeLegend)) {
        [infoArr addObject:self.data.GeLegend];
    }
    if (!IsNilString(self.data.GeCustoms)) {
        [infoArr addObject:self.data.GeCustoms];
    }
    if (!IsNilString(self.data.GeClan)) {
        [infoArr addObject:self.data.GeClan];
    }
    if (!IsNilString(self.data.GeContract)) {
        [infoArr addObject:self.data.GeContract];
    }
    if (!IsNilString(self.data.GeBooks)) {
        [infoArr addObject:self.data.GeBooks];
    }
    if (!IsNilString(self.data.GeHold)) {
        [infoArr addObject:self.data.GeHold];
    }
    if (!IsNilString(self.data.GeDisbut)) {
        [infoArr addObject:self.data.GeDisbut];
    }
    return [infoArr copy];
}



-(NSArray *)getImageMenuArr{
    NSMutableArray *menuArr = [@[] mutableCopy];
    if (self.Fm.count != 0) {
        [menuArr addObject:@"封面"];
    }
    if (self.Ml.count != 0) {
        [menuArr addObject:@"目录"];
    }
    if (self.Tt.count != 0) {
        [menuArr addObject:@"图腾"];
    }
    if (self.Zx.count != 0) {
        [menuArr addObject:@"祖先像赞"];
    }
    if (self.Erl.count != 0){
        [menuArr addObject:@"恩荣录"];
    }
    if (self.Px.count != 0) {
        [menuArr addObject:@"谱序"];
    }
    if (self.Lz.count != 0) {
        [menuArr addObject:@"老宅"];
    }
    if (self.Ct.count != 0) {
        [menuArr addObject:@"祠堂"];
    }
    if (self.Fy.count != 0) {
        [menuArr addObject:@"坟茔"];
    }
    return [menuArr copy];

}

-(NSArray *)getImageInfoArr{
    NSMutableArray *infoArr = [@[] mutableCopy];
    if (self.Fm.count != 0) {
        [infoArr addObject:self.Fm];
    }
    if (self.Ml.count != 0) {
        [infoArr addObject:self.Ml];
    }
    if (self.Tt.count != 0) {
        [infoArr addObject:self.Tt];
    }
    if (self.Zx.count != 0) {
        [infoArr addObject:self.Zx];
    }
    if (self.Erl.count != 0){
        [infoArr addObject:self.Erl];
    }
    if (self.Px.count != 0) {
        [infoArr addObject:self.Px];
    }
    if (self.Lz.count != 0) {
        [infoArr addObject:self.Lz];
    }
    if (self.Ct.count != 0) {
        [infoArr addObject:self.Ct];
    }
    if (self.Fy.count != 0) {
        [infoArr addObject:self.Fy];
    }
    return [infoArr copy];
    
}



@end
@implementation GenealogyInfoDataModel

@end


