//
//  BNearbyContactsViewController.m
//  Pods
//
//  Created by Simon Smiley-Andrews on 21/07/2015.
//
//

#import "BNearbyContactsViewController.h"

#import <ChatSDKCore/ChatCore.h>
#import <ChatSDKUI/ChatUI.h>

#define bCellIdentifier @"bCellIdentifier"

#define bUserKey @"user"
#define bLocationKey @"location"

#define bUserLocationKey @"bUserLocationKey"

@interface BNearbyContactsViewController ()

@end

@implementation BNearbyContactsViewController

@synthesize tableView;

- (id)init
{
    NSBundle * geoFireBundle = [self bundle];
    self = [self initWithNibName:@"BNearbyContactsViewController" bundle:geoFireBundle];
    if (self) {
    }
    return self;
}

-(NSBundle *) bundle {
    return [NSBundle bundleWithFramework:@"ChatSDKFirebase" name:@"ChatNearbyUsers"];;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.title = [NSBundle t:bNearbyContacts];
        self.tabBarItem.image = [NSBundle imageNamed:@"icn_30_glass.png" framework:@"ChatSDKFirebase" bundle:@"ChatNearbyUsers"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Listen to see if the user logs out
    [[NSNotificationCenter defaultCenter] addObserverForName:bNotificationLogout object:Nil queue:Nil usingBlock:^(NSNotification * sender) {
        
        // When a user logs out we want to clear the nearby users array for a new user to log in
        [_users removeAllObjects];
        [_usersByBand removeAllObjects];
        
        [tableView reloadData];
    }];
    
    // Change the colour of the navigation bar buttons
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];

    // Set the bands that we will show users within
    _distanceBands = @[@1000, @5000, @10000, @50000];

    _users = [NSMutableArray new];
    _usersByBand = [NSMutableArray new];
    
    
    
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = tableView;
    
    // Initialize the refresh control.
    refreshControl = [[UIRefreshControl alloc] init];
    //refreshControl.backgroundColor = [UIColor purpleColor];
    refreshControl.tintColor = [UIColor lightGrayColor];
    
    NSDictionary * attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor lightGrayColor] forKey:NSForegroundColorAttributeName];
    NSAttributedString * attributedTitle = [[NSAttributedString alloc] initWithString:[NSBundle t:bRefreshingUsers] attributes:attrsDictionary];
    refreshControl.attributedTitle = attributedTitle;
    
    [refreshControl addTarget:self action:@selector(refreshResults) forControlEvents:UIControlEventValueChanged];
    
    tableViewController.refreshControl = refreshControl;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Store a weak reference locally for convenience
    _nearbyUsersManager = [BNetworkManager sharedManager].a.nearbyUsers;
    [_nearbyUsersManager setDelegate: self];
    
    // Start updating the user location once we load the nearby user view
    [_nearbyUsersManager startUpdatingUserLocation].thenOnMain(^id(id success) {
        // Search for nearby users
        [_nearbyUsersManager findNearbyUsersWithRadius:[_distanceBands.lastObject doubleValue]];
        return Nil;
    }, Nil);
    
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        
        UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:_activityIndicator];
        self.navigationItem.rightBarButtonItem = barButton;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_users.count) {
        return [_usersByBand[section] count];
    }
    else {
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // If we have users, we display the users... otherwise we just display the
    // searching indicator
    return _users.count ? _usersByBand.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView_ dequeueReusableCellWithIdentifier:bCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:bCellIdentifier];
        cell.imageView.layer.cornerRadius = cell.frame.size.height / 2;
        cell.imageView.clipsToBounds = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (_users.count) {
        id<PUser> user = _usersByBand[indexPath.section][indexPath.row];
        
        cell.textLabel.text = user.name;

        if (user.thumbnail) {
            cell.imageView.image = [UIImage imageWithData:user.thumbnail];
        }
        else {
            cell.imageView.image = [NSBundle chatUIImageNamed:@"icn_100_anonymous.png"];
        }
        
        cell.textLabel.textColor = [UIColor blackColor];
        cell.accessoryView = NULL;
    }
    else {
        
        cell.textLabel.text = [NSBundle t:bSearching];
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.imageView.image = nil;
        
        UIActivityIndicatorView * activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activityView startAnimating];
        [cell setAccessoryView:activityView];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView_ didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_users.count) {
        
        id<PUser> user = _usersByBand[indexPath.section][indexPath.row];
        
        // Open the users profile
        if (!_profileView) {
            _profileView = [[BInterfaceManager sharedManager].a profileViewControllerWithUser:user];
        }
        [self.navigationController pushViewController:_profileView animated:YES];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString * title = @"";
    
    if (_users.count) {
        if (section == 0) {
            title = [NSString stringWithFormat:@"Less than %i km", [_distanceBands[section] intValue]/1000];
        }
        else {
            title = [NSString stringWithFormat:@"%i - %ikm", [_distanceBands[section - 1] intValue]/1000, [_distanceBands[section] intValue]/1000];
        }
        // If there are no users dont make a title
        if ([_usersByBand[section] count] == 0) {
            title = Nil;
        }
    }
    return title;
}

