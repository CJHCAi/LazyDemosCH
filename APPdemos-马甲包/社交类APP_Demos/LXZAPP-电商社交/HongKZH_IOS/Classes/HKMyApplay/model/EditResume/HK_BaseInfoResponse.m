//
//Created by ESJsonFormatForMac on 18/09/17.
//

#import "HK_BaseInfoResponse.h"
@implementation HK_BaseInfoResponse

@end

@implementation HK_UserRecruitData

- (NSString *)completeProgress {
    NSInteger index = 0;
    if (self.nickname && ![self.nickname isEqualToString:@""]) {
        index++;
    }
    if (self.sex && ![self.sex isEqualToString:@""]) {
        index++;
    }
    if (self.age != 0) {
        index++;
    }
    if (self.height && ![self.height isEqualToString:@""]) {
        index++;
    }
    if (self.education && ![self.education isEqualToString:@""]) {
        index++;
    }
    if (self.salary && ![self.salary isEqualToString:@""]) {
        index++;
    }
    if (self.located && ![self.located isEqualToString:@""]) {
        index++;
    }
    if (self.marital && ![self.marital isEqualToString:@""]) {
        index++;
    }
    if (self.birthday && ![self.birthday isEqualToString:@""]) {
        index++;
    }
    if (self.constellation && ![self.constellation isEqualToString:@""]) {
        index++;
    }
    if (self.weight && ![self.weight isEqualToString:@""]) {
        index++;
    }
    if (self.hobby && ![self.hobby isEqualToString:@""]) {
        index++;
    }
    
    return [NSString stringWithFormat:@"已完成：%ld/12",index];
}

@end


