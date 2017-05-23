//
//  BBackendless.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#import <Foundation/Foundation.h>

@interface BBackendless : NSObject

+(void) sharedManagerWithAppKey: (NSString *) appKey secretKey: (NSString *) secretKey versionKey:(NSString *) versionKey;

@end
