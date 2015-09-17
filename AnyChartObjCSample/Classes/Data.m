//
//  Data.m
//  AnyChartObjCSample
//
//  Created by Alexandr Batcuyev on 9/17/15.
//  Copyright (c) 2015 AnyChart. All rights reserved.
//

#import "Data.h"
#import <FMDB/FMDB.h>

@interface Data()

@property FMDatabase *db;

@end

@implementation Data

+ (BOOL)addSkipBackupAttributeToItemAtPath:(NSString *) filePathString
{
    NSURL* URL= [NSURL fileURLWithPath: filePathString];
    BOOL success;
    if ([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]) {
        
        NSError *error = nil;
        success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                 forKey: NSURLIsExcludedFromBackupKey error: &error];
        if(!success){
            NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
        }
    }
    return success;
}

- (NSString*)databasePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent:@"data.sqlite3"];
    return databasePath;
}

+ (Data*)shared {
    static Data *sharedData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedData = [[self alloc] init];
    });
    return sharedData;
}

- (id)init {
    self = [super init];
    if (self) {
        [Data addSkipBackupAttributeToItemAtPath:self.databasePath];
        self.db = [FMDatabase databaseWithPath:self.databasePath];
        if (![self.db open]) {
            NSLog(@"Failed to open databse");
        }else {
            [self setup];
        }
    }
    return self;
}

+ (NSDate*)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:year];
    [components setMonth:month];
    [components setDay:day];
    return [calendar dateFromComponents:components];
}

- (void)setup {
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"db_version"] isEqualToString:@"1.1"])
        return;
    
    [self.db executeStatements:@"DROP TABLE IF EXISTS industry;"
                                "DROP TABLE IF EXISTS product;"
                                "DROP TABLE IF EXISTS region;"
                                "DROP TABLE IF EXISTS sales_reps;"
                                "DROP TABLE IF EXISTS sales;"];
    
    [self.db executeStatements:@"CREATE TABLE industry (id INTEGER PRIMARY KEY, name TEXT);"
                                "CREATE TABLE product (id INTEGER PRIMARY KEY, industry_id INTEGER, name TEXT);"
                                "CREATE TABLE region (id INTEGER PRIMARY KEY, name TEXT);"
                                "CREATE TABLE sales_reps (id INTEGER PRIMARY KEY, name TEXT);"
                                "CREATE TABLE sales (date TEXT, quarter INTEGER, product_id INTEGER, region_id INTEGER, rep_id INTEGER, total REAL)"];
    
    [self.db executeStatements:@"INSERT INTO industry (id, name) VALUES (0, 'Materials');"
                                "INSERT INTO industry (id, name) VALUES (1, 'Consumer Goods');"
                                "INSERT INTO industry (id, name) VALUES (2, 'Finance');"
                                "INSERT INTO industry (id, name) VALUES (3, 'Healthcare');"];
    
    [self.db executeStatements:@"INSERT INTO product (id, industry_id, name) VALUES (0, 0, 'Product 1');"
                                "INSERT INTO product (id, industry_id, name) VALUES (1, 1, 'Product 2');"
                                "INSERT INTO product (id, industry_id, name) VALUES (2, 2, 'Product 3');"
                                "INSERT INTO product (id, industry_id, name) VALUES (3, 2, 'Product 4');"
                                "INSERT INTO product (id, industry_id, name) VALUES (4, 3, 'Product 5');"];
    
    [self.db executeStatements:@"INSERT INTO region (id, name) VALUES (0, 'North America');"
                                "INSERT INTO region (id, name) VALUES (1, 'Latin America');"
                                "INSERT INTO region (id, name) VALUES (2, 'Europe');"
                                "INSERT INTO region (id, name) VALUES (3, 'Middle East');"
                                "INSERT INTO region (id, name) VALUES (4, 'Asia Pacific');"];
    
    [self.db executeStatements:@"INSERT INTO sales_reps (id, name) VALUES (0, 'Paul Smith');"
                                "INSERT INTO sales_reps (id, name) VALUES (1, 'Joe Hernandez');"
                                "INSERT INTO sales_reps (id, name) VALUES (2, 'Heidi Weild');"
                                "INSERT INTO sales_reps (id, name) VALUES (3, 'Roberto Pallino');"
                                "INSERT INTO sales_reps (id, name) VALUES (4, 'Amir Kutra');"];
    
    [self.db beginTransaction];
    
    NSDate *startDate = [Data dateWithYear:2005 month:1 day:1];
    NSDate *endDate = [Data dateWithYear:2015 month:1 day:1];
    NSTimeInterval dateRange = [endDate timeIntervalSinceDate:startDate];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    for (int i = 0; i < 100000; i++) {
        NSTimeInterval randomInterval = arc4random_uniform(dateRange);
        NSDate *date = [startDate dateByAddingTimeInterval:randomInterval];
        
        NSUInteger quarter = [[NSCalendar currentCalendar] component:NSCalendarUnitQuarter fromDate:date];
        
        [self.db executeUpdate:@"INSERT INTO sales (date, quarter, product_id, region_id, rep_id, total) VALUES (?, ?, ?, ?, ?, ?);"
         , [dateFormat stringFromDate:date], [NSNumber numberWithInt:quarter], [NSNumber numberWithInt:arc4random_uniform(5)]
         , [NSNumber numberWithInt:arc4random_uniform(5)], [NSNumber numberWithInt:arc4random_uniform(5)], [NSNumber numberWithDouble:100 + arc4random_uniform(900)]];
    }
    [self.db commit];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"1.0" forKey:@"db_version"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray*)years {
    NSMutableArray *years = [[NSMutableArray alloc] init];
    
    FMResultSet *s = [self.db executeQuery:@"SELECT strftime('%Y', date) AS year FROM sales GROUP BY 1;"];
    while ([s next]) {
        [years addObject:[NSNumber numberWithInt:[s intForColumnIndex:0]]];
    }
    return years;
}

