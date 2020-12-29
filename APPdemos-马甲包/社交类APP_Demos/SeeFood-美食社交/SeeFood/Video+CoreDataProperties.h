//
//  Video+CoreDataProperties.h
//  
//
//  Created by 纪洪波 on 15/11/27.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Video.h"

NS_ASSUME_NONNULL_BEGIN

@interface Video (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *collectionCount;
@property (nullable, nonatomic, retain) NSString *coverBlurred;
@property (nullable, nonatomic, retain) NSString *coverForDetail;
@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSNumber *duration;
@property (nullable, nonatomic, retain) NSNumber *id;
@property (nullable, nonatomic, retain) NSString *playUrl;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *username;

@end

NS_ASSUME_NONNULL_END
