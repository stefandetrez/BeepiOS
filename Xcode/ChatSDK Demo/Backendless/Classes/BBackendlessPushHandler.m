//
//  BBackendlessPushHandler.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#import "BBackendlessPushHandler.h"
#import <Backendless.h>
#import "BBackendless.h"

@implementation BBackendlessPushHandler

-(id) initWithAppKey: (NSString *) appKey secretKey: (NSString *) secretKey versionKey:(NSString *) versionKey {
    if ((self = [self init])) {
        [BBackendless sharedManagerWithAppKey:appKey
                                    secretKey:secretKey
                                   versionKey:versionKey];
    }
    return self;
}

-(void) registerForPushNotificationsWithApplication: (UIApplication *) app launchOptions: (NSDictionary *) options {
    
    // Moving this from the main thread stops the app sometimes hanging when registering
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [backendless.messagingService registerForRemoteNotifications];
    });
}



- (void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    // Register the device with a token string
    NSString * deviceTokenString = [backendless.messagingService deviceTokenAsString:deviceToken];
    
    @try {
        NSString * deviceRegistrationId = [backendless.messagingService registerDeviceToken:deviceTokenString];
        NSLog(@"device token: %@, device registration id: %@", deviceTokenString, deviceRegistrationId);
    }
    @catch (Fault * fault) {
        NSLog(@"device token: %@, FAULT = %@ <%@>", deviceTokenString, fault.message, fault.detail);
    }
}

- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    if (application.applicationState != UIApplicationStateActive) {
        // TODO: Do we need to show the notficaiton?
    }
}

-(void) subscribeToPushChannel: (NSString *) channel {
    if (!_isSubscribed) {
        channel = [self safeChannel:channel];
        [backendless.messagingService registerDevice:@[channel]];
        _isSubscribed = YES;
    }
}
-(void) unsubscribeToPushChannel: (NSString *) channel {
    if (_isSubscribed) {
        channel = [self safeChannel:channel];
        //[backendless.messagingService unregisterDevice:channel];
        _isSubscribed = NO;
    }
}

-(void) pushToChannels: (NSArray *) channels withData:(NSDictionary *) data {
    DeliveryOptions * deliveryOptions = [DeliveryOptions new];
    [deliveryOptions pushBroadcast:FOR_IOS];
    [deliveryOptions pushPolicy:PUSH_ONLY];
    
    PublishOptions * publishOptions = [PublishOptions new];
    
    //    NSMutableDictionary * mutDict = [NSMutableDictionary new];
    //    [mutDict setValue:@"ios-ticker-text" forKey:@"You just got a push"];
    //    [mutDict setValue:@"ios-content-title" forKey:@"Notification title"];
    //    [mutDict setValue:@"ios-content-text" forKey:@"Notification text"];
    //
    //    // This will make the default sound or vibrate the phone
    //    [mutDict setValue:@"ios-sound" forKey:@"default"];
    
    
    [publishOptions assignHeaders:data];
    
    // This seems to block sometimes...
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        for (NSString * channel in channels) {
            @try {
                [backendless.messagingService publish:channel message:data publishOptions: publishOptions];
            } @catch (NSException *exception) {
                NSLog(@"%@", exception);
            } @finally {
            }
        }
    });
}


@end