- (NSArray*)products {
    NSMutableArray *products = [[NSMutableArray alloc] init];
    
    FMResultSet *s = [self.db executeQuery:@"SELECT id, industry_id, name FROM product ORDER BY name;"];
    while ([s next]) {
        [products addObject:[Product productWithId:[s intForColumnIndex:0]
                                          industry:[s intForColumnIndex:1]
                                              name:[s stringForColumnIndex:2]]];
    }
    
    return products;
}

- (NSArray*)industries {
    NSMutableArray *industries = [[NSMutableArray alloc] init];
    
    FMResultSet *s = [self.db executeQuery:@"SELECT id, name FROM industry ORDER BY name;"];
    while ([s next]) {
        [industries addObject:[Industry industryWithId:[s intForColumnIndex:0]
                                                  name:[s stringForColumnIndex:1]]];
    }
    return industries;
}

- (NSArray*)regions {
    NSMutableArray *regions = [[NSMutableArray alloc] init];
    
    FMResultSet *s = [self.db executeQuery:@"SELECT id, name FROM region ORDER BY name;"];
    while ([s next]) {
        [regions addObject:[Region regionWithId:[s intForColumnIndex:0]
                                           name:[s stringForColumnIndex:1]]];
    }
    return regions;
}

- (NSArray*)salesReps {
    NSMutableArray *salesReps = [[NSMutableArray alloc] init];
    
    FMResultSet *s = [self.db executeQuery:@"SELECT id, name FROM sales_reps ORDER BY name;"];
    while ([s next]) {
        [salesReps addObject:[SalesRep salesRepWithId:[s intForColumnIndex:0]
                                                 name:[s stringForColumnIndex:1]]];
    }
    return salesReps;
}

- (NSArray*)revenueByIndustryInYear:(NSNumber*)year
                          inQuarter:(NSNumber*)quarter
                         forProduct:(Product*)product
                           inRegion:(Region*)region
                        forIndustry:(Industry*)industry
                           salesRep:(SalesRep*)salesRep {
    
    NSMutableArray *res = [[NSMutableArray alloc] init];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSMutableString *query = [[NSMutableString alloc]
                              initWithString:@"SELECT industry.name AS name, SUM(sales.total) AS revenue "
                                              "FROM industry, sales, product "
                                              "WHERE sales.product_id = product.id AND "
                                              "product.industry_id = industry.id" ];
    if (year) {
        [query appendString:@" AND strftime('%Y', sales.date)=:year"];
        [params setObject:year forKey:@"year"];
    }
    
    if (quarter) {
        [query appendString:@" AND sales.quarter=:quarter"];
        [params setObject:quarter forKey:@"quarter"];
    }
    
    if (product) {
        [query appendString:@" AND sales.product_id=:product"];
        [params setObject:[NSNumber numberWithInt:product.productId] forKey:@"product"];
    }
    
    if (region) {
        [query appendString:@" AND sales.region_id=:region"];
        [params setObject:[NSNumber numberWithInt:region.regionId] forKey:@"region"];
    }
    
    if (industry) {
        [query appendString:@" AND industry.id=:industry"];
        [params setObject:[NSNumber numberWithInt:industry.industryId] forKey:@"insdustry"];
    }
    
    if (salesRep) {
        [query appendString:@" AND sales.rep_id=:sales_rep"];
        [params setObject:[NSNumber numberWithInt:salesRep.salesRepId] forKey:@"sales_rep"];
    }
    
    [query appendString:@" GROUP BY industry.id ORDER BY 1"];
    
    FMResultSet *s = [self.db executeQuery: query withParameterDictionary:params];
    while ([s next]) {
        [res addObject:@{@"revenue": [NSNumber numberWithDouble:[s doubleForColumn:@"revenue"]],
                         @"industry": [s stringForColumn:@"name"]}];
    }
    return res;
}

- (NSArray*)revenueBySalesRepInYear:(NSNumber *)year
                          inQuarter:(NSNumber *)quarter
                         forProduct:(Product *)product
                           inRegion:(Region *)region
                        forIndustry:(Industry *)industry
                           salesRep:(SalesRep *)salesRep {
    NSMutableArray *res = [[NSMutableArray alloc] init];
    return res;
}

- (void)dealloc {
    [self.db close];
}

@end
