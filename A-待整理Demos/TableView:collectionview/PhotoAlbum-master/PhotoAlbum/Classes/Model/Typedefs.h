//
//  Typedefs.h
//  PhotoAlbum
//
//  Created by ZhouQian on 16/6/24.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#ifndef Typedefs_h
#define Typedefs_h


typedef NS_ENUM(NSInteger, ZQAlbumType) {
    ZQAlbumTypePhoto,
    ZQAlbumTypeVideo,
    ZQAlbumTypeVideoAndPhoto
};

#define _currentBundle \
[NSBundle bundleWithPath:[[[NSBundle bundleForClass:[ZQAlbumNavVC class]] resourcePath] stringByAppendingPathComponent:@"PA.bundle"]]

#define _LocalizedString(x) \
NSLocalizedStringFromTableInBundle(x, @"ZQPhotoFetcher", _currentBundle, nil)

#define _image(x) \
[UIImage imageNamed:[NSString stringWithFormat:@"images/%@", x] inBundle:_currentBundle compatibleWithTraitCollection:nil]

#define ZQAlbumBarTintColor HEXCOLOR(0x7ecc1e)
#endif /* Typedefs_h */
