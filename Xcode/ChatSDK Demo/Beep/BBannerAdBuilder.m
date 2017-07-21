//
//  BBannerAdBuilder.m
//  ChatSDK Demo
//
//  Created by Benjamin Smiley-andrews on 06/07/2017.
//  Copyright © 2017 deluge. All rights reserved.
//

#import "BBannerAdBuilder.h"
#import "BAdID.h"
#import <ChatSDKUI/ChatUI.h>

@implementation BBannerAdBuilder

-(id) initWithViewController: (UIViewController *) controller {
    if((self = [self init])) {
        self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
        [controller.view addSubview: self.bannerView];
        self.bannerView.adUnitID = bAdId;
        self.bannerView.rootViewController = controller;
        [self.bannerView loadRequest:[GADRequest request]];
        
        int tabHeight = controller.tabBarController.tabBar.frame.size.height;
        
//        CGSize size = [UIScreen mainScreen].bounds.size;
        
//        self.bannerView.frame = CGRectMake(0, size.height - self.bannerView.frame.size.height - tabHeight, size.width, self.bannerView.frame.size.height);

//        CGRect rect = self.bannerView.frame;
//        rect.origin = CGPointMake(0, size.height + 100 - tabHeight);
//        rect.size.width = size.width;
//        
//        self.bannerView.frame = rect;
        
        self.bannerView.keepBottomInset.equal = tabHeight + keepRequired;
        self.bannerView.keepLeftInset.equal = 0 + keepRequired;
        self.bannerView.keepRightInset.equal = 0 + keepRequired;

        
        
//        UIView * redView = [[UIView alloc] initWithFrame:CGRectMake(0, size.height - 300, size.width, 100)];
//        redView.backgroundColor = [UIColor redColor];
//        [controller.view addSubview:redView];
        
        
        
        
    }
    return self;
}

+(id) bannerAddedToViewController: (UIViewController *) controller {
    return [[self alloc] initWithViewController: controller];
}

@end
