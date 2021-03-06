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
        self.currentAverage = 40.f;
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
        volatile CGFloat result;
        for (NSInteger i=0; i < 150001; i++) {
            result = sqrt((double)i);
        }
        result = (indexPath.row % 3 + 1) * 20.0;

        CGFloat calcedHeight = result;
        cachedHeightForRow = @(calcedHeight);
        self.cachedHeights[indexPath] = cachedHeightForRow;
        
        NSUInteger previousAverageTotal = self.totalAveraged;
        CGFloat previousExpandedAverages = previousAverageTotal * self.currentAverage;
        
        self.totalAveraged++;
        self.currentAverage = (previousExpandedAverages + calcedHeight) / (CGFloat)self.totalAveraged;
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
