//
//  BBackendless.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#import "BBackendless.h"

#import <Backendless.h>

@implementation BBackendless

static BBackendless * instance;

+(BBackendless *) sharedManagerWithAppKey: (NSString *) appKey secretKey: (NSString *) secretKey versionKey:(NSString *) versionKey {
    
    @synchronized(self) {
        
        // If the sharedSoundManager var is nil then we need to allocate it.
        if(instance == nil) {
            // Allocate and initialize an instance of this class
            instance = [[self alloc] init];
            
            [backendless initApp:appKey
                          secret:secretKey
                         version:versionKey];
            
        }
    }
    return instance;
}

-(id) init {
    if ((self = [super init])) {
        
    }
    return self;
}



@end
