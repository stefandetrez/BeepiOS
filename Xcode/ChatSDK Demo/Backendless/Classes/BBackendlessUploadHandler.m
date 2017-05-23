//
//  BBackendlessUploadHandler.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#import "BBackendlessUploadHandler.h"
#import <RXPromise/RXPromise.h>
#import <Backendless.h>
#import "BBackendless.h"

#import <ChatSDKCore/BCoreUtilities.h>

@implementation BBackendlessUploadHandler

-(id) initWithAppKey: (NSString *) appKey secretKey: (NSString *) secretKey versionKey:(NSString *) versionKey {
    if ((self = [self init])) {
        [BBackendless sharedManagerWithAppKey:appKey
                                    secretKey:secretKey
                                   versionKey:versionKey];
    }
    return self;
}

-(RXPromise *) uploadFile:(NSData *)file withName: (NSString *) name mimeType:(NSString *)mimeType {
    
    RXPromise * promise = [RXPromise new];
    
    NSString * fileName = [[BCoreUtilities getUUID] stringByAppendingFormat:@"-%@", name];
    
    [backendless.fileService.permissions grantForAllRoles:fileName operation:FILE_READ];
    
    [backendless.fileService saveFile:fileName content:file response:^(BackendlessFile * file) {
        
        [promise resolveWithResult:@{bFilePath: file.fileURL, bFileName: name}];
        
    } error:^(Fault * fault) {
        
        [promise rejectWithReason:fault];
    }];
    
    return promise;
}

@end
