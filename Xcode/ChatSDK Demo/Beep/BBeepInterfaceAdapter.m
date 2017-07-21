//
//  BBeepInterfaceAdapter.m
//  ChatSDK Demo
//
//  Created by Benjamin Smiley-andrews on 06/07/2017.
//  Copyright © 2017 deluge. All rights reserved.
//

#import "BBeepInterfaceAdapter.h"
#import "BBeepPrivateThreadsViewController.h"
#import "BBeepPublicThreadsViewController.h"
#import "BBeepContactsViewController.h"
#import <ChatSDKUI/BProfileTableViewController.h>
#import "BBannerAdBuilder.h"

@implementation BBeepInterfaceAdapter

-(UIViewController *) privateThreadsViewController {
    if (!_privateThreadsViewController) {
        _privateThreadsViewController = [[BBeepPrivateThreadsViewController alloc] init];
    }
    return _privateThreadsViewController;
}

-(UIViewController *) publicThreadsViewController {
    return [[BBeepPublicThreadsViewController alloc] init];
}

-(UIViewController *) contactsViewController {
    return [[BBeepContactsViewController alloc] init];
}

-(UIViewController *) profileViewControllerWithUser: (id<PUser>) user {
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Profile"
                                                          bundle:[NSBundle chatUIBundle]];
    
    BProfileTableViewController * controller = [storyboard instantiateInitialViewController];
    __weak BProfileTableViewController * weakController = controller;
    controller.onLoad = ^{
        [BBannerAdBuilder bannerAddedToViewController:weakController];
    };
    controller.user = user;
    return controller;
}



@end
