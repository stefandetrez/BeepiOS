//
//  BGeoFireManager.m
//  Pods
//
//  Created by Simon Smiley-Andrews on 22/03/2016.
//
//

#import "BGeoFireManager.h"

#import <ChatSDKCore/ChatCore.h>
#import <ChatSDKFirebaseAdapter/ChatFirebaseAdapter.h>
//#import <GeoFire/GeoFire.h>
#import <ChatSDKFirebase/GeoFire.h>

#define bSearchRadius 10

@implementation BGeoFireManager

static BGeoFireManager * manager;

@synthesize delegate;
@synthesize locationManager;

+(BGeoFireManager *) sharedManager {
    
    @synchronized(self) {        
        // If the sharedSoundManager var is nil then we need to allocate it.
        if(manager == nil) {
            // Allocate and initialize an instance of this class
            manager = [[self alloc] init];
        }
    }
    return manager;
}

-(id) init {
    if ((self = [super init])) {
        locationManager = [[BLocationManager alloc] init];
        locationManager.delegate = self;
    }
    return self;
}

- (void) findNearbyUsersWithRadius: (double) radiusInMetres {
    
    GeoFire * geoFire = [BGeoFireManager geoFireRef];
    
    // Query locations at [37.7832889, -122.4056973] with a radius of 10,000 meters
    CLLocation * center = self.locationManager.getCurrentUserLocation;
    
    // Set the search radius value to determine the search area
    GFCircleQuery * circleQuery = [geoFire queryAtLocation:center withRadius:radiusInMetres/1000.0];
    
    id<PUser> currentUser = [BNetworkManager sharedManager].a.core.currentUserModel;
    
    [circleQuery observeEventType:GFEventTypeKeyEntered withBlock:^(NSString * entityID, CLLocation *location) {
        if (![entityID isEqualToString:currentUser.entityID]) {
            [[CCUserWrapper userWithEntityID:entityID] once].thenOnMain(^id(CCUserWrapper * userWrapper) {
                if (delegate && [delegate respondsToSelector:@selector(userAdded:location:)]) {
                    [delegate userAdded: userWrapper.model location: location];
                }
                return Nil;
            }, Nil);
        }
    }];
    
    [circleQuery observeEventType:GFEventTypeKeyExited withBlock:^(NSString * entityID, CLLocation *location) {
        if (![entityID isEqualToString:currentUser.entityID]) {
            CCUserWrapper * userWrapper = [CCUserWrapper userWithEntityID:entityID];
            [delegate userRemoved:userWrapper.model];
        }
    }];
    
    [circleQuery observeEventType:GFEventTypeKeyMoved withBlock:^(NSString * entityID, CLLocation *location) {
        if (![entityID isEqualToString:currentUser.entityID]) {
            CCUserWrapper * userWrapper = [CCUserWrapper userWithEntityID:entityID];
            [delegate userMoved:userWrapper.model location:location];
        }
    }];
}

-(RXPromise *) startUpdatingUserLocation {
    return [locationManager startUpdatingUserLocation];
}

- (void) stopUpdatingUserLocation {
    [locationManager stopUpdatingUserLocation];
}

- (CLLocation *) getCurrentLocation {
    return [locationManager getCurrentUserLocation];
}

-(void) updateCurrentUserLocation: (CLLocation *)location {
    id<PUser> currentUser = [BNetworkManager sharedManager].a.core.currentUserModel;
    if (currentUser) {
        GeoFire * geoFire = [BGeoFireManager geoFireRef];
        [geoFire setLocation:location forKey:currentUser.entityID];
    }
}

-(void) locationChanged: (CLLocation *) location {
    [self updateCurrentUserLocation:location];
}

+(GeoFire *) geoFireRef {
    FIRDatabaseReference * firebase = [[FIRDatabaseReference firebaseRef] childByAppendingPath:bLocationPath];
    return [[GeoFire alloc] initWithFirebaseRef:firebase];
}


@end