- (void)refreshResults {
    
    // Start updating the user location once we load the nearby user view
    [_nearbyUsersManager startUpdatingUserLocation].thenOnMain(^id(id success) {
        // Search for nearby users
        [_nearbyUsersManager findNearbyUsersWithRadius:[_distanceBands.lastObject doubleValue]];
        
        return Nil;
    }, Nil);
    
    [refreshControl performSelector:@selector(endRefreshing) withObject:nil afterDelay:2.0];
}

- (void)userAdded: (id<PUser>)user location: (CLLocation *)location {
    
    // Don't return the current user in the results - we only need to add this to the user added function
    if (user && ![user.entityID isEqualToString:[BNetworkManager sharedManager].a.core.currentUserModel.entityID]) {
        // Associate the location with the user
        [((NSObject *)user) setAssociatedObject:location key:bUserLocationKey];
        
        if (![_users containsObject:user]) {
            [_users addObject:user];
        }
        
        [self refreshUserDistances];
    }
}

- (void)userRemoved: (id<PUser>)user {
    if ([_users containsObject:user]) {
        [_users removeObject:user];
    }
    [self refreshUserDistances];
}

- (void)userMoved: (id<PUser>)user location: (CLLocation *)location {
    [((NSObject *)user) setAssociatedObject:location key:bUserLocationKey];
    if (![_users containsObject:user]) {
        [_users addObject:user];
    }
    [self refreshUserDistances];
}

- (void)refreshUserDistances {
    
    CLLocation * currentLocation = [_nearbyUsersManager getCurrentLocation];
    if (!currentLocation) {
        return;
    }
    
    // Sort the users by distance
    [_users sortUsingComparator:^NSComparisonResult(NSObject * u1, NSObject * u2) {
        // Locations
        CLLocation * l1 = [u1 associatedObjectWithKey:bUserLocationKey];
        CLLocation * l2 = [u2 associatedObjectWithKey:bUserLocationKey];
        // Distances
        CLLocationDistance d1 = [currentLocation distanceFromLocation:l1];
        CLLocationDistance d2 = [currentLocation distanceFromLocation:l2];
        
        // TODO: Check this
        return d1 - d2;
    }];
    
    [_usersByBand removeAllObjects];
    
    // Now add the users by band
    double lastBand = 0;
    
    NSMutableArray * allocatedUsers = [NSMutableArray new];
    
    for (NSNumber * band in _distanceBands) {
        
        NSMutableArray * inBand = [NSMutableArray new];
        
        for (NSObject * user in _users) {
            
            if (![allocatedUsers containsObject:user]) {
            
                // Only need to calculate this if the user has not been already added
                CLLocation * l = [user associatedObjectWithKey:bUserLocationKey];
                CLLocationDistance d = [currentLocation distanceFromLocation:l];
                
                if (d >= lastBand && d < [band doubleValue]) {
                    [inBand addObject:user];
                    [allocatedUsers addObject:user];
                    
                    if (![_usersByBand containsObject:inBand]) {
                        [_usersByBand addObject:inBand];
                    }
                    // If this was the last object we also move on...
                    if ([user isEqual:_users.lastObject]) {
                        lastBand = band.doubleValue;
                        break;
                    }
                }
                else {
                    lastBand = band.doubleValue;
                    break;
                }
            }
        }
        
        // If the array is empty then we want to add it - we need the empty arrays to ensure the header titles are correct
        if (!inBand.count) {
            [_usersByBand addObject:inBand];
        }
    }
    
    [tableView reloadData];
}

- (int) userCountForSection: (NSInteger)section {
    return (int) [_usersByBand[section] count];
}

@end
