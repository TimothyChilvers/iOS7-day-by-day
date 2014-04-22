//
//  SCCachingEstimatingTableViewDelegate.m
//  VariTable
//
//  Created by Tim Chilvers on 22/04/2014.
//  Copyright (c) 2014 shinobicontrols. All rights reserved.
//

#import "SCCachingEstimatingTableViewDelegate.h"

@interface SCCachingEstimatingTableViewDelegate()

@property (nonatomic,strong) NSMutableDictionary *cachedHeights;
@property (nonatomic,assign) NSUInteger totalAveraged;
@property (nonatomic,assign) CGFloat currentAverage;
@end

@implementation SCCachingEstimatingTableViewDelegate

- (id)initWithNumberOfRows:(NSInteger)numberOfRows {
    self = [super init];
    if (self != nil) {
        self.cachedHeights = [NSMutableDictionary dictionaryWithCapacity:numberOfRows];
        self.currentAverage = 20.f;
        self.totalAveraged = 1;
    }
    return self;
}

- (NSNumber *)_cachedHeightForPath:(NSIndexPath *)path {
    return self.cachedHeights[path];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSNumber *cachedHeightForRow = [self _cachedHeightForPath:indexPath];
    if (!cachedHeightForRow) {
        CGFloat calcedHeight = [super tableView:tableView heightForRowAtIndexPath:indexPath];
        cachedHeightForRow = @(calcedHeight);
        self.cachedHeights[indexPath] = cachedHeightForRow;
        self.totalAveraged++;
        self.currentAverage = (self.currentAverage + calcedHeight) / (CGFloat)self.totalAveraged;
    }
    return cachedHeightForRow.floatValue;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSNumber *cachedHeightForRow = [self _cachedHeightForPath:indexPath];
    if (cachedHeightForRow) {
        return cachedHeightForRow.floatValue;
    } else {
        return self.currentAverage;
    }
    
}

@end
