//
//  DetailViewController.m
//  Wyszukiwarka Leków Refundowanych
//
//  Created by Radek Jeruzal on 29.01.2012.
//  Copyright (c) 2012 DziMac. All rights reserved.
//

#import "DetailViewController.h"

@implementation DetailViewController

@synthesize medicine, replacements, navBar, tView, activeSubstance, mainName, favButton, tableViewD, delegate, showButton, bannerView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:16.0];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor]; // change this color
    self.navigationItem.titleView = label;
    label.text = NSLocalizedString(@"Szczegóły leku", @"Szczegóły leku");
    [label sizeToFit];            
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail-bg-2.png"]];
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;

    if (UIInterfaceOrientationIsLandscape(orientation))
        self.bannerView.currentContentSizeIdentifier =
        ADBannerContentSizeIdentifierLandscape;
    else
        self.bannerView.currentContentSizeIdentifier =
        ADBannerContentSizeIdentifierPortrait;

    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {

    
}
- (void)viewDidLoad
{
        
    bannerView.requiredContentSizeIdentifiers = [NSSet setWithObjects: ADBannerContentSizeIdentifierPortrait, ADBannerContentSizeIdentifierLandscape, nil];
    //NSString *mText = [[NSString alloc] initWithFormat: @" najpierw %@, a potem %@", medicine, replacements];
    //tView.text = mText;
    /*
    mainName.text = [medicine objectAtIndex:3];
    mainName.numberOfLines = 0;
    mainName.frame = CGRectMake(mainName.frame.origin.x, mainName.frame.origin.y, [[UIScreen mainScreen] bounds].size.width-30, 20);
    [mainName sizeToFit];
    activeSubstance.text = [medicine objectAtIndex:2];
    activeSubstance.numberOfLines = 0;
    [activeSubstance sizeToFit];
    */
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


- (void)viewDidUnload
{
    self.view = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
        self.bannerView.currentContentSizeIdentifier =
        ADBannerContentSizeIdentifierLandscape;
    else
        self.bannerView.currentContentSizeIdentifier =
        ADBannerContentSizeIdentifierPortrait;
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    self.bannerView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{

    
    if(interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown) {
        return NO;
    } else {
        return YES;
    }

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if([replacements count]==1) {
        return @"Dane leku";
    } else {
        return [[NSString alloc]  initWithFormat:@"Dane leku numer %d",section+1];
    }

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return replacements.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return 5;
}


// @todo dodaj przycisk, polacz go z favButton i obsluz dodawanie do ulubionych
- (void)adjustFavButton {
    favButton.titleLabel.text = @"Dodaj do ulubionych";
    CGRect      buttonFrame = favButton.frame;
    buttonFrame.size = CGSizeMake(220, 44);
    buttonFrame.origin = CGPointMake((self.view.bounds.size.width-220)/2, buttonFrame.origin.y);
    favButton.frame = buttonFrame;
    favButton.imageView.image = [UIImage imageNamed:@"favorites-yes.png"];
    [favButton addTarget:self action:@selector(aMethod:) forControlEvents:UIControlEventTouchUpInside];
    //favButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;

}
-(void)medButtonPressed:(UIButton *)sender {
    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:[medicine objectAtIndex:2], nil] forKeys:[[NSArray alloc] initWithObjects:@"searchStringKey", nil]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"searchString" object:nil userInfo:dict];
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [[NSString alloc] initWithFormat:@"cellname%d",indexPath.row];
    UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell== nil||indexPath.row==1) {
        cell = [[UITableViewCell  alloc]  initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    NSString *textToDisplay = [[NSString alloc] init];
    NSString *subtitleToDisplay = [[NSString alloc] init];

    NSArray *currentObject = [replacements objectAtIndex:indexPath.section];

    if(indexPath.row == 0) { // name
        textToDisplay = [currentObject objectAtIndex:3];
        subtitleToDisplay = @"nazwa leku";
    } else if (indexPath.row == 1) { // active substance
        textToDisplay = [currentObject objectAtIndex:2];
        subtitleToDisplay = @"substancja czynna";
        UIDevice *device = [UIDevice alloc];
        int myMove = 140;
        if ([device.model rangeOfString:@"iPhone"].location == NSNotFound) {
            myMove = 240;
        } 
        if(showButton) {
            UIButton *medButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [medButton setTitle:@"zamienniki" forState:UIControlStateNormal];
            [medButton setFrame:CGRectMake(self.view.bounds.size.width-myMove, 15, 100, 22)];
            [medButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [medButton setFont:[UIFont systemFontOfSize:14]];
            [medButton addTarget:self action:@selector(medButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:medButton];
        }
    } else if (indexPath.row == 2) { 
        textToDisplay = [currentObject objectAtIndex:4];
        subtitleToDisplay = @"zawartość opakowania";
    } else if (indexPath.row == 3) { // description
        textToDisplay = [currentObject objectAtIndex:12];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:13];
        //cell.frame.size =  CGSizeMake(50, 50);//CGR(cell.frame.width, 60);
        [cell sizeToFit];
        subtitleToDisplay = @"wskazania";
    } else if (indexPath.row == 4) {
        textToDisplay = [[NSString alloc] initWithFormat:@"%@ PLN (%@)",[currentObject objectAtIndex:14], [currentObject objectAtIndex:13]];
        subtitleToDisplay = @"cena dla pacjenta";
        //[self adjustFavButton];
    }
    
    /*
    if(indexPath.section == 0) {
        textToDisplay = [medicine objectAtIndex:3];
    } else if (indexPath.section == 1) {
        textToDisplay = [medicine objectAtIndex:2];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (indexPath.section == 2) {
        textToDisplay = [medicine objectAtIndex:4];
    } else if (indexPath.section == 3) {
        textToDisplay = [medicine objectAtIndex:8];
    } else if (indexPath.section == 4) {
        textToDisplay = [[NSString alloc] initWithFormat:@"%@ PLN",[medicine objectAtIndex:10]];
    } else if (indexPath.section == 5) {
        textToDisplay = [medicine objectAtIndex:12];
    } else if (indexPath.section == 6) {
        textToDisplay = [medicine objectAtIndex:13];
    } else if (indexPath.section == 7) {
        textToDisplay = [[NSString alloc] initWithFormat:@"%@ PLN",[medicine objectAtIndex:14]];
    }
    */
    cell.textLabel.text = textToDisplay;
    cell.detailTextLabel.text = subtitleToDisplay;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.numberOfLines = 0;
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    return 65;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [tableViewD reloadData];
}

- (void)dealloc {
    bannerView.delegate=nil;
}

@end
