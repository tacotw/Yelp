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

@property (nonatomic, strong) NSMutableArray *categorySwitch;
@property (nonatomic, readonly) NSDictionary *filters;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSArray *sortData;
@property (nonatomic, strong) NSArray *distanceData;
@property (nonatomic, strong) NSMutableSet *selectedCategories;
@property (nonatomic, strong) NSUserDefaults *defaults;
@property (nonatomic, assign) NSInteger selectedSort;
@property (nonatomic, assign) NSInteger selectedDistance;

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
    
    self.defaults = [NSUserDefaults standardUserDefaults];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.categorySwitch = [NSMutableArray array];
    for (int i=0; i<4; i++) {
        //BOOL b = [self.defaults boolForKey:[NSString stringWithFormat:@"category%d", i]];
        [self.categorySwitch addObject:[NSNumber numberWithBool:false]];
    }
    [self loadSettings];
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
            rows = self.distanceData.count;
            break;
        case 2:
            rows = self.sortData.count;
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
            lCell.nameLabel.text = self.distanceData[indexPath.row][@"name"];
            if (indexPath.row == 0) {
                lCell.iconView.image = [UIImage imageNamed:@"listCellIcon"];
            }
            else {
                lCell.iconView.image = (self.selectedDistance == indexPath.row) ? [UIImage imageNamed:@"selected"] : [UIImage imageNamed:@"unselected"];
            }
            return lCell;
        case 2:
            lCell.nameLabel.text = self.sortData[indexPath.row][@"name"];
            if (indexPath.row == 0) {
                lCell.iconView.image = [UIImage imageNamed:@"listCellIcon"];
            }
            else {
                lCell.iconView.image = (self.selectedSort == indexPath.row) ? [UIImage imageNamed:@"selected"] : [UIImage imageNamed:@"unselected"];
            }
            return lCell;
        case 3:
            sCell.nameLabel.text = self.categories[indexPath.row][@"name"];
            sCell.controlSwitch.on = [[self.categorySwitch objectAtIndex:indexPath.row] boolValue];
            sCell.on = [self.categorySwitch[indexPath.row] boolValue];//[self.selectedCategories containsObject:self.categories[indexPath.row]];
            sCell.delegate = self;
            return sCell;
            
        default:
            return sCell;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    switch (indexPath.section) {
        case 1:
            for (NSInteger i=1; i<self.distanceData.count; i++) {
                ListCell *cell = (ListCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
                cell.iconView.image = (indexPath.row == i) ? [UIImage imageNamed:@"selected"] : [UIImage imageNamed:@"unselected"];
            }
            self.selectedDistance = indexPath.row;
            break;
        case 2:
            for (NSInteger i=1; i<self.sortData.count; i++) {
                ListCell *cell = (ListCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
                cell.iconView.image = (indexPath.row == i) ? [UIImage imageNamed:@"selected"] : [UIImage imageNamed:@"unselected"];
            }
            self.selectedSort = indexPath.row;
            break;
        case 0:
        case 3:
        default:
            break;
    }
}

- (IBAction)onApply:(id)sender {
    [self.delegate FilterTableViewController:self didChangeFilters:self.filters];
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
    self.sortData = @[
                  @{@"name" : @"Auto",
                    @"code" : @"0"},
                  @{@"name" : @"Best matched",
                    @"code" : @"0"},
                  @{@"name" : @"Distance",
                    @"code" : @"1"},
                  @{@"name" : @"Highest Rated",
                    @"code" : @"2"}
                  ];
    self.distanceData = @[
                      @{@"name" : @"Auto",
                        @"code" : @"0"},
                      @{@"name" : @"0.3 miles",
                        @"code" : @"483"},
                      @{@"name" : @"1 mile",
                        @"code" : @"1610"},
                      @{@"name" : @"5 miles",
                        @"code" : @"8047"}/*,
                      @{@"name" : @"20 miles",
                        @"code" : @"32187"}*/
                      ];
}

- (NSDictionary *)filters {
    NSMutableDictionary *filters = [NSMutableDictionary dictionary];
    
    [self saveSettings];
    if (self.selectedCategories.count > 0) {
        NSMutableArray *names = [NSMutableArray array];
        for (NSDictionary *category in self.selectedCategories) {
            [names addObject:category[@"code"]];
        }
        NSString *categoryFilter = [names componentsJoinedByString:@","];
        [filters setObject:categoryFilter forKey:@"category_filter"];
    }
    if (self.selectedDistance) {
        [filters setObject:self.distanceData[self.selectedDistance][@"code"] forKey:@"radius_filter"];
    }
    if (self.selectedSort) {
        [filters setObject:self.sortData[self.selectedSort][@"code"] forKey:@"sort"];
    }
    
    return filters;
}

- (void) loadSettings {
    self.selectedSort = [self.defaults integerForKey:@"sort"];
    self.selectedDistance = [self.defaults integerForKey:@"distance"];
    for (int i=0; i<4; i++) {
        BOOL b = [self.defaults boolForKey:[NSString stringWithFormat:@"category%d", i]];
        [self.categorySwitch replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:b]];
    }
}

- (void) saveSettings {
    [self.defaults setInteger:self.selectedSort forKey:@"sort"];
    [self.defaults setInteger:self.selectedDistance forKey:@"distance"];
    for (int i=0; i<4; i++) {
        BOOL b = [self.categorySwitch[i] boolValue];
        [self.defaults setBool:b forKey:[NSString stringWithFormat:@"category%d", i]];
    }
    [self.defaults synchronize];
}

#pragma mark - Switch cell delegate methods

- (void)switchCell:(SwitchCell *)cell didUpdateValue:(BOOL)value {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    [self.categorySwitch replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:value]];
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
