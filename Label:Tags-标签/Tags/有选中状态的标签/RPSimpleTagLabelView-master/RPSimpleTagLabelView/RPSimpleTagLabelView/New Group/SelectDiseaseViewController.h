//
//  SelectDiseaseViewController.h
//  RPSimpleTagLabelView
//
//  Created by 李贤惠 on 2020/3/13.
//  Copyright © 2020 Tao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^DiseaseBlock)(NSMutableArray *nameArray,NSMutableArray *resultArray);

@interface SelectDiseaseViewController : UIViewController
@property (copy, nonatomic) DiseaseBlock diseaseInfo;
@property (strong , nonatomic) NSMutableArray *nameArray;
@property (strong , nonatomic) NSMutableArray *resultArray;
- (void)returnDiseaseInfo:(DiseaseBlock)block;

@end

NS_ASSUME_NONNULL_END
