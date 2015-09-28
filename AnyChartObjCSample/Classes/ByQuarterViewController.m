//
//  ByQuarterViewController.m
//  AnyChartObjCSample
//
//  Created by Alexandr Batcuyev on 9/28/15.
//  Copyright © 2015 AnyChart. All rights reserved.
//

#import "ByQuarterViewController.h"
#import "Data.h"
#import "Filters.h"

@implementation ByQuarterViewController

- (NSString*)htmlFileName {
    return @"line";
}

- (id)chartData {
    return [[Data shared] revenueByQuarterInYear:[Filters year]
                                       inQuarter:[Filters quarter]
                                      forProduct:[Filters productId]
                                        inRegion:[Filters regionId]
                                     forIndustry:[Filters industryId]
                                        salesRep:[Filters salesRepId]];
}


@end
