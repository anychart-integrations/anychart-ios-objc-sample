//
//  Region.h
//  AnyChartObjCSample
//
//  Created by Alexandr Batcuyev on 9/17/15.
//  Copyright (c) 2015 AnyChart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Region : NSObject

@property (readonly) int regionId;
@property (readonly) NSString* name;

+ (Region*)regionWithId:(int)regionId name:(NSString*)name;

@end
