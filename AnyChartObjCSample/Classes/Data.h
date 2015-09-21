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
- (Product*)productById:(NSNumber*)productId;
- (NSArray*)industries;
- (Industry*)industryById:(NSNumber*)industryId;
- (NSArray*)regions;
- (Region*)regionById:(NSNumber*)regionId;
- (NSArray*)salesReps;
- (SalesRep*)salesRepById:(NSNumber*)salesRepId;

- (NSArray*)revenueByIndustryInYear:(NSNumber*)year
                          inQuarter:(NSNumber*)quarter
                         forProduct:(NSNumber*)product
                           inRegion:(NSNumber*)region
                        forIndustry:(NSNumber*)industry
                           salesRep:(NSNumber*)salesRep;

- (NSArray*)revenueBySalesRepInYear:(NSNumber*)year
                          inQuarter:(NSNumber*)quarter
                         forProduct:(NSNumber*)product
                           inRegion:(NSNumber*)region
                        forIndustry:(NSNumber*)industry
                           salesRep:(NSNumber*)salesRep;

- (NSArray*)revenueByProductInYear:(NSNumber*)year
                         inQuarter:(NSNumber*)quarter
                        forProduct:(NSNumber*)product
                          inRegion:(NSNumber*)region
                       forIndustry:(NSNumber*)industry
                          salesRep:(NSNumber*)salesRep;

- (NSArray*)revenueByQuarterInYear:(NSNumber*)year
                         inQuarter:(NSNumber*)quarter
                        forProduct:(NSNumber*)product
                          inRegion:(NSNumber*)region
                       forIndustry:(NSNumber*)industry
                          salesRep:(NSNumber*)salesRep;

@end
