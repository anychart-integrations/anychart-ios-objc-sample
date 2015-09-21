//
//  Industry.m
//  AnyChartObjCSample
//
//  Created by Alexandr Batcuyev on 9/17/15.
//  Copyright (c) 2015 AnyChart. All rights reserved.
//

#import "Industry.h"

@implementation Industry

+ (Industry*)industryWithId:(int)industryId name:(NSString*)name {
    return [[Industry alloc] initWithId:industryId name:name];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"[Industry id=%i, name=%@]", self.identifier, self.name];
}

@end
