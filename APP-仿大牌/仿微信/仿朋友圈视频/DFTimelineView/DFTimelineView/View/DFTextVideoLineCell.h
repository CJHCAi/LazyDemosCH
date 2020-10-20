//
//  DFTextVideoLineCell.h
//  DFTimelineView
//
//  Created by CaptainTong on 15/11/13.
//  Copyright © 2015年 Datafans, Inc. All rights reserved.
//

#import "DFBaseLineCell.h"
#import "DFBaseLineItem.h"
#import "MHGallery.h"
#import "MHMediaPreviewCollectionViewCell.h"

@interface DFTextVideoLineCell : DFBaseLineCell<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,MHGalleryDataSource,MHGalleryDelegate>

+(CGFloat) getCellHeight:(DFBaseLineItem *) item;

@end
