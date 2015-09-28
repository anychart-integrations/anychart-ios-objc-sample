//
//  ChartBaseViewController.h
//  AnyChartObjCSample
//
//  Created by Alexandr Batcuyev on 9/28/15.
//  Copyright © 2015 AnyChart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChartBaseViewController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

- (NSString*)htmlFileName;
- (id)chartData;

@end