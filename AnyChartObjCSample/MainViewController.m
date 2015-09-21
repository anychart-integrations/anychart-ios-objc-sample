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
}

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    firstRenderCompleted = NO;
    
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
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    if (firstRenderCompleted) {
        [self.webView stringByEvaluatingJavaScriptFromString:@"clear();"];
        [self.activityIndicatorView startAnimating];
    }
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

@end
