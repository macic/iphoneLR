//
//  TableViewFirstController.m
//  Wyszukiwarka Leków Refundowanych
//
//  Created by Radek Jeruzal on 28.01.2012.
//  Copyright (c) 2012 DziMac. All rights reserved.
//

#import "TableViewFirstController.h"
#import "DetailViewController.h"
#import "/usr/include/sqlite3.h"

@implementation TableViewFirstController

@synthesize tabelka, navBar, searchBar, medicinesList, results, theCell, favList, favNo, favYes;

// connecting to db and fetching initial data
- (NSMutableArray *)getDbData {
    NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"database" ofType:@"db"];
    sqlite3 *database;

    NSMutableArray *medicinesArray = [[NSMutableArray alloc] init];
    
	if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {

        if (sqlite3_exec(database, "PRAGMA CACHE_SIZE=50;", NULL, NULL, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to set cache size with message '%s'.", sqlite3_errmsg(database));
        }
        
        sqlite3_stmt  *statement;
        
        NSString *querySQL = @"select *, group_concat(price_surcharge, ' lub ') from medicines  group by trim(name) order by trim(name)";        
        const char *query_stmt = [querySQL UTF8String];
        sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL);
        NSUInteger i = 0;
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            NSMutableArray *tempOb = [[NSMutableArray alloc] initWithCapacity:17];
            for (NSUInteger j = 0; j<17; j++) {  
                
                char *localityChars = sqlite3_column_text(statement, j);
                if (localityChars == NULL) {
                    NSString *temp = @"";
                    [tempOb insertObject:temp atIndex:j];
                }
                else {
                    NSString *temp = [NSString stringWithUTF8String: (const char *) localityChars];
                    [tempOb insertObject:temp atIndex:j];
                }
            }
            [medicinesArray insertObject:tempOb atIndex:i];
            i=i+1;
            
        }
        sqlite3_finalize(statement);
        statement = nil;
        sqlite3_close(database);
    }       
    dbPath = nil;
    database = nil;
    return medicinesArray;
}

- (NSMutableArray *)getReplacementsFor:(NSMutableArray *)object {
    
    NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"database" ofType:@"db"];
    sqlite3 *database;
    
    NSMutableArray *replacementsArray = [[NSMutableArray alloc] init];
    
	if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        sqlite3_stmt  *statement;
        if (sqlite3_exec(database, "PRAGMA CACHE_SIZE=50;", NULL, NULL, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to set cache size with message '%s'.", sqlite3_errmsg(database));
        }

        
        NSString *querySQL = [[NSString alloc] initWithFormat:@"select * from medicines where name='%@'", [object objectAtIndex:3]];
        const char *query_stmt = [querySQL UTF8String];
        sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL);
        NSUInteger i = 0;
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            NSMutableArray *tempOb = [[NSMutableArray alloc] initWithCapacity:16];
            for (NSUInteger j = 0; j<16; j++) {  
                char *localityChars = sqlite3_column_text(statement, j);
                if (localityChars == NULL) {
                    NSString *temp = @"";
                    [tempOb insertObject:temp atIndex:j];
                }
                else {
                    NSString *temp = [NSString stringWithUTF8String: (const char *) localityChars];
                    [tempOb insertObject:temp atIndex:j];
                }
            }
            [replacementsArray insertObject:tempOb atIndex:i];
            i=i+1;
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }        
    return replacementsArray;
}

// search bar handler
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
   
    NSMutableArray *wyniki = [[NSMutableArray alloc] init ];
    if([searchText length] == 0) {
        results = medicinesList;
        [self.searchBar resignFirstResponder];
    } else {
        for (NSArray *sObiekt in medicinesList)
        {
            NSString *sTemp = [sObiekt objectAtIndex:2];
            NSRange nazwaRange = [sTemp rangeOfString:searchText options:NSCaseInsensitiveSearch];
        
            if (nazwaRange.length > 0) {
                [wyniki addObject:sObiekt];

                
            } else {
            // w innym przypadku sprawdz czynna
                NSString *sTemp = [sObiekt objectAtIndex:3];
                NSRange czynnaRange = [sTemp rangeOfString:searchText options:NSCaseInsensitiveSearch];
                
                if (czynnaRange.length > 0) {
               
                    [wyniki addObject:sObiekt];

                } else {
                    // w jeszcze innym przypadku sprawdz wskazanie
                    NSString *sTemp = [NSString stringWithFormat:@"%@%@", [sObiekt objectAtIndex:12],[sObiekt objectAtIndex:15]];
                    NSRange wskazanieRange = [sTemp rangeOfString:searchText options:NSCaseInsensitiveSearch];
                    
                    if (wskazanieRange.length > 0) {
                        
                        [wyniki addObject:sObiekt];
                        
                    } 
                }
            }
        
        }
    results = wyniki;
    }
    wyniki = nil;
    [tabelka reloadData];
}

// returns the path to save favlist.plist
-(NSString *)saveStateFilePath {
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"favlist.plist"];
}

// loading favorites list, if empty file then create it based on favlist.plist
-(NSMutableArray *)loadFavList {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL success = [fileManager fileExistsAtPath:[self saveStateFilePath]];
    
    if(success) {
        NSMutableArray *myList = [NSMutableArray arrayWithContentsOfFile:[self saveStateFilePath]];
        return myList;
    } else {
        NSString *defaultEmptyFile = [[NSBundle mainBundle] pathForResource:@"favlist" ofType:@"plist"];
        [fileManager copyItemAtPath:defaultEmptyFile toPath:[self saveStateFilePath] error:nil];
        NSMutableArray *myList = [NSMutableArray arrayWithContentsOfFile:[self saveStateFilePath]];
        return myList;
    }
}

