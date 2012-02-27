//
//  AppDelegate.h
//  Wyszukiwarka Leków Refundowanych
//
//  Created by Radek Jeruzal on 27.01.2012.
//  Copyright (c) 2012 DziMac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NavFirstController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate> {
    
    IBOutlet UINavigationController *navFirstController;
    
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;

@property (strong, nonatomic) IBOutlet UINavigationController *navFirstController;

@end
