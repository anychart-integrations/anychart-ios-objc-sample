//
//  FiltersViewController.m
//  AnyChartObjCSample
//
//  Created by Alexandr Batcuyev on 9/18/15.
//  Copyright (c) 2015 AnyChart. All rights reserved.
//

#import "FiltersViewController.h"
#import "Filters.h"
#import "Data.h"

@interface FiltersViewController ()

@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIView *overlayView;
@property (weak, nonatomic) IBOutlet UIButton *yearsButton;
@property (weak, nonatomic) IBOutlet UIButton *quartersButton;
@property (weak, nonatomic) IBOutlet UIButton *industryButton;
@property (weak, nonatomic) IBOutlet UIButton *regionButton;
@property (weak, nonatomic) IBOutlet UIButton *productButton;
@property (weak, nonatomic) IBOutlet UIButton *salesRepButton;

@property NSArray* currentFilterItems;
@property NSNumber* selectedFitlerItem;
@property FilterKey currentFilterKey;

@end

@implementation FiltersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateFilters];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)updateFilters {
    [self.yearsButton setTitle:([Filters year] == nil ? @"All" : [[Filters year] stringValue])
                      forState:UIControlStateNormal];
    
    [self.quartersButton setTitle:([Filters quarter] == nil ? @"All" : [[Filters quarter] stringValue])
                         forState:UIControlStateNormal];
    
    if ([Filters industryId] == nil) {
        [self.industryButton setTitle:@"All" forState:UIControlStateNormal];
    }else {
        Industry *val = [[Data shared] industryById:[Filters industryId]];
        [self.industryButton setTitle:val.name forState:UIControlStateNormal];
    }
    
    if ([Filters regionId] == nil) {
        [self.regionButton setTitle:@"All" forState:UIControlStateNormal];
    }else {
        Region *val = [[Data shared] regionById:[Filters regionId]];
        [self.regionButton setTitle:val.name forState:UIControlStateNormal];
    }
    
    if ([Filters productId] == nil) {
        [self.productButton setTitle:@"All" forState:UIControlStateNormal];
    }else {
        Product *val = [[Data shared] productById:[Filters productId]];
        [self.productButton setTitle:val.name forState:UIControlStateNormal];
    }
    
    if ([Filters salesRepId] == nil) {
        [self.salesRepButton setTitle:@"All" forState:UIControlStateNormal];
    }else {
        SalesRep *val = [[Data shared] salesRepById:[Filters salesRepId]];
        [self.salesRepButton setTitle:val.name forState:UIControlStateNormal];
    }
}

- (void)showPickerFor:(NSArray*)items key:(FilterKey)key {
    self.currentFilterItems = items;
    self.currentFilterKey = key;
    self.selectedFitlerItem = [Filters filterValueForKey:key];
    
    [self.pickerView reloadAllComponents];
    
    CGFloat height = self.view.frame.size.height;
    CGPoint offScreenBelow = CGPointMake(0, height);
    CGPoint onScreen = CGPointMake(0, height - self.pickerView.frame.size.height);
    CGRect frame = self.pickerView.frame;
    frame.size = CGSizeMake(self.view.bounds.size.width, frame.size.height);
    frame.origin = offScreenBelow;
    self.pickerView.frame = frame;
    [self.view addSubview:self.pickerView];
    
    if (self.selectedFitlerItem != nil) {
        int val = [self.selectedFitlerItem intValue];
        
        if (self.currentFilterKey == FilterKeyYear || self.currentFilterKey == FilterKeyQuarter) {
            [self.pickerView selectRow:[items indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                return [(NSNumber*)obj intValue] == val;
            }] + 1 inComponent:0 animated:NO];
        }else {
            [self.pickerView selectRow:[items indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                return [(IdNameModel*)obj identifier] == val;
            }] + 1 inComponent:0 animated:NO];
        }
    }else {
        [self.pickerView selectRow:0 inComponent:0 animated:NO];
    }
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         CGRect frame = self.pickerView.frame;
                         frame.origin = onScreen;
                         self.pickerView.frame = frame;
                     }
                     completion:^(BOOL finished){
                         self.overlayView.hidden = NO;
                     }];
}

- (IBAction)hideFilter:(id)sender {
    NSInteger selectedIndex = [self.pickerView selectedRowInComponent:0];
    if (selectedIndex == 0) {
        [Filters setFilterValue:nil forKey:self.currentFilterKey];
    }else {
        if (self.currentFilterKey == FilterKeyYear || self.currentFilterKey == FilterKeyQuarter) {
            [Filters setFilterValue:[self.currentFilterItems objectAtIndex:(selectedIndex - 1)] forKey:self.currentFilterKey];
        }else {
            [Filters setFilterValue:[NSNumber numberWithInt:[(IdNameModel*)[self.currentFilterItems objectAtIndex:(selectedIndex - 1)] identifier]]
                             forKey:self.currentFilterKey];
        }
    }
    [self updateFilters];
    
    CGPoint offScreenBelow = CGPointMake(0, self.view.frame.size.height);
    [UIView animateWithDuration:0.3
                     animations:^{
                         CGRect frame = self.pickerView.frame;
                         frame.origin = offScreenBelow;
                         self.pickerView.frame = frame;
                     }
                     completion:^(BOOL finished){
                         self.overlayView.hidden = YES;
                         [self.pickerView removeFromSuperview];
                     }];
}

- (IBAction)filterByYears:(id)sender {
    [self showPickerFor:[[Data shared] years] key:FilterKeyYear];
}
- (IBAction)filterByQuarters:(id)sender {
    [self showPickerFor:@[@1, @2, @3, @4] key:FilterKeyQuarter];
}
- (IBAction)filterByIndustry:(id)sender {
    [self showPickerFor:[[Data shared] industries] key:FilterKeyIndustryId];
}
- (IBAction)filterByRegion:(id)sender {
    [self showPickerFor:[[Data shared] regions] key:FilterKeyRegionId];
}
- (IBAction)filterByProduct:(id)sender {
    [self showPickerFor:[[Data shared] products] key:FilterKeyProductId];
}
- (IBAction)filterBySalesRep:(id)sender {
    [self showPickerFor:[[Data shared] salesReps] key:FilterKeySalesRepId];
}

#pragma mark UIPickerViewDataSource, UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.currentFilterItems.count + 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (row == 0)
        return @"All";
    
    id val = [self.currentFilterItems objectAtIndex:(row-1)];
    if (self.currentFilterKey == FilterKeyYear || self.currentFilterKey == FilterKeyQuarter) {
        return [(NSNumber*)val stringValue];
    }else {
        return [(IdNameModel*)val name];
    }
}

@end
