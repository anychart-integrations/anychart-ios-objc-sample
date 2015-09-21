//
//  Filters.m
//  AnyChartObjCSample
//
//  Created by Alexandr Batcuyev on 9/21/15.
//  Copyright (c) 2015 AnyChart. All rights reserved.
//

#import "Filters.h"

@implementation Filters

+ (void)setFilterValue:(NSNumber*)value forKey:(FilterKey)key {
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:@(key).stringValue];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSNumber*)filterValueForKey:(FilterKey)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@(key).stringValue];
}

+ (NSNumber*)year {
    return [self filterValueForKey:FilterKeyYear];
}

+ (NSNumber*)quarter {
    return [self filterValueForKey:FilterKeyQuarter];
}

+ (NSNumber*)productId {
    return [self filterValueForKey:FilterKeyProductId];
}

+ (NSNumber*)regionId {
    return [self filterValueForKey:FilterKeyRegionId];
}

+ (NSNumber*)salesRepId {
    return [self filterValueForKey:FilterKeySalesRepId];
}

+ (NSNumber*)industryId {
    return [self filterValueForKey:FilterKeyIndustryId];
}

@end
