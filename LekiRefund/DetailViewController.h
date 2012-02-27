//
//  DetailViewController.h
//  Wyszukiwarka Leków Refundowanych
//
//  Created by Radek Jeruzal on 29.01.2012.
//  Copyright (c) 2012 DziMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface DetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ADBannerViewDelegate> {
    NSMutableArray *medicine, *replacements;
    UINavigationBar *navBar;
    IBOutlet UITextView *tView;
    IBOutlet UILabel *activeSubstance;
    IBOutlet UILabel *mainName;
    IBOutlet UIButton *favButton;
    IBOutlet UITableView *tableViewD;
    UIViewController *delegate;
    BOOL *showButton;
    IBOutlet ADBannerView *bannerView;
}

@property (nonatomic, retain) NSMutableArray *medicine;
@property (nonatomic, retain) NSMutableArray *replacements;
@property (nonatomic, retain) UINavigationBar *navBar;
@property (nonatomic, retain) IBOutlet UITextView *tView;
@property (nonatomic, retain) IBOutlet UILabel *activeSubstance;
@property (nonatomic, retain) IBOutlet UILabel *mainName;
@property (nonatomic, retain) IBOutlet UIButton *favButton;
@property (nonatomic, retain) IBOutlet UITableView *tableViewD;
@property (nonatomic, retain) UIViewController *delegate;
@property (nonatomic) BOOL *showButton;
@property (nonatomic, strong) IBOutlet ADBannerView *bannerView;

@end
