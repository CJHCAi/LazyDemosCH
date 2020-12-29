//
//  CategoriesManager.m
//  WallPaper
//
//  Created by Never on 2017/2/9.
//  Copyright © 2017年 Never. All rights reserved.
//

#import "CategoriesManager.h"
#import "ImageCategory.h"
#import "PixabayService.h"


@implementation CategoriesManager

+ (instancetype)shareManager{
    
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
    
}

- (id)init{
    if (self = [super init]) {
        
        _categories = @[
                [ImageCategory categoryWithName:@"Latest" thumbnail:[NSURL URLWithString:@"https://pixabay.com/get/52e3d1464c54ac14f6da8c7dda79337f1638dce6544c704c732c7ed7964bc359_640.jpg"]],
                
                [ImageCategory categoryWithName:@"Snow" thumbnail:[NSURL URLWithString:@"https://pixabay.com/get/55e0d4434b50a514f6da8c7dda79337f1638dce6544c704c732c7ed6914ccd5c_640.jpg"]],
                
                [ImageCategory categoryWithName:@"Motorbike" thumbnail:[NSURL URLWithString:@"https://pixabay.com/get/55e7d4404e5aac14f6da8c7dda79337f1638dce6544c704c732c7ed6914bc75f_640.jpg"]],
                
                [ImageCategory categoryWithName:@"Car" thumbnail:[NSURL URLWithString:@"https://pixabay.com/get/57e8d0404351a514f6da8c7dda79337f1638dce6544c704c732c7ed09f4dcd5b_640.jpg"]],
                
                [ImageCategory categoryWithName:@"Beach" thumbnail:[NSURL URLWithString:@"https://pixabay.com/get/5fe8d0464f54b108f5d08460962c367d123ddde24e50744f762a79d2914ecc_640.jpg"]],
                
                [ImageCategory categoryWithName:@"Sunset" thumbnail:[NSURL URLWithString:@"https://pixabay.com/get/50e7d04b4e55b108f5d08460962c367d123ddde24e50744f762a7fdc9648c0_640.jpg"]],
                 
                [ImageCategory categoryWithName:@"Wine" thumbnail:[NSURL URLWithString:@"https://pixabay.com/get/57e0d5474857a414f6da8c7dda79337f1638dce6544c704c732c7ed09f4ccc5c_640.jpg"]],
                 
                [ImageCategory categoryWithName:@"Girl" thumbnail:[NSURL URLWithString:@"https://pixabay.com/get/54e9d1434c57a914f6da8c7dda79337f1638dce6544c704c732c7ed09f4fc459_640.jpg"]],
                
                [ImageCategory categoryWithName:@"Train" thumbnail:[NSURL URLWithString:@"https://pixabay.com/get/55e4d24b4e51ab14f6da8c7dda79337f1638dce6544c704c732c7ed09f4fc750_640.jpg"]],
                
                [ImageCategory categoryWithName:@"City" thumbnail:[NSURL URLWithString:@"https://pixabay.com/get/57e4dd44425bad14f6da8c7dda79337f1638dce6544c704c732c7ed09f4fc15f_640.jpg"]],
                
                [ImageCategory categoryWithName:@"Animal" thumbnail:[NSURL URLWithString:@"https://pixabay.com/get/54e8d2434d55ab14f6da8c7dda79337f1638dce6544c704c732c7ed09f4fc25a_640.jpg"]],
                
                [ImageCategory categoryWithName:@"Architecture" thumbnail:[NSURL URLWithString:@"https://pixabay.com/get/54e4d347425ba514f6da8c7dda79337f1638dce6544c704c732c7ed09f4ec55a_640.jpg"]],
                
                [ImageCategory categoryWithName:@"Food" thumbnail:[NSURL URLWithString:@"https://pixabay.com/get/50e9d5414952b108f5d08460962c367d123ddde24e50744f762a7fdc944fcd_640.jpg"]],
                
                [ImageCategory categoryWithName:@"Nature" thumbnail:[NSURL URLWithString:@"https://pixabay.com/get/57e2dd474f53ae14f6da8c7dda79337f1638dce6544c704c732c7ed09f4ec15d_640.jpg"]],
                
                [ImageCategory categoryWithName:@"Landscape" thumbnail:[NSURL URLWithString:@"https://pixabay.com/get/57e5dd424255a514f6da8c7dda79337f1638dce6544c704c732c7ed09f4ecd5d_640.jpg"]],
                
                [ImageCategory categoryWithName:@"Sky" thumbnail:[NSURL URLWithString:@"https://pixabay.com/get/57e3d2404b55ad14f6da8c7dda79337f1638dce6544c704c732c7ed09f49c55f_640.jpg"]],
        
                [ImageCategory categoryWithName:@"Plant" thumbnail:[NSURL URLWithString:@"https://pixabay.com/get/57e5dc464f5aad14f6da8c7dda79337f1638dce6544c704c732c7ed09f49c659_640.jpg"]],
                
                [ImageCategory categoryWithName:@"Ocean" thumbnail:[NSURL URLWithString:@"https://pixabay.com/get/54e2d54b4351ad14f6da8c7dda79337f1638dce6544c704c732c7ed09f49c059_640.jpg"]],
                
                
                ];
                 
    }
    return self;
}
@end
