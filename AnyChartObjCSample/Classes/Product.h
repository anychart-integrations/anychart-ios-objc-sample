//
//  Product.h
//  AnyChartObjCSample
//
//  Created by Alexandr Batcuyev on 9/17/15.
//  Copyright (c) 2015 AnyChart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject

@property (readonly) int productId;
@property (readonly) int industryId;
@property (readonly) NSString* name;

+ (Product*)productWithId:(int)productId industry:(int)industryId name:(NSString*)name;

@end
