//
//  VideosViewController.m
//  listingOne
//
//  Created by Alberto Morales on 11/22/13.
//  Copyright (c) 2013 lickmyscreenclean.com. All rights reserved.
//

static NSString * const NothingFoundCellIndentifier = @"NothingFoundCell";
static NSString * const SearchResultCellIdentifier = @"SearchResultCell";

#import "VideosViewController.h"
#import "SearchResult.h"
#import "SearchResultCell.h"

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
    
    UINib *cellNib = [UINib nibWithNibName:@"SearchResultCell" bundle:nil];
    
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"SearchResultCell"];
    
    // set the cell row height to match our custom cell
    self.tableView.rowHeight = 80;
    
    cellNib = [UINib nibWithNibName:NothingFoundCellIndentifier bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:NothingFoundCellIndentifier];
    
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
    if ([_searchResults count] == 0) {
        return [tableView dequeueReusableCellWithIdentifier: NothingFoundCellIndentifier forIndexPath:indexPath];
    } else
    {
        SearchResultCell *cell = (SearchResultCell *)[tableView dequeueReusableCellWithIdentifier: SearchResultCellIdentifier forIndexPath:indexPath];
        SearchResult *searchResult = _searchResults[indexPath.row];
        cell.nameLabel.text = searchResult.name;
        cell.descriptionLabel.text = searchResult.description;
        return cell;
    }
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
    if ([searchBar.text length] > 0) { [searchBar resignFirstResponder];
        _searchResults = [NSMutableArray arrayWithCapacity:10];
        NSURL *url = [self urlWithSearchText:searchBar.text]; NSString *jsonString = [self performStoreRequestWithURL:url];
        if (jsonString == nil) {
            [self showNetworkError]; return;
        }
        NSDictionary *dictionary = [self parseJSON:jsonString];
        if (dictionary == nil) {
            [self showNetworkError];
            return;
        }
        NSLog(@"Dictionary '%@'", dictionary);
        
        [self parseDictionary:dictionary];
        
        [self.tableView reloadData];
    }
}

- (void)parseDictionary:(NSDictionary *)dictionary {
    NSArray *array = dictionary[@"results"];
    if (array == nil) {
        NSLog(@"Expected 'results' array");
        return;
    }
    NSLog(@"%@", array);
    
    for (NSDictionary *resultDict in array) {
        SearchResult *searchResult = [[SearchResult alloc] init];
        searchResult.name = resultDict[@"name"];
        searchResult.description = resultDict[@"description"];
        [_searchResults addObject:searchResult];
    }
}
        

- (NSString *)performStoreRequestWithURL:(NSURL *)url {
    NSError *error;
    NSString *resultString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    if (resultString == nil) {
        NSLog(@"Download Error: %@", error);
        return nil;
    }
    return resultString;
}


- (NSURL *)urlWithSearchText:(NSString *)searchText {
    
    NSString *escapedSearchText = [searchText stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    NSString *urlString = [NSString stringWithFormat: @"http://personal.amorales.us/girls?q[name_cont]=%@", escapedSearchText];
    NSURL *url = [NSURL URLWithString:urlString];
    return url; }
        

- (NSDictionary *)parseJSON:(NSString *)jsonString {
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    id resultObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (resultObject == nil) {
        NSLog(@"JSON Error: %@", error);
        return nil;
    }
    
    if (![resultObject isKindOfClass:[NSDictionary class]]) {
        NSLog(@"JSON Error: Expected dictionary");
        return nil;
    }
    
    return resultObject;
}

- (void)showNetworkError {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Whoops..." message:@"There was an error reading from the iTunes Store. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}




- (UIBarPosition)positionForBar:(id <UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

@end
