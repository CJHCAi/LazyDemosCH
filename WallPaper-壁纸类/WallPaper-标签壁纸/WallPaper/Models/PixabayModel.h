//
//  PixabayModel.h
//  WallPaper
//
//  Created by Never on 2019/7/18.
//  Copyright © 2019 Never. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PixabayModel : NSObject

@property(nonatomic,strong) NSString *comments; //37;
@property(nonatomic,strong) NSString *downloads; //1419;
@property(nonatomic,strong) NSString *favorites; //10;
@property(nonatomic,strong) NSString *Id; //4339701;
@property(nonatomic,strong) NSString *imageHeight; //4000;
@property(nonatomic,strong) NSString *imageSize; //2799021;
@property(nonatomic,strong) NSString *imageWidth; //6000;
@property(nonatomic,strong) NSURL *largeImageURL; //"https://pixabay.com/get/52e3d64a4d52ad14f6da8c7dda79337f1638dce6544c704c732c7fd7934bc45a_1280.jpg";
@property(nonatomic,strong) NSString *likes; //45;
@property(nonatomic,strong) NSString *pageURL; //"https://pixabay.com/photos/sunflower-flowers-plant-helianthus-4339701/";
@property(nonatomic,strong) NSString *previewHeight; //99;
@property(nonatomic,strong) NSURL *previewURL; //"https://cdn.pixabay.com/photo/2019/07/15/15/54/sunflower-4339701_150.jpg";
@property(nonatomic,strong) NSString *previewWidth; //150;
@property(nonatomic,strong) NSString *tags; //"sunflower, flowers, plant";
@property(nonatomic,strong) NSString *type; //photo;
@property(nonatomic,strong) NSString *user; //Peggychoucair;
@property(nonatomic,strong) NSURL *userImageURL; //"https://cdn.pixabay.com/user/2018/12/28/22-17-08-435_250x250.jpg";
@property(nonatomic,strong) NSString *user_id; //1130890;
@property(nonatomic,strong) NSString *views; //1618;
@property(nonatomic,strong) NSString *webformatHeight; //426;
@property(nonatomic,strong) NSURL *webformatURL; //"https://pixabay.com/get/52e3d64a4d52ad14f6da8c7dda79337f1638dce6544c704c732c7fd7934bc45a_640.jpg";
@property(nonatomic,strong) NSString *webformatWidth; //640;


@end

NS_ASSUME_NONNULL_END
