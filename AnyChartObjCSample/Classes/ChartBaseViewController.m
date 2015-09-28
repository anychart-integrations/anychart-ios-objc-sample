//
//  ChartBaseViewController.m
//  AnyChartObjCSample
//
//  Created by Alexandr Batcuyev on 9/28/15.
//  Copyright © 2015 AnyChart. All rights reserved.
//

#import "ChartBaseViewController.h"

@interface ChartBaseViewController ()  {
    BOOL firstRenderCompleted;
}

@end

@implementation ChartBaseViewController

- (NSString*)htmlFileName { return nil; }
- (id)chartData { return nil; }

- (void)viewDidLoad {
    [super viewDidLoad];
    
    firstRenderCompleted = NO;
    
    [self.webView loadRequest:
     [NSURLRequest requestWithURL:
      [NSURL fileURLWithPath:
       [[NSBundle mainBundle] pathForResource:self.htmlFileName ofType:@"html"] isDirectory:NO]]];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (!webView.loading && !firstRenderCompleted) {
        [self updateChart];
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
        [self updateChart];
    }
}

- (void)updateChart {
    NSError* error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.chartData options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@"JSON generation failed: %@", error);
    }else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"showChart(%@)", jsonString]];
    }
    
    firstRenderCompleted = YES;
    [self.activityIndicatorView stopAnimating];
}

@end
