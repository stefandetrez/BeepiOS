//
//  BLocationManager.h
//  Pods
//
//  Created by Simon Smiley-Andrews on 27/07/2015.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <ChatSDKCore/PUser.h>

@class RXPromise;

@protocol BLocationManagerDelegate <NSObject>

-(void) locationChanged: (CLLocation *) location;

@end

@interface BLocationManager : NSObject <CLLocationManagerDelegate> {
    
    CLLocationManager * locationManager;
    NSTimer * _locationTimer;
    
    BOOL _isUpdating;
    CLLocation * _lastLocation;
    
    RXPromise * _startPromise;
}

@property (nonatomic, readwrite, weak) id<BLocationManagerDelegate> delegate;

- (CLLocation *)getCurrentUserLocation;

- (RXPromise *)startUpdatingUserLocation;
- (void)stopUpdatingUserLocation;

@end
