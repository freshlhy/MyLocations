//
//  MyTabBarController.m
//  MyLocations
//
//  Created by freshlhy on 14-3-26.
//  Copyright (c) 2014年 showgram. All rights reserved.
//

#import "MyTabBarController.h"

@interface MyTabBarController ()

@end

@implementation MyTabBarController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (UIViewController *)childViewControllerForStatusBarStyle {
    return nil;
}

@end
