//
//  VideosViewController.m
//  listingOne
//
//  Created by Alberto Morales on 11/22/13.
//  Copyright (c) 2013 lickmyscreenclean.com. All rights reserved.
//

#import "VideosViewController.h"
#import "SearchResult.h"

@interface VideosViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation VideosViewController {
    NSMutableArray *_searchResults;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //nudge the tableView down so that two rows are not hidden
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (_searchResults == nil) {
        return 0;
    }
    else if ([_searchResults count] == 0){
        return 1;
    }
    else {
        return [_searchResults count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SearchResultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if([_searchResults count] == 0) {
        cell.textLabel.text = @"(Nothing found)";
        cell.detailTextLabel.text = @"";
    }
    else {
        SearchResult *searchResult = _searchResults[indexPath.row];
        cell.textLabel.text = searchResult.name;
        cell.detailTextLabel.text = searchResult.artistName;
    }
    return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_searchResults count] == 0) {
        return nil;
    } else {
        return indexPath;
    }
}


#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    _searchResults = [NSMutableArray arrayWithCapacity:10];
    if (![searchBar.text isEqualToString:@"justin bieber"]) {
        for (int i = 0; i < 3; i++) {
            SearchResult *searchResult = [[SearchResult alloc] init]; searchResult.name = [NSString stringWithFormat: @"Fake Result %d for", i];
            searchResult.artistName = searchBar.text;
            [_searchResults addObject:searchResult]; }
    }
    [self.tableView reloadData];
}
        
        

- (UIBarPosition)positionForBar:(id <UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

@end
