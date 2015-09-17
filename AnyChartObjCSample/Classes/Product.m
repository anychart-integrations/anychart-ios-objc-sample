//
//  Product.m
//  AnyChartObjCSample
//
//  Created by Alexandr Batcuyev on 9/17/15.
//  Copyright (c) 2015 AnyChart. All rights reserved.
//

#import "Product.h"

@implementation Product

+ (Product*)productWithId:(int)productId industry:(int)industryId name:(NSString*)name {
    Product *res = [[Product alloc] init];
    res->_productId = productId;
    res->_industryId = industryId;
    res->_name = name;
    return res;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"[Product id=%i, industry_id=%i, name=%@]", self.productId, self.industryId, self.name];
}

@end
