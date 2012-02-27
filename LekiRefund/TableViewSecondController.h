//
//  TableViewFirstController.h
//  Wyszukiwarka Leków Refundowanych
//
//  Created by Radek Jeruzal on 28.01.2012.
//  Copyright (c) 2012 DziMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewSecondController : UIViewController <UITableViewDelegate , UITableViewDataSource, UISearchBarDelegate, UITabBarDelegate>
{
    IBOutlet UITableView *tabelka;
    IBOutlet UINavigationBar *navBar;
    IBOutlet UISearchBar *searchBar;
    NSMutableArray *medicinesList, *results, *favList;
    IBOutlet UITableViewCell *theCell;
    UIImage *favYes;
    UIImage *favNo;
}

@property (nonatomic, retain) IBOutlet UINavigationBar *navBar;
@property (nonatomic, retain) IBOutlet UITableView *tabelka;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) NSMutableArray *medicinesList;
@property (nonatomic, retain) NSMutableArray *results;
@property (nonatomic, retain) NSMutableArray *favList;
@property (nonatomic, retain) IBOutlet UITableViewCell *theCell;
@property (nonatomic, retain) UIImage *favYes;
@property (nonatomic, retain) UIImage *favNo;

-(NSMutableArray *)performSearchingFor:(NSString *)object;

@end
