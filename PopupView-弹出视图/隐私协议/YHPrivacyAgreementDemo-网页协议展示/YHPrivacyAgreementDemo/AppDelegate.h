//
//  AppDelegate.h
//  YHPrivacyAgreementDemo
//
//  Created by survivors on 2019/1/30.
//  Copyright © 2019年 survivorsfyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

