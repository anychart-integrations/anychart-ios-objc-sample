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
    return [[Region alloc] initWithId:regionId name:name];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"[Region id=%i, name=%@]", self.identifier, self.name];
}

@end
