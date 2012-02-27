//
//  SecondViewController.m
//  Wyszukiwarka Leków Refundowanych
//
//  Created by Radek Jeruzal on 27.01.2012.
//  Copyright (c) 2012 DziMac. All rights reserved.
//

#import "SecondViewController.h"
#import "TableViewSecondController.h"

@implementation SecondViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    TableViewSecondController *SecondController = 
    [[TableViewSecondController alloc] initWithNibName:@"Tabelka" bundle:nil];
    
    [self pushViewController:SecondController animated:NO];
    
    if (self) {
        self.title = @"Ulubione"; 
        self.tabBarItem.image = [UIImage imageNamed:@"favorites"];
        
    }
    return self;
}
							
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    //NSLog(@"wczytalem second");
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
