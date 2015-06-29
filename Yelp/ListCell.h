//
//  ListCell.h
//  Yelp
//
//  Created by Taco Chang on 2015/6/26.
//  Copyright (c) 2015年 Taco Chang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ListCell;

@protocol ListCellDelegate <NSObject>

- (void)ListCell:(ListCell *)cell didUpdateValue:(BOOL)value;

@end

@interface ListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) id<ListCellDelegate> delegate;
@property (assign, nonatomic) BOOL on;


@end
