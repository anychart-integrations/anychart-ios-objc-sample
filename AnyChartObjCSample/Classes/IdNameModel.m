//
//  IdNameModel.m
//  AnyChartObjCSample
//
//  Created by Alexandr Batcuyev on 9/21/15.
//  Copyright (c) 2015 AnyChart. All rights reserved.
//

#import "IdNameModel.h"

@implementation IdNameModel

- (id)initWithId:(int)identifier name:(NSString *)name {
    self = [super init];
    if (self) {
        _identifier = identifier;
        _name = [NSString stringWithString:name];
    }
    return self;
}

@end
