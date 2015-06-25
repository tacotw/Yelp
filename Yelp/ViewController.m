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

NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface ViewController () <UITabBarDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) YelpClient *client;
@property (nonatomic, strong) NSArray *businesses;
@property (nonatomic, strong) NSString *query;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,0, 250,44)];
    searchBar.placeholder = @"Search";
    UIBarButtonItem *searchBarItem = [[UIBarButtonItem alloc]initWithCustomView:searchBar];
    self.navigationItem.leftBarButtonItem = searchBarItem;
    searchBar.delegate = (id) self;
    
    self.tableView.delegate = (id) self;
    self.tableView.dataSource = self;
    
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self doSearch:@""];
}

- (void)doSearch:(NSString *)query {
    
    // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
    self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
    
    [self.client searchWithTerm:query success:^(AFHTTPRequestOperation *operation, id response) {
        //NSLog(@"response: %@", response);
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
    self.query = text;
    if(text.length > 0)
    {
        //[self doSearch:text];
        NSLog(@"%@", text);
//        [self fetchBusinessWithQuery:text params:self.filters];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self doSearch:self.query];
    [searchBar resignFirstResponder];
    // You can write search code Here
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
