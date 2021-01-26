//
//  CJMonthDayCollectionCell.h
//  CJCalendar
//
//  Created by chjsun on 16/5/26.
//  Copyright © 2016年 chjsun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CJMonthDayCollectionCell : UICollectionViewCell

/** 月 */
@property (nonatomic, copy) NSString *gregoiainDay;
/** 日 */
@property (nonatomic, copy) NSString *lunarDay;

/** 阳历 */
@property (nonatomic, copy) NSString *gregoiainCalendar;
/** 农历 */
@property (nonatomic, copy) NSString *chineseCalendar;

@end
