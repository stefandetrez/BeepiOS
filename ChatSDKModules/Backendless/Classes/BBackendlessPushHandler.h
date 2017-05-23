//
//  BBackendlessPushHandler.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#import <Foundation/Foundation.h>
#import <ChatSDKCore/BAbstractPushHandler.h>

@interface BBackendlessPushHandler : BAbstractPushHandler {
    BOOL _isSubscribed;
}

-(id) initWithAppKey: (NSString *) appKey secretKey: (NSString *) secretKey versionKey:(NSString *) versionKey;

@end
