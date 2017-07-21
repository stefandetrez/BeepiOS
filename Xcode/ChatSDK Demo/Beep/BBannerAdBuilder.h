//
//  BBannerAdBuilder.h
//  ChatSDK Demo
//
//  Created by Benjamin Smiley-andrews on 06/07/2017.
//  Copyright © 2017 deluge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@import GoogleMobileAds;

@interface BBannerAdBuilder : NSObject

@property (nonatomic, strong) GADBannerView * bannerView;

+(id) bannerAddedToViewController: (UIViewController *) controller;

@end
