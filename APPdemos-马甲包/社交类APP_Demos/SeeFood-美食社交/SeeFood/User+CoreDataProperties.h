//
//  User+CoreDataProperties.h
//  SeeFood
//
//  Created by 纪洪波 on 15/11/25.
//  Copyright © 2015年 纪洪波. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSString *password;
@property (nullable, nonatomic, retain) NSString *phone;
@property (nullable, nonatomic, retain) NSString *photoURL;
@property (nullable, nonatomic, retain) NSString *username;

@end

NS_ASSUME_NONNULL_END
