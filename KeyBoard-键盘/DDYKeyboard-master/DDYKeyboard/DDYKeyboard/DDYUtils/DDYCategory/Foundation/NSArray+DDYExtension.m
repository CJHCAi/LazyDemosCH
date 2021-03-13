#import "NSArray+DDYExtension.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <UIKit/UIKit.h>
#import "NSString+DDYExtension.h"

@implementation NSArray (DDYExtension)

#pragma mark - TableView索引数组
#pragma mark 索引数组排序
- (NSMutableArray *)ddy_SortWithCollectionStringSelector:(SEL)selector {
    // 索引规则对象
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    // 索引数量（26个字母和1个#）
    NSInteger sectionTitlesCount = [[collation sectionTitles] count];
    // 初始化存储分组数组
    NSMutableArray *sections = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
    // 得到@[ @[A], @[B], @[C] ... @[Z], @[#] ] 空数组
    for (int i = 0; i < sectionTitlesCount; i++) {
        [sections addObject:[NSMutableArray array]];
    }
    // 按selector参数分配到数组
    for (id obj in self) {
        NSInteger sectionNumber = [DDYCollation sectionForObject:obj collationStringSelector:selector];
        [[sections objectAtIndex:sectionNumber] addObject:obj];
    }
    // 对每个数组按排序 同时去除空数组
    for (int i = 0; i < sectionTitlesCount; i++) {
        [sections replaceObjectAtIndex:i withObject:[DDYCollation sortedArrayFromArray:sections[i] collationStringSelector:selector]];
    }
    // 去除空分组
    for (int i = 0; i < sections.count; i++) {
        if (!sections[i] || ![sections[i] count]) {
            [sections removeObject:sections[i]];
        }
    }
    return sections;
}

#pragma mark 索引数组标题
- (NSMutableArray *)ddy_SortWithModel:(NSString *)model selector:(SEL)selector showSearch:(BOOL)show {
    
    NSMutableArray *section = [NSMutableArray array];
    if (show) [section addObject:UITableViewIndexSearch];
    Class class = NSClassFromString(model);
    unsigned int count = 0;
    objc_property_t *propertys = class_copyPropertyList(class, &count);
    
    for(int i = 0; i < count; i ++) {
        
        objc_property_t property = propertys[i];
        
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        
        if ([propertyName isEqualToString:NSStringFromSelector(selector)]) {
            
            Ivar ivar = class_getInstanceVariable(class, [[NSString stringWithFormat:@"_%@",propertyName] UTF8String]);
            
            for (NSArray *itemArray in self) {
                NSString *str = (NSString *)object_getIvar(itemArray[0], ivar);
                char c = [NSString ddy_blankString:str] ? '#' : [str characterAtIndex:0];
                if (!isalpha(c)) c = '#';
                [section addObject:[NSString stringWithFormat:@"%c", toupper(c)]];
            }
        }
    }
    return section;
}

@end
