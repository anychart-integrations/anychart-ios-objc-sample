//
//  SalesRep.h
//  AnyChartObjCSample
//
//  Created by Alexandr Batcuyev on 9/17/15.
//  Copyright (c) 2015 AnyChart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SalesRep : NSObject

@property (readonly) int salesRepId;
@property (readonly) NSString* name;

+ (SalesRep*)salesRepWithId:(int)salesId name:(NSString*)name;

@end
