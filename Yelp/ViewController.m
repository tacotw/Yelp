//
//  ViewController.m
//  Yelp
//
//  Created by Taco Chang on 2015/6/25.
//  Copyright (c) 2015年 Taco Chang. All rights reserved.
//

#import "ViewController.h"
#import "YelpClient.h"
#import "Business.h"
#import "BusinessCell.h"
#import "FilterTableViewController.h"

NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface ViewController () <UITabBarDelegate, UITableViewDataSource, FilterTableViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) YelpClient *client;
@property (nonatomic, strong) NSArray *businesses;
//@property (nonatomic, strong) NSString *query;
@property (nonatomic, strong) NSMutableString *query;
@property (nonatomic, strong) NSDictionary *filters;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,0, 250,44)];
    self.searchBar.placeholder = @"Restaurants";
    UIBarButtonItem *searchBarItem = [[UIBarButtonItem alloc]initWithCustomView:self.searchBar];
    self.navigationItem.leftBarButtonItem = searchBarItem;
    self.searchBar.delegate = (id) self;
    
    self.tableView.delegate = (id) self;
    self.tableView.dataSource = self;
    
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.filters = nil;
    self.query = [[NSMutableString alloc] initWithString:@""];
    
    // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
    self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
    [self doSearch:self.query params:self.filters];
}

- (void)doSearch:(NSString *)query params:(NSDictionary *)params {
    
    [self.client searchWithTerm:query params:params success:^(AFHTTPRequestOperation *operation, id response) {
//        NSLog(@"response: %@", response);
        NSArray *businessDictionaries = response[@"businesses"];
        
        self.businesses = [Business businessWithDictionaries:businessDictionaries];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.businesses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BusinessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BusinessCell"];
    cell.business = self.businesses[indexPath.row];
    return cell;
}

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
//    self.query = text;
    [self.query setString:text];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self doSearch:self.query params:self.filters];
    [searchBar resignFirstResponder];
    // You can write search code Here
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Filter delegate methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *navVC = segue.destinationViewController;
    FilterTableViewController *filterVC = (FilterTableViewController *) navVC.topViewController;
    filterVC.delegate = self;
}

- (void)FilterTableViewController:(FilterTableViewController *)FilterTableViewController didChangeFilters:(NSDictionary *)filters {
    [self.query setString:@""];
    self.filters = filters;
    self.searchBar.text = @"";
    [self doSearch:self.query params:filters];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
