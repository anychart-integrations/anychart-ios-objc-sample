//
//  Industry.h
//  AnyChartObjCSample
//
//  Created by Alexandr Batcuyev on 9/17/15.
//  Copyright (c) 2015 AnyChart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Industry : NSObject

@property (readonly) int industryId;
@property (readonly) NSString* name;

+ (Industry*)industryWithId:(int)industryId name:(NSString*)name;

@end
