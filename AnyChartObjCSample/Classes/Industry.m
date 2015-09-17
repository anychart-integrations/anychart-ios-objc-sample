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
    Industry *res = [[Industry alloc] init];
    res->_industryId = industryId;
    res->_name = name;
    return res;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"[Industry id=%i, name=%@]", self.industryId, self.name];
}

@end
