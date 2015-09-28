//
//  ByProductViewController.m
//  AnyChartObjCSample
//
//  Created by Alexandr Batcuyev on 9/28/15.
//  Copyright © 2015 AnyChart. All rights reserved.
//

#import "BySalesRepViewController.h"
#import "Data.h"
#import "Filters.h"

@implementation BySalesRepViewController

- (NSString*)htmlFileName {
    return @"column";
}

- (id)chartData {
    return [[Data shared] revenueBySalesRepInYear:[Filters year]
                                        inQuarter:[Filters quarter]
                                       forProduct:[Filters productId]
                                         inRegion:[Filters regionId]
                                      forIndustry:[Filters industryId]
                                         salesRep:[Filters salesRepId]];
}

@end