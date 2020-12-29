//
//  WHFlowLayout.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/11/7.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "WHFlowLayout.h"
#import "UIView+Frame.h"
@implementation WHFlowLayout
- (NSArray *) layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    
    
    
    if (attributes.count <= 1) return attributes;
    
    
    UICollectionViewLayoutAttributes*frist =(UICollectionViewLayoutAttributes *)attributes.firstObject;
    CGFloat firstCellOriginX = frist.frame.origin.x;
    CGRect frame = frist.frame;
    
    frame.origin.y = self.maxY;
    
    frist.frame = frame;
    for(int i = 1; i < attributes.count; i++) {
        
        UICollectionViewLayoutAttributes *currentLayoutAttributes = attributes[i];
        
        if (currentLayoutAttributes.frame.origin.x != firstCellOriginX) { // The first cell of a new row
            
            
            
            UICollectionViewLayoutAttributes *prevLayoutAttributes = attributes[i - 1];
            
            CGFloat prevOriginMaxX = CGRectGetMaxX(prevLayoutAttributes.frame);
            
            if ((currentLayoutAttributes.frame.origin.x - prevOriginMaxX) > self.maxCellSpacing) {
                
                CGRect frame = currentLayoutAttributes.frame;
                
                frame.origin.x = prevOriginMaxX + self.maxCellSpacing;
                
                currentLayoutAttributes.frame = frame;
                
            }
            
        }
        
      
        if (i == 0) {
            continue;
        }
        UICollectionViewLayoutAttributes *prevLayoutAttributesY;
        if (i == 1) {
            prevLayoutAttributesY = attributes[i - 1];
            CGRect frame = currentLayoutAttributes.frame;
            if (self.isRetrun) {
                
                frame.origin.y = self.maxY;
                currentLayoutAttributes.frame = frame;
                 continue;
            }
        }else{
            prevLayoutAttributesY = attributes[i - 2];
        }
            CGFloat prevOriginMaxY = CGRectGetMaxY(prevLayoutAttributesY.frame);
            if ((currentLayoutAttributes.frame.origin.y - prevOriginMaxY) > self.maxCellSpacingH) {
                
                CGRect frame = currentLayoutAttributes.frame;
                
                frame.origin.y = prevOriginMaxY+self.maxCellSpacingH;
                
                currentLayoutAttributes.frame = frame;
                
            }
            continue;
       
        
    }
     UICollectionViewLayoutAttributes*last =(UICollectionViewLayoutAttributes *)attributes.lastObject;
    if (attributes.count%2>0) {
        self.isRetrun = NO;
        self.maxY = last.frame.origin.y;
      
    }else{
        self.isRetrun = YES;
         self.maxY = CGRectGetMaxY(last.frame)+self.maxCellSpacingH;
    }
   
    return attributes;
    
}

@end