// managing favlist.plist and saving objects to file
- (void)addFavList:(NSObject *)object {
    BOOL duplicates = [favList containsObject:object];

    if (duplicates) {
        [favList removeObject:object];
    } else {
        [favList addObject: object];
    }
    [favList writeToFile:[self saveStateFilePath] atomically:YES];
}

// handling the button pressed event for favorites image
-(void)buttonPressed:(UIButton *)sender {
    UITableViewCell *cell = (UITableViewCell *)sender.superview.superview;
   
    NSIndexPath *indexPath = [tabelka indexPathForCell:cell];
    NSArray *idOb = [results objectAtIndex:indexPath.row];
    NSMutableArray *ob = [[NSMutableArray alloc] initWithObjects:[idOb objectAtIndex:0], nil] ;

    [self addFavList:ob];
    [tabelka reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];

}


- (NSMutableArray *)compareFullList:(NSMutableArray *)firstList withFaves:(NSMutableArray *)secondList {
    NSMutableArray *finalResults = [[NSMutableArray alloc] init];
    NSUInteger i = 0;
    
    NSEnumerator *enumFirstList = [firstList objectEnumerator];
    id elementFirstList;
    
    while(elementFirstList = [enumFirstList nextObject])
    {
        NSMutableArray *ob = [[NSMutableArray alloc] initWithObjects:[elementFirstList objectAtIndex:0], nil] ;
        BOOL foundIt = [secondList containsObject:ob];
        if(foundIt) {
            [finalResults insertObject: elementFirstList atIndex:i];
            i=i+1;
        }
    }
    return finalResults;
}


// hiding the keyboard when scrolling begins
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] 
        addObserver:self
        selector:@selector(receivedNotification:) 
        name:@"searchString" object:nil];
    
    favList = [self loadFavList];
    medicinesList = [self getDbData];
    results = medicinesList;
    favYes = [UIImage imageNamed:@"favorites-yes.png"];
    favNo = [UIImage imageNamed:@"favorites-no.png"];
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)receivedNotification:(NSNotification *)notification
{

    
    NSString *newString = [[notification userInfo]
                           objectForKey:@"searchStringKey"];   
    //NSLog (@"Successfully received the test notification! %@", fieldEditor);
    searchBar.text=newString;
    [self searchBar:searchBar textDidChange:newString];

}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    favList = [self loadFavList];
    [tabelka reloadData];
    navBar = self.navigationController.navigationBar;
    navBar.hidden = YES;
    navBar.barStyle = UIBarStyleBlackOpaque;
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [tabelka addGestureRecognizer:gestureRecognizer];
    
    [super viewWillAppear:animated];
}

- (void)hideKeyboard 
{
    [searchBar resignFirstResponder];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if(interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [results count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cellname";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:CellIdentifier];
    }
    
    UIButton *favButton = [UIButton buttonWithType:UIButtonTypeCustom];
   
    [favButton setFrame:CGRectMake(5, 5, 32, 32)];
    [favButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    NSArray *mOb = [results objectAtIndex:indexPath.row];
    NSMutableArray *cOb = [[NSMutableArray alloc] initWithObjects:[mOb objectAtIndex:0], nil];
    
    if([favList containsObject:cOb]) {
        [favButton setBackgroundImage:favYes 
                             forState:UIControlStateNormal];

        [favButton setBackgroundImage:favYes 
                             forState:UIControlStateSelected];

    } else {
        [favButton setBackgroundImage:favNo
                             forState:UIControlStateNormal];
        
        [favButton setBackgroundImage:favNo
                             forState:UIControlStateSelected];
    }
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    [cell.contentView addSubview:favButton];
    
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.text = [mOb objectAtIndex:3];
    
    cell.detailTextLabel.font = [UIFont systemFontOfSize:11];
    cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%@ (cena: %@ PLN)", [mOb objectAtIndex:2], [mOb objectAtIndex:16]];
    cell.indentationLevel = 1;
    cell.indentationWidth = 36;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    //UIView *selectedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
    //UIImage *selectedBg = [UIImage imageNamed:@"selected-bg-2.png"];
    //UIImageView* blockView = [[UIImageView alloc] initWithImage:selectedBg];
    //selectedView.backgroundColor=[UIColor magentaColor];
//[selectedView addSubview:blockView];
    
    //cell.selectedBackgroundView.backgroundColor = [UIColor redColor];// .contentView.backgroundColor
    //cell.selectedBackgroundView = selectedView;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    favButton.highlighted = NO;
   
    return cell;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)mainSearchBar;      
{
    [searchBar resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *controller = 
    [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    controller.showButton = YES;
    controller.medicine = [results objectAtIndex:indexPath.row];
    controller.replacements = [self getReplacementsFor:[results objectAtIndex:indexPath.row]];
    controller.navBar = navBar;
    navBar.hidden = NO;
    [[self navigationItem] setBackBarButtonItem:
                           [[UIBarButtonItem alloc] initWithTitle:@"Wróć"
                                    style: UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil]];
    [self.navigationController pushViewController:controller animated:YES];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


@end
