//
//  SalesRep.m
//  AnyChartObjCSample
//
//  Created by Alexandr Batcuyev on 9/17/15.
//  Copyright (c) 2015 AnyChart. All rights reserved.
//

#import "SalesRep.h"

@implementation SalesRep

+ (SalesRep*)salesRepWithId:(int)salesId name:(NSString*)name {
    SalesRep *res = [[SalesRep alloc] init];
    res->_salesRepId = salesId;
    res->_name = name;
    return res;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"[SalesRep id=%i, name=%@]", self.salesRepId, self.name];
}

@end
