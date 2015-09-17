//
//  Data.h
//  AnyChartObjCSample
//
//  Created by Alexandr Batcuyev on 9/17/15.
//  Copyright (c) 2015 AnyChart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"
#import "Industry.h"
#import "Region.h"
#import "SalesRep.h"

@interface Data : NSObject

+ (Data*)shared;

- (NSArray*)years;
- (NSArray*)products;
- (NSArray*)industries;
- (NSArray*)regions;
- (NSArray*)salesReps;

- (NSArray*)revenueByIndustryInYear:(NSNumber*)year
                          inQuarter:(NSNumber*)quarter
                         forProduct:(Product*)product
                           inRegion:(Region*)region
                        forIndustry:(Industry*)industry
                           salesRep:(SalesRep*)salesRep;

- (NSArray*)revenueBySalesRepInYear:(NSNumber*)year
                          inQuarter:(NSNumber*)quarter
                         forProduct:(Product*)product
                           inRegion:(Region*)region
                        forIndustry:(Industry*)industry
                           salesRep:(SalesRep*)salesRep;

- (NSArray*)revenueByProductInYear:(NSNumber*)year
                         inQuarter:(NSNumber*)quarter
                        forProduct:(Product*)product
                          inRegion:(Region*)region
                       forIndustry:(Industry*)industry
                          salesRep:(SalesRep*)salesRep;

- (NSArray*)revenueByQuarterInYear:(NSNumber*)year
                         inQuarter:(NSNumber*)quarter
                        forProduct:(Product*)product
                          inRegion:(Region*)region
                       forIndustry:(Industry*)industry
                          salesRep:(SalesRep*)salesRep;

@end
