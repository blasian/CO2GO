//
//  SearchViewController.m
//  CO2GO
//
//  Created by Michael Spearman on 3/14/15.
//  Copyright (c) 2015 Michael Spearman. All rights reserved.
//

#import "SearchViewController.h"
#import "Cars.h"

@interface SearchViewController () <UISearchResultsUpdating, UISearchBarDelegate>

@property (nonatomic, strong) NSMutableArray *searchResults; // Filtered search results
@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Create a mutable array to contain products for the search results table.
    self.searchResults = [NSMutableArray arrayWithCapacity:[[Cars sharedData] count]];
    
    // The table view controller is in a nav controller, and so the containing nav controller is the 'search results controller'
    UINavigationController *searchResultsController = [[self storyboard] instantiateViewControllerWithIdentifier:@"TableSearchResultsNavController"];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultsController];
    
    self.searchController.searchResultsUpdater = self;
    
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *searchString = [self.searchController.searchBar text];
    
    NSString *scope = nil;
    
    NSInteger selectedScopeButtonIndex = [self.searchController.searchBar selectedScopeButtonIndex];

    if (selectedScopeButtonIndex > 0) {
        scope = [[Cars deviceTypeNames] objectAtIndex:(selectedScopeButtonIndex - 1)];
    }
    
    [self updateFilteredContentForProductName:searchString type:scope];
    
    if (self.searchController.searchResultsController) {
        UINavigationController *navController = (UINavigationController *)self.searchController.searchResultsController;
        
        SearchResultsTableViewController *vc = (SearchResultsTableViewController *)navController.topViewController;
        vc.searchResults = self.searchResults;
        [vc.tableView reloadData];
    }
    
}

- (void)updateFilteredContentForProductName:(NSString *)productName type:(NSString *)typeName {
    
    // Update the filtered array based on the search text and scope.
    if ((productName == nil) || [productName length] == 0) {
        // If there is no search string and the scope is "All".
        if (typeName == nil) {
            self.searchResults = [self.products mutableCopy];
        } else {
            // If there is no search string and the scope is chosen.
            NSMutableArray *searchResults = [[NSMutableArray alloc] init];
            for (Product *product in self.products) {
                if ([product.type isEqualToString:typeName]) {
                    [searchResults addObject:product];
                }
            }
            self.searchResults = searchResults;
        }
        return;
    }
    
    
    [self.searchResults removeAllObjects]; // First clear the filtered array.
    
    /*  Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
     */
    for (Product *product in self.products) {
        if ((typeName == nil) || [product.type isEqualToString:typeName]) {
            NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
            NSRange productNameRange = NSMakeRange(0, product.name.length);
            NSRange foundRange = [product.name rangeOfString:productName options:searchOptions range:productNameRange];
            if (foundRange.length > 0) {
                [self.searchResults addObject:product];
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
