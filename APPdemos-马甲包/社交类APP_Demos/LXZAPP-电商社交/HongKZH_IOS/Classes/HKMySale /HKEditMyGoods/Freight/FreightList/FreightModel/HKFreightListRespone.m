//
//Created by ESJsonFormatForMac on 18/10/26.
//

#import "HKFreightListRespone.h"
#import "HKUpdataFromDataModel.h"
@implementation HKFreightListRespone

+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [HKFreightListData class]};
}

@end

@implementation HKFreightListData

+ (NSDictionary *)objectClassInArray{
    return @{@"sublist" : [HKFreightListSublist class]};
}
-(NSMutableArray<HKFreightListSublist *> *)sublist{
    if (!_sublist) {
        _sublist = [NSMutableArray array];
    }
    return _sublist;
}
-(void)getParameterSuccess:(void (^)(NSDictionary*parameter,NSMutableArray*uplodaArray))success{
     NSDictionary * dic = @{kloginUid:HKUSERLOGINID,@"freightId":self.freightId.length>0?self.freightId:@"",@"name":self.name,@"isExcept":self.isExcept,@"provinceId":self.provinceId,@"piece":@(self.piece),@"money":@(self.money),@"addPiece":@(self.addPiece),@"addMoney":@(self.addMoney)};
    NSMutableArray*uplodaArray = [NSMutableArray array];
    for (HKFreightListSublist*subListM in self.sublist) {
        HKUpdataFromDataModel*areafreightIdM = [[HKUpdataFromDataModel alloc]init];
        areafreightIdM.name = @"areafreightId";
        areafreightIdM.vaule = subListM.areafreightId.length>0?subListM.areafreightId:@"";
        [uplodaArray addObject:areafreightIdM];
        HKUpdataFromDataModel*subprovinceIdM = [[HKUpdataFromDataModel alloc]init];
        subprovinceIdM.name = @"subprovinceId";
        subprovinceIdM.vaule = subListM.provinceId.length>0?subListM.provinceId:@"";
        [uplodaArray addObject:subprovinceIdM];
        
        HKUpdataFromDataModel*subpiece = [[HKUpdataFromDataModel alloc]init];
        subpiece.name = @"subpiece";
        subpiece.vaule = [NSString stringWithFormat:@"%ld",subListM.piece] ;
        [uplodaArray addObject:subpiece];
        
        HKUpdataFromDataModel*submoney = [[HKUpdataFromDataModel alloc]init];
        submoney.name = @"submoney";
        submoney.vaule = [NSString stringWithFormat:@"%ld",subListM.money] ;
        [uplodaArray addObject:submoney];
        
        HKUpdataFromDataModel*subaddPiece = [[HKUpdataFromDataModel alloc]init];
        subaddPiece.name = @"subaddPiece";
        subaddPiece.vaule = [NSString stringWithFormat:@"%ld",subListM.addPiece] ;
        [uplodaArray addObject:subaddPiece];
        
        HKUpdataFromDataModel*subaddMoney = [[HKUpdataFromDataModel alloc]init];
        subaddMoney.name = @"subaddMoney";
        subaddMoney.vaule = [NSString stringWithFormat:@"%ld",subListM.addMoney] ;
        [uplodaArray addObject:subaddMoney];
    }
    success(dic,uplodaArray);
}
-(void)setIsHasNotInput:(BOOL)isHasNotInput{
    _isHasNotInput = isHasNotInput;
    if (!isHasNotInput) {
       
        for (HKFreightListSublist*subListM in self.sublist) {
            if (subListM.isHasNotInput) {
                _isHasNotInput = YES;
                break;
            }
        }
    }
}
-(NSArray*)allSelectPeovince:(NSString*)idString{
    NSArray*selectedId = [idString componentsSeparatedByString:@","];
    NSMutableArray*selectArray = [NSMutableArray array];
        NSString*proStr;
        if ([[self.provinceId substringWithRange:NSMakeRange(self.provinceId.length-1, 1)]isEqualToString:@","]) {
            proStr = [self.provinceId substringToIndex:self.provinceId.length-1];
        }else{
            proStr = self.provinceId;
        }
        NSArray*proArray = [proStr componentsSeparatedByString:@","];
    for (NSString*str in proArray) {
        BOOL isHas = NO;
        for (NSString*idStr in selectedId) {
            if ([idStr isEqualToString:str]) {
                isHas = YES;
                break;
            }
        }
        if (!isHas) {
            [selectArray addObject:str];
        }
    }
        for (HKFreightListSublist*subList in self.sublist) {
            NSString*proStr;
            if ([[subList.provinceId substringWithRange:NSMakeRange(subList.provinceId.length-1, 1)]isEqualToString:@","]) {
                proStr = [subList.provinceId substringToIndex:subList.provinceId.length-1];
            }else{
                proStr = subList.provinceId;
            }
            if (proStr.length>0) {
                NSArray*proArray = [proStr componentsSeparatedByString:@","];
                for (NSString*str in proArray) {
                    BOOL isHas = NO;
                    for (NSString*idStr in selectedId) {
                        if ([idStr isEqualToString:str]) {
                            isHas = YES;
                            break;
                        }
                    }
                    if (!isHas) {
                        [selectArray addObject:str];
                    }
                }
            }
            
        }
    
    return selectArray.copy;
}
@end


@implementation HKFreightListSublist

@end


