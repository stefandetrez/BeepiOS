//
//  BBeepTabBarController.m
//  ChatSDK Demo
//
//  Created by Simon Smiley-Andrews on 24/05/2017.
//  Copyright © 2017 deluge. All rights reserved.
//

#import "BBeepTabBarController.h"

@interface BBeepTabBarController()

@property(nonatomic, strong) GADInterstitial * interstitial;

@end

@implementation BBeepTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.interstitial = [self createAndLoadInterstitial];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    if (self.interstitial.isReady) {
        [self.interstitial presentFromRootViewController:self];
    } else {
        NSLog(@"Ad wasn't ready");
    }
}

- (GADInterstitial *)createAndLoadInterstitial {
    GADInterstitial * interstitial = [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-3940256099942544/4411468910"];
    interstitial.delegate = self;
    [interstitial loadRequest:[GADRequest request]];
    return interstitial;
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial {
    self.interstitial = [self createAndLoadInterstitial];
}

@end
