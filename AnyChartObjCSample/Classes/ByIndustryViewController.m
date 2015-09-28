//
//  ByIndustryViewController.m
//  AnyChartObjCSample
//
//  Created by Alexandr Batcuyev on 9/28/15.
//  Copyright © 2015 AnyChart. All rights reserved.
//

#import "ByIndustryViewController.h"
#import "Data.h"
#import "Filters.h"

@implementation ByIndustryViewController

- (NSString*)htmlFileName {
    return @"bar";
}

- (id)chartData {
    return [[Data shared] revenueByIndustryInYear:[Filters year]
                                        inQuarter:[Filters quarter]
                                       forProduct:[Filters productId]
                                         inRegion:[Filters regionId]
                                      forIndustry:[Filters industryId]
                                         salesRep:[Filters salesRepId]];
}

@end
