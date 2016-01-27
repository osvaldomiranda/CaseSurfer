//
//  CaseConnect.m
//  casesurfer
//
//  Created by Osvaldo on 25-04-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "CaseConnect.h"
#import "SVHTTPClient.h"
#import "Definitions.h"

@implementation CaseConnect{
    NSString *token;
    SVHTTPClient *client;
    NSMutableDictionary *collections;
    
}

- (id)initWithClient:(SVHTTPClient *)c {
    if (self = [super init]) {
        client = c;
        [client setBasePath:BASE_PATH];
    }
    return self;
}


+ (id)sharedCaseSurfer{
    return [self sharedChicWithIdentifier:@"main"];
}

+ (id)sharedChicWithIdentifier:(NSString *)identifier {
    CaseConnect *sharedCaseSurfer = [[self sharedCaseSurfers] objectForKey:identifier];
    
    if (!sharedCaseSurfer) {
        SVHTTPClient *client = [SVHTTPClient sharedClientWithIdentifier:identifier];
        
        sharedCaseSurfer = [[CaseConnect alloc] initWithClient:client];
        
        [[self sharedCaseSurfers] setObject:sharedCaseSurfer forKey:identifier];
    }
    
    return sharedCaseSurfer;
}

+ (void)removeAllCaseSurfer {
    [[self sharedCaseSurfer] removeAllObjects];
}

+ (id)sharedCaseSurfers {
    static NSMutableDictionary *_sharedChics = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedChics = [[NSMutableDictionary alloc] init];
    });
    
    return _sharedChics;
}


- (void) postWithUrl:(NSString *)url
             params:(NSMutableDictionary *)params
            Success:(ChicSuccessDictionaryBlock)successBlock
              Error:(ChicErrorBlock)errorBlock {
    
    
    [client POST:url parameters:params completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        
       // NSLog(@"POST %@",response);
       // NSLog(@"POST %@",error);
        
        if ([response isKindOfClass:[NSDictionary class]]) {
            successBlock(response);
        }
        else{
            errorBlock(error);
        }
    }sendParametersAsJSON:TRUE];
}


- (void) getWithUrl:(NSString *)url
             params:(NSMutableDictionary *)params
      Success:(ChicSuccessArrayBlock)successBlock
        Error:(ChicErrorBlock)errorBlock {
    

    
        [client GET:url parameters:params completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
            
       //    NSLog(@"Get %@",response);
       //    NSLog(@"Get %@",error);
            
            if ([response isKindOfClass:[NSArray class]]) {
                successBlock(response);
            } else {
                errorBlock(error);
            }
        }];
}

- (void) getDictionaryWithUrl:(NSString *)url
             params:(NSMutableDictionary *)params
            Success:(ChicSuccessDictionaryBlock)successBlock
              Error:(ChicErrorBlock)errorBlock {
    
    [client GET:url parameters:params completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        if ([response isKindOfClass:[NSDictionary class]]) {
            successBlock(response);
        } else {
            errorBlock(error);
        }
    }];
}


- (void) putWithUrl:(NSString *)url
             params:(NSMutableDictionary *)params
            Success:(ChicSuccessDictionaryBlock)successBlock
              Error:(ChicErrorBlock)errorBlock {

    
    [client PUT:url parameters:params completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        
       // NSLog(@"Get %@",response);
       // NSLog(@"Get %@",error);
        
     //    NSLog(@"PUT %@",response);
        if ([response isKindOfClass:[NSDictionary class]]) {
            successBlock(response);
            
        } else {
            errorBlock(error);
        }
    }];
}

- (void) deleteWithUrl:(NSString *)url
              params:(NSMutableDictionary *)params
             Success:(ChicSuccessDictionaryBlock)successBlock
               Error:(ChicErrorBlock)errorBlock {
    
    
    [client DELETE:url parameters:params completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        successBlock(response);
    }];
   
    
}






@end
