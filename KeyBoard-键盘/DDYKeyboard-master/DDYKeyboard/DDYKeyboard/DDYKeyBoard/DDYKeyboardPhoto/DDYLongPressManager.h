#import <Foundation/Foundation.h>

@interface DDYLongPressManager : NSObject

@property (nonatomic, assign) BOOL isDragEditting;

@property (nonatomic, assign) BOOL isNeedRefresh;

+ (instancetype)sharedManager;

@end
