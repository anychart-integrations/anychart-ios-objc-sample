//
//  Filters.h
//  AnyChartObjCSample
//
//  Created by Alexandr Batcuyev on 9/21/15.
//  Copyright (c) 2015 AnyChart. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, FilterKey) {
    FilterKeyYear,
    FilterKeyQuarter,
    FilterKeyProductId,
    FilterKeyRegionId,
    FilterKeySalesRepId,
    FilterKeyIndustryId
};

@interface Filters : NSObject

+ (NSNumber*)year;
+ (NSNumber*)quarter;
+ (NSNumber*)productId;
+ (NSNumber*)regionId;
+ (NSNumber*)salesRepId;
+ (NSNumber*)industryId;

+ (void)setFilterValue:(NSNumber*)value forKey:(FilterKey)key;
+ (NSNumber*)filterValueForKey:(FilterKey)key;

@end
