//
//  SwitchCell.h
//  Yelp
//
//  Created by Taco Chang on 2015/6/26.
//  Copyright (c) 2015年 Taco Chang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SwitchCell;

@protocol SwitchCellDelegate <NSObject>

- (void)switchCell:(SwitchCell *)cell didUpdateValue:(BOOL)value;

@end

@interface SwitchCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UISwitch *controlSwitch;
@property (weak, nonatomic) id<SwitchCellDelegate> delegate;
@property (assign, nonatomic) BOOL on;

- (IBAction)switchValueChanged:(id)sender;
- (void)setOn:(BOOL)on animated:(BOOL)animated;

@end
