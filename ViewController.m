//
//  ViewController.m
//  SBSearchController
//
//  Created by BendarySiu on 15/12/28.
//  Copyright © 2015年 Sentry. All rights reserved.
//

#import "ViewController.h"
#import "SBSearchController.h"

@interface ViewController () <SBSearchControllerDelegate,SBSearchBarDelegate>

@property (nonatomic,strong) SBSearchController *searchController;

@end

@implementation ViewController

- (SBSearchController *)searchController
{
    if (!_searchController)
    {
        _searchController = [[SBSearchController alloc] initWithDelegate:self];
    }
    return _searchController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarItemClick:)];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightBarItemClick:(UIBarButtonItem *)item
{
    [self.searchController setActive:YES animated:YES];
}

#pragma mark - SBSearchControllerDelegate

- (UIViewController *)presentingController
{
    return self;
}







@end
