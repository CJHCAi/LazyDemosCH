//
//  AppDelegate.h
//  BubbleButton
//
//  Created by lisonglin on 15/05/2017.
//  Copyright © 2017 lisonglin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

