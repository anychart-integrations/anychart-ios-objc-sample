//
//  ByProductViewController.m
//  AnyChartObjCSample
//
//  Created by Alexandr Batcuyev on 9/28/15.
//  Copyright © 2015 AnyChart. All rights reserved.
//

#import "ByProductViewController.h"
#import "Data.h"
#import "Filters.h"

@implementation ByProductViewController

- (NSString*)htmlFileName {
    return @"pie";
}

- (id)chartData {
    return [[Data shared] revenueByProductInYear:[Filters year]
                                       inQuarter:[Filters quarter]
                                      forProduct:[Filters productId]
                                        inRegion:[Filters regionId]
                                     forIndustry:[Filters industryId]
                                        salesRep:[Filters salesRepId]];
}

@end