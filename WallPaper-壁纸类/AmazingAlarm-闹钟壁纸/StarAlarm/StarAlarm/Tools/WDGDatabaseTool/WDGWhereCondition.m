//
//  WDGWhereCondition.m
//  WDGSqliteTool
//
//  Created by Wdgfnhui on 16/2/26.
//  Copyright © 2016年 Wdgfnhui. All rights reserved.
//

#import "WDGWhereCondition.h"

static NSSet *OperatorSet = nil;

@interface WDGWhereCondition ()

@end

@implementation WDGWhereCondition

+ (BOOL)canCreateWithCondition:(NSString *)condition {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        OperatorSet = [[NSSet alloc] initWithObjects:@"<", @"<=", @">", @">=", @"=", @"<>", @"!=", @"ISNULL", @"NOTNULL", @"LIKE", @"IN", @"NOTIN", nil];
    });
    return [OperatorSet containsObject:[condition uppercaseString]];
}

//+ (instancetype)conditionWithKey:(NSString *)key Condition:(NSString *)condition Value:(id)value {
//    if([WDGWhereCondition canCreateWithCondition:condition])
//    {
//        WDGWhereCondition *wdgCondition = [[WDGWhereCondition alloc] init];
//        wdgCondition.key = [key lowercaseString];
//        wdgCondition.condition = condition;
//        wdgCondition.value = value;
//        return wdgCondition;
//    }
//    NSLog(@"Condition illegal");
//    exit(EXIT_FAILURE);
//    return nil;
//}

- (instancetype)initWithColumnName:(NSString *)columnName Operator:(NSString *)ope Value:(id)value {

    self = [super init];
    if (self) {
        _columnName = [columnName lowercaseString];
        _Operator = ope;
        _value = value;
    }
    return self;
}

+ (instancetype)conditionWithColumnName:(NSString *)columnName Operator:(NSString *)ope Value:(id)value {
    if ([WDGWhereCondition canCreateWithCondition:ope]) {
        WDGWhereCondition *wdgCondition = [[WDGWhereCondition alloc] initWithColumnName:columnName Operator:ope Value:value];
        return wdgCondition;
    }
    NSLog(@"Condition illegal");
    exit(EXIT_FAILURE);
    return nil;

}

//- (void)addWhereConditionWithRelation:(NSString *)relation Key:(NSString *)key Condition:(NSString *)condition Value:(id)value {
//    [self.otherConditions addObject:[WDGWhereCondition conditionWithKey:key Condition:condition Value:value]];
//    [self.relations addObject:[relation uppercaseString]];
//}

- (void)addWhereConditionWithRelation:(NSString *)relation ColumnName:(NSString *)columnName Operator:(NSString *)ope Value:(id)value {
    [self.otherConditions addObject:[WDGWhereCondition conditionWithColumnName:columnName Operator:ope Value:value]];
    [self.relations addObject:[relation uppercaseString]];
}

- (NSMutableArray *)otherConditions {
    if (_otherConditions) {
        return _otherConditions;
    }
    _otherConditions = [NSMutableArray arrayWithCapacity:0];
    return _otherConditions;
}

- (NSMutableArray *)relations {
    if (_relations) {
        return _relations;
    }
    _relations = [NSMutableArray arrayWithCapacity:0];
    return _relations;
}

- (void)removeConditionAtIndex:(NSUInteger)index {
    if (index >= _relations.count) {
        NSLog(@"No such condition");
        return;
    }
    [_otherConditions removeObjectAtIndex:index];
    [_relations removeObjectAtIndex:index];
}

- (void)deleteWhereConditionWithRelation:(NSString *)relation Conditon:(WDGWhereCondition *)condition {
    for (NSUInteger i = 0; i < _otherConditions.count; i++) {
        if ([relation isEqualToString:_relations[i]]) {
            WDGWhereCondition *temp = _otherConditions[i];
            if ([temp.columnName isEqualToString:condition.columnName] && [temp.value isEqualToString:condition.value] && [temp.Operator isEqualToString:condition.Operator]) {
                [self removeConditionAtIndex:i];
                break;
            }
        }
    }
}


+ (instancetype)conditionWithKey:(NSString *)key Condition:(NSString *)condition Value:(id)value {
    return [WDGWhereCondition conditionWithColumnName:key Operator:condition Value:value];
}

- (void)addWhereConditionWithRelation:(NSString *)relation Key:(NSString *)key Condition:(NSString *)condition Value:(id)value {
    return [self addWhereConditionWithRelation:relation ColumnName:key Operator:condition Value:value];
}

- (NSString *)columnName {
    return _columnName;
}

- (NSString *)Operator {
    return _Operator;
}

- (id)value {
    return _value;
}

@end
