//
//  BBackendlessUploadHandler.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#import <Foundation/Foundation.h>
#import <ChatSDKCore/BAbstractUploadHandler.h>

@interface BBackendlessUploadHandler : BAbstractUploadHandler

-(id) initWithAppKey: (NSString *) appKey secretKey: (NSString *) secretKey versionKey:(NSString *) versionKey;

@end
