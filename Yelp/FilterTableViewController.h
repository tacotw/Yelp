//
//  FilterTableViewController.h
//  Yelp
//
//  Created by Taco Chang on 2015/6/26.
//  Copyright (c) 2015年 Taco Chang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FilterTableViewController;

@protocol FilterTableViewControllerDelegate <NSObject>

- (void)FilterTableViewController:(FilterTableViewController *) FilterTableViewController didChangeFilters:(NSDictionary *)filters;

@end

@interface FilterTableViewController : UITableViewController

@property (nonatomic, weak) id<FilterTableViewControllerDelegate> delegate;

@end
