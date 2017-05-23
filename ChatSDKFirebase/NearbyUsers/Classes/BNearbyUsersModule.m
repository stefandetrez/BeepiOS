//
//  BContactBookModule.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 13/04/2017.
//
//

#import "BNearbyUsersModule.h"
#import <ChatSDKFirebase/BGeoFireManager.h>
#import <ChatSDKFirebase/BNearbyContactsViewController.h>

#import <ChatSDKCore/ChatCore.h>
#import <ChatSDKUI/ChatUI.h>


@implementation BNearbyUsersModule

-(void) activate {
    [BNetworkManager sharedManager].a.nearbyUsers = [[BGeoFireManager alloc] init];
    [[BInterfaceManager sharedManager].a addTabBarViewController: [[BNearbyContactsViewController alloc] init] atIndex: 2];
}

@end
