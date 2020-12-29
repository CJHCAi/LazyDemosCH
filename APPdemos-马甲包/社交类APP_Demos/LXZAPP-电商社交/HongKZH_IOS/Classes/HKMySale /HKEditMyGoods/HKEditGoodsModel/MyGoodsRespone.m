//
//Created by ESJsonFormatForMac on 18/08/29.
//

#import "MyGoodsRespone.h"
@implementation MyGoodsRespone

@end

@implementation MyGoodsInfo

+ (NSDictionary *)objectClassInArray{
    return @{@"images" : [ImagesModel class], @"skus" : [SkusModel class]};
}
-(NSMutableArray *)addImage{
    if(_addImage == nil)
    {
        _addImage = [ NSMutableArray array];
    }
    return _addImage;
}
- (NSMutableArray *)deleteImage
{
    if(_deleteImage == nil)
    {
        _deleteImage = [ NSMutableArray array];
    }
    return _deleteImage;
}
- (NSMutableArray *)deleteSku
{
    if(_deleteSku == nil)
    {
        _deleteSku = [ NSMutableArray array];
    }
    return _deleteSku;
}

-(NSDictionary *)getPostParameter{
    NSDictionary *dict ;
    
    if (self.images.count > 0) {
        
        dict = @{@"loginUid":HKUSERLOGINID,@"productId":self.productId.length>0?self.productId:@"",@"title":self.title,@"mediaCategoryId":self.categoryId,@"userFreightId":self.freightId.length>0?self.freightId:@"0",@"content":self.descript.length>0?self.descript:@""};
//        dict = @{@"loginUid":HKUSERLOGINID,@"productId":self.productId,@"title":self.title,@"imgSrc":imageS,@"mediaCategoryId":self.categoryId,@"userFreightId":self.freightId,@"content":self.descript,@"skuId":skuidStr,@"model":modelStr,@"price":priceStr,@"num":numStr};
//        dict = @{@"loginUid":HKUSERLOGINID,@"productId":self.productId,@"title":self.title,@"mediaCategoryId":self.categoryId,@"userFreightId":self.freightId,@"content":self.descript};
    }
    return dict;
}
@end


@implementation ImagesModel

@end


@implementation SkusModel

@end


