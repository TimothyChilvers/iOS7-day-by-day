/*
 Copyright 2013 Scott Logic Ltd
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */


#import "SCViewController.h"
#import "SCEstimatingTableViewDelegate.h"
#import "SCNonEstimatingTableViewDelegate.h"
#import "SCCachingEstimatingTableViewDelegate.h"

@interface SCViewController () {
    id<UITableViewDelegate> _delegate;
    NSDate *_loadStartTime;
}

@end

@implementation SCViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRedo target:self action:@selector(_reloadAction)];
    }
    return self;
}

- (void)_reloadAction
{
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _loadStartTime = [NSDate date];
    
    switch (self.heightCalculationType) {
        case SCHeightCalculationSlow:
            _delegate = [[SCNonEstimatingTableViewDelegate alloc] init];
            break;
        case SCHeightCalculationEstimation:
            _delegate = [[SCEstimatingTableViewDelegate alloc] init];
            break;
        case SCHeightCalculationEstimationCaching:
            _delegate = [[SCCachingEstimatingTableViewDelegate alloc] initWithNumberOfRows:200];
            break;
            
        default:
            break;
    }
    self.tableView.delegate = _delegate;
}

- (void)viewDidAppear:(BOOL)animated
{
    if(_loadStartTime) {
        NSDate *finishLoadTime = [NSDate date];
        NSTimeInterval loadDuration = [finishLoadTime timeIntervalSinceDate:_loadStartTime];
        NSLog(@"Total Load Time: %0.2f", loadDuration);
    }
    _loadStartTime = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [NSString stringWithFormat:@"Cell %03d", indexPath.row];
    
    // Even though this is not legit in real code, we would likely need to call equivalently expensive methods to do layout around about this time anyway. So shut up.
    CGFloat height = [_delegate tableView:tableView heightForRowAtIndexPath:indexPath];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Height %0.2f", height];
    return cell;
}


@end
