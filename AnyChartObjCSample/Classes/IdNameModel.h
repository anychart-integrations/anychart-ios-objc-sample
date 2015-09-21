//
//  IdNameModel.h
//  AnyChartObjCSample
//
//  Created by Alexandr Batcuyev on 9/21/15.
//  Copyright (c) 2015 AnyChart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IdNameModel : NSObject

@property (readonly) int identifier;
@property (readonly) NSString* name;

- (id)initWithId:(int)identifier name:(NSString*)name;

@end
