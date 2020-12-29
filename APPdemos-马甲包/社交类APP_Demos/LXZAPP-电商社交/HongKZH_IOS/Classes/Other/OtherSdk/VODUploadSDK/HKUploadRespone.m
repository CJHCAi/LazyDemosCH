//
//Created by ESJsonFormatForMac on 18/10/12.
//

#import "HKUploadRespone.h"
#import "HKDateTool.h"
@implementation HKUploadRespone
MJExtensionCodingImplementation
-(void)setData:(UploadsData *)data{
    _data = data;
    self.time = [HKDateTool getCurrentTime13];
}
-(BOOL)isLoad{
    BOOL isLoad = NO;
    if ([HKDateTool getCurrentTime13] - self.time >=300) {
        isLoad = YES;
    }
    return isLoad;
}
@end
@implementation UploadsData
MJExtensionCodingImplementation
@end


