//
//  Industry.h
//  AnyChartObjCSample
//
//  Created by Alexandr Batcuyev on 9/17/15.
//  Copyright (c) 2015 AnyChart. All rights reserved.
//

#import "IdNameModel.h"

@interface Industry : IdNameModel

+ (Industry*)industryWithId:(int)industryId name:(NSString*)name;

@end
