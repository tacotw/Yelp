//
//  Business.h
//  Yelp
//
//  Created by Taco Chang on 2015/6/24.
//  Copyright (c) 2015年 Taco Chang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Business : NSObject

@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *ratingImageUrl;
@property (nonatomic, assign) NSInteger numReviews;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *categories;
@property (nonatomic, assign) CGFloat distance;

+ (NSArray *)businessWithDictionaries:(NSArray *)dictionaries;

@end
