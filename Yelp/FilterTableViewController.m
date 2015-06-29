//
//  FilterTableViewController.m
//  Yelp
//
//  Created by Taco Chang on 2015/6/26.
//  Copyright (c) 2015年 Taco Chang. All rights reserved.
//

#import "FilterTableViewController.h"
#import "SwitchCell.h"
#import "ListCell.h"

@interface FilterTableViewController () <UITabBarDelegate, UITableViewDataSource, SwitchCellDelegate>

@property (nonatomic, strong) NSArray *categoryTitle;
@property (nonatomic, strong) NSArray *categoryQuery;
@property (nonatomic, strong) NSMutableArray *categorySwitch;
@property (nonatomic, readonly) NSDictionary *filters;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSMutableSet *selectedCategories;

- (IBAction)onApply:(id)sender;
- (IBAction)onCancel:(id)sender;
- (void)initCategories;

@end

@implementation FilterTableViewController

- (void)viewWillAppear:(BOOL)animated {
    self.selectedCategories = [NSMutableSet set];
    [self initCategories];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.categorySwitch = [NSMutableArray array];
    for (int i=0; i<4; i++) {
        BOOL b = [defaults boolForKey:[NSString stringWithFormat:@"category%ld", (long)i]];
        [self.categorySwitch addObject:[NSNumber numberWithBool:b]];
//        NSInteger value = [defaults integerForKey:[NSString stringWithFormat:@"category%ld", (long)i]];
//        [self.categorySwitch addObject:value];//[NSNumber numberWithInt:value]];
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSInteger rows;
    
    switch (section) {
        case 0:
            rows = 1;
            break;
        case 1:
            rows = 1;
            break;
        case 2:
            rows = 1;
            break;
        case 3:
            rows = 4;
            break;
            
        default:
            break;
    }
    return rows;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title;
    
    switch (section) {
        case 0:
            title = @"";
            break;
        case 1:
            title = @"Distance";
            break;
        case 2:
            title = @"Sort By";
            break;
        case 3:
            title = @"Category";
            break;
            
        default:
            break;
    }
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SwitchCell *sCell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
    ListCell *lCell = [tableView dequeueReusableCellWithIdentifier:@"ListCell"];
    
    switch (indexPath.section) {
        case 0:
            sCell.nameLabel.text = @"Offering a Deal";
            sCell.delegate = self;
            return sCell;
        case 1:
            lCell.nameLabel.text = @"Auto";
            //lCell.delegate = self;
            return lCell;
        case 2:
            lCell.nameLabel.text = @"Auto";
            //lCell.delegate = self;
            return lCell;
        case 3:
            sCell.nameLabel.text = self.categories[indexPath.row][@"name"];
            sCell.controlSwitch.on = [[self.categorySwitch objectAtIndex:indexPath.row] boolValue];
            sCell.on = [self.selectedCategories containsObject:self.categories[indexPath.row]];
            sCell.delegate = self;
            return sCell;
            
        default:
            return sCell;
    }

}

- (IBAction)onApply:(id)sender {
    [self.delegate FilterTableViewController:self didChangeFilters:self.filters];
    NSLog(@"Filter");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initCategories {
    self.categories = @[
                        @{@"name" : @"ATV Rentals/Tours",
                          @"code" : @"atvrentals"},
                        @{@"name" : @"Amateur Sports Teams",
                          @"code" : @"amateursportsteams"},
                        @{@"name" : @"Amusement Parks",
                          @"code" : @"amusementparks"},
                        @{@"name" : @"Aquariums",
                          @"code" : @"aquariums"}
                        ];
    
    self.categoryTitle = @[@"ATV Rentals/Tours", @"Amateur Sports Teams", @"Amusement Parks", @"Aquariums"];
    self.categoryQuery = @[@"atvrentals", @"amateursportsteams", @"amusementparks", @"aquariums"];
}

- (NSDictionary *)filters {
    NSMutableDictionary *filters = [NSMutableDictionary dictionary];
    
    if (self.selectedCategories.count > 0) {
        NSMutableArray *names = [NSMutableArray array];
        for (NSDictionary *category in self.selectedCategories) {
            [names addObject:category[@"code"]];
        }
        NSString *categoryFilter = [names componentsJoinedByString:@","];
        [filters setObject:categoryFilter forKey:@"category_filter"];
    }
    
    return filters;
}

#pragma mark - Switch cell delegate methods

- (void)switchCell:(SwitchCell *)cell didUpdateValue:(BOOL)value {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    if (value) {
        [self.selectedCategories addObject:self.categories[indexPath.row]];
    }
    else {
        [self.selectedCategories removeObject:self.categories[indexPath.row]];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
