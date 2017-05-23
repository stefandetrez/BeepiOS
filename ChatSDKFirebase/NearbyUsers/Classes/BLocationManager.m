//
//  BLocationManager.m
//  Pods
//
//  Created by Simon Smiley-Andrews on 27/07/2015.
//
//

#import "BLocationManager.h"
#import "GeoFire.h"
#import "Firebase+Paths.h"
#import "BNetworkManager.h"
#import "BGeoFireManager.h"
#import <RXPromise/RXPromise.h>

#define bLocationUpdateTime 5

#define bLocationKey @"location"

@implementation BLocationManager

- (RXPromise *)startUpdatingUserLocation {
    if (!_isUpdating) {
        _startPromise = [RXPromise new];
        [self updateUserLocation];
        
        _locationTimer = [NSTimer scheduledTimerWithTimeInterval:bLocationUpdateTime
                                                          target:self
                                                        selector:@selector(updateUserLocation)
                                                        userInfo:nil
                                                         repeats:YES];
        _isUpdating = YES;
    }
    if (_lastLocation) {
        RXPromise * promise = [RXPromise new];
        [promise resolveWithResult:Nil];
        return promise;
    }
    else {
        return _startPromise;
    }
}

- (void)stopUpdatingUserLocation {
    if (!_isUpdating) {
        return;
    }
    
    _isUpdating = NO;
    [_locationTimer invalidate];
    _locationTimer = nil;
}

- (void)updateUserLocation {
    if(!locationManager) {
        locationManager = [[CLLocationManager alloc] init];
        
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined &&
            [locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [locationManager requestWhenInUseAuthorization];
        }
        
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
    }
    
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    [locationManager stopUpdatingLocation];
    if(locationManager) {
        if (self.delegate) {
            [self.delegate locationChanged:locationManager.location];
        }
        if (locationManager.location) {
            _lastLocation = locationManager.location;
        }
        
        // Location manager must be set to nil after its location has been used else the location sent is nil
        locationManager = nil;
        
        if (_startPromise) {
            [_startPromise resolveWithResult:Nil];
            _startPromise = Nil;
        }
    }
}

- (CLLocation *)getCurrentUserLocation {
    return _lastLocation;
}

@end
