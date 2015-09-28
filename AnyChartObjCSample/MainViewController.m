//
//  ViewController.m
//  AnyChartObjCSample
//
//  Created by Alexandr Batcuyev on 9/17/15.
//  Copyright (c) 2015 AnyChart. All rights reserved.
//

#import "MainViewController.h"
#import "Data.h"
#import "Filters.h"

@interface MainViewController () {
    BOOL firstRenderCompleted;
    BOOL filtersVisible;
}

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIButton *filtersButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pickerViewTopSpace;

@property NSArray* years;
@property NSArray* quarters;
@property NSArray* industries;
@property NSArray* products;
@property NSArray* regions;
@property NSArray* salesReps;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.years = [Data shared].years;
    self.industries = [Data shared].industries;
    self.products = [Data shared].products;
    self.regions = [Data shared].regions;
    self.salesReps = [Data shared].salesReps;
    self.quarters = @[@"Q1", @"Q2", @"Q3", @"Q4"];
    
    firstRenderCompleted = NO;
    filtersVisible = NO;
    
    self.pickerViewTopSpace.constant = -self.pickerView.frame.size.height;
    
    [self.webView loadRequest:
     [NSURLRequest requestWithURL:
      [NSURL fileURLWithPath:
       [[NSBundle mainBundle] pathForResource:@"charts" ofType:@"html"] isDirectory:NO]]];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (!webView.loading && !firstRenderCompleted) {
        [self setChartsData];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setSelectedFilter:[Filters year] forComponent:FilterKeyYear];
    [self setSelectedFilter:[Filters quarter] forComponent:FilterKeyQuarter];
    [self setSelectedFilter:[Filters industryId] forComponent:FilterKeyIndustryId];
    [self setSelectedFilter:[Filters productId] forComponent:FilterKeyProductId];
    [self setSelectedFilter:[Filters regionId] forComponent:FilterKeyRegionId];
    [self setSelectedFilter:[Filters salesRepId] forComponent:FilterKeySalesRepId];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (firstRenderCompleted) {
        [self setChartsData];
    }
}

- (void)setChartsData {
    NSMutableDictionary* data = [[NSMutableDictionary alloc] init];
    [data setObject:[[Data shared] revenueByIndustryInYear:[Filters year]
                                                 inQuarter:[Filters quarter]
                                                forProduct:[Filters productId]
                                                  inRegion:[Filters regionId]
                                               forIndustry:[Filters industryId]
                                                  salesRep:[Filters salesRepId]]
             forKey:@"revenue-by-industry"];
    [data setObject:[[Data shared] revenueBySalesRepInYear:[Filters year]
                                                 inQuarter:[Filters quarter]
                                                forProduct:[Filters productId]
                                                  inRegion:[Filters regionId]
                                               forIndustry:[Filters industryId]
                                                  salesRep:[Filters salesRepId]]
             forKey:@"revenue-by-sales"];
    [data setObject:[[Data shared] revenueByProductInYear:[Filters year]
                                                inQuarter:[Filters quarter]
                                               forProduct:[Filters productId]
                                                 inRegion:[Filters regionId]
                                              forIndustry:[Filters industryId]
                                                 salesRep:[Filters salesRepId]]
             forKey:@"revenue-by-product"];
    [data setObject:[[Data shared] revenueByQuarterInYear:[Filters year]
                                                inQuarter:[Filters quarter]
                                               forProduct:[Filters productId]
                                                 inRegion:[Filters regionId]
                                              forIndustry:[Filters industryId]
                                                 salesRep:[Filters salesRepId]]
             forKey:@"revenue-by-quarter"];
    
    NSError* error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@"JSON generation failed: %@", error);
    }else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"showCharts(%@)", jsonString]];
    }
    
    firstRenderCompleted = YES;
    [self.activityIndicatorView stopAnimating];
}

- (IBAction)toggleFilters:(id)sender {
    filtersVisible = !filtersVisible;
    [self.view layoutIfNeeded];
    if (filtersVisible) {
        self.pickerViewTopSpace.constant = 0;
        [self.filtersButton setTitle:@"Apply" forState:UIControlStateNormal];
    }else {
        self.pickerViewTopSpace.constant = -self.pickerView.frame.size.height;
        [self.filtersButton setTitle:@"Filters" forState:UIControlStateNormal];
        [self.activityIndicatorView startAnimating];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateCharts];
        });
        
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)updateCharts {
    if (firstRenderCompleted) {
        [self.webView stringByEvaluatingJavaScriptFromString:@"clear();"];
        [self.activityIndicatorView startAnimating];
        [self setChartsData];
    }
}

#pragma mark UIPickerViewDataSource, UIPickerViewDelegate

- (void)setSelectedFilter:(id)value forComponent:(FilterKey)component {
    if (value == nil) {
        [self.pickerView selectRow:0 inComponent:component animated:NO];
    }else {
        if (component == FilterKeyYear) {
            [self.pickerView selectRow:[self.years indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                return [(NSNumber*)obj intValue] == [(NSNumber*)value intValue];
            }] + 1 inComponent:component animated:NO];
        }else if (component == FilterKeyQuarter) {
            [self.pickerView selectRow:[[self pickerItemsForComponent:component] indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                return [(NSString*)obj isEqualToString:[NSString stringWithFormat:@"Q%@", value]];
            }] + 1 inComponent:component animated:NO];
        }else {
            [self.pickerView selectRow:[[self pickerItemsForComponent:component] indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                return [(IdNameModel*)obj identifier] == [(NSNumber*)value intValue];
            }] + 1 inComponent:component animated:NO];
        }
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 6;
}

- (NSArray*)pickerItemsForComponent:(NSInteger)component {
    if (component == FilterKeyYear) return self.years;
    if (component == FilterKeyQuarter) return self.quarters;
    if (component == FilterKeyIndustryId) return self.industries;
    if (component == FilterKeyProductId) return self.products;
    if (component == FilterKeyRegionId) return self.regions;
    if (component == FilterKeySalesRepId) return self.salesReps;
    return nil;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self pickerItemsForComponent:component].count + 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (row == 0)
        return @"All";
    
    id val = [[self pickerItemsForComponent:component] objectAtIndex:(row-1)];
    if (component == FilterKeyYear) {
        return [(NSNumber*)val stringValue];
    }else if (component == FilterKeyQuarter) {
        return val;
    }else {
        return [(IdNameModel*)val name];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSNumber *value;
    if (row == 0) {
        value = nil;
    }else if (component == FilterKeyQuarter) {
        value = [NSNumber numberWithInt:row];
    }else if (component == FilterKeyYear) {
        value = [[self pickerItemsForComponent:component] objectAtIndex:(row - 1)];
    }else {
        value = [NSNumber numberWithInt:[(IdNameModel*)([[self pickerItemsForComponent:component] objectAtIndex:(row - 1)]) identifier]];
    }
    [Filters setFilterValue:value forKey:component];
}

@end
