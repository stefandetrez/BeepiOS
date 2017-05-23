//
//  BGeoFireManager.h
//  Pods
//
//  Created by Simon Smiley-Andrews on 22/03/2016.
//
//

#import <Foundation/Foundation.h>

#import <ChatSDKCore/PNearbyUsersHandler.h>
#import <ChatSDKFirebase/BLocationManager.h>

@class BLocationManager;

@interface BGeoFireManager : NSObject<BLocationManagerDelegate, PNearbyUsersHandler> {
    BOOL _isOn;
}

@property (nonatomic, assign) id<PNearbyUsersDelegate>  delegate;
@property (nonatomic, strong, readwrite) BLocationManager * locationManager;

@end

