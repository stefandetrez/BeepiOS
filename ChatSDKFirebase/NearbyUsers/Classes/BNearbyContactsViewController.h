//
//  BNearbyContactsViewController.h
//  Pods
//
//  Created by Simon Smiley-Andrews on 21/07/2015.
//
//

#import <UIKit/UIKit.h>
#import <ChatSDKCore/PNearbyUsersHandler.h>

@class BProfileTableViewController;

@interface BNearbyContactsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, PNearbyUsersDelegate> {

    UIActivityIndicatorView * _activityIndicator;
    
    NSMutableArray * _users;
    NSArray * _distanceBands;
    NSMutableArray * _usersByBand;
    
    BProfileTableViewController * _profileView;
    
    __weak id<PNearbyUsersHandler> _nearbyUsersManager;
    
    UIRefreshControl * refreshControl;
}

@property (nonatomic, weak) IBOutlet UITableView * tableView;

@end

