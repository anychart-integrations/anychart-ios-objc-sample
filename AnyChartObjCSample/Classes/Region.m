//
//  Region.m
//  AnyChartObjCSample
//
//  Created by Alexandr Batcuyev on 9/17/15.
//  Copyright (c) 2015 AnyChart. All rights reserved.
//

#import "Region.h"

@implementation Region

+ (Region*)regionWithId:(int)regionId name:(NSString*)name {
    Region *res = [[Region alloc] init];
    res->_regionId = regionId;
    res->_name = name;
    return res;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"[Region id=%i, name=%@]", self.regionId, self.name];
}

@end
