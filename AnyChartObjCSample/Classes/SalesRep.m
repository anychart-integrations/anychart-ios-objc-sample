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
    return [[SalesRep alloc] initWithId:salesId name:name];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"[SalesRep id=%i, name=%@]", self.identifier, self.name];
}

@end
