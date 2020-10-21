//
//  GCPagination.h
//  GetChute
//
//  Created by Aleksandar Trpeski on 12/24/12.
//  Copyright (c) 2012 Aleksandar Trpeski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCPagination : NSObject

@property (assign, nonatomic) NSNumber  *totalPages;
@property (assign, nonatomic) NSNumber  *currentPage;
@property (strong, nonatomic) NSString  *nextPage;
@property (strong, nonatomic) NSString  *previousPage;
@property (strong, nonatomic) NSString  *firstPage;
@property (strong, nonatomic) NSString  *lastPage;
@property (assign, nonatomic) NSNumber  *perPage;

@end