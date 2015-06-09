//
//  CaseConnect.h
//  casesurfer
//
//  Created by Osvaldo on 25-04-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ChicSuccessBlock)(void);
typedef void (^ChicSuccessDictionaryBlock)(NSMutableDictionary *items);
typedef void (^ChicSuccessArrayBlock)(NSMutableArray *items);
typedef void (^ChicErrorBlock)(NSError *error);

@interface CaseConnect : NSObject

+ (id)sharedCaseSurfer;


- (void) postWithUrl:(NSString *)url
              params:(NSMutableDictionary *)params
             Success:(ChicSuccessDictionaryBlock)successBlock
               Error:(ChicErrorBlock)errorBlock;


- (void) getWithUrl:(NSString *)url
             params:(NSMutableDictionary *)params
            Success:(ChicSuccessArrayBlock)successBlock
              Error:(ChicErrorBlock)errorBlock;

- (void) getDictionaryWithUrl:(NSString *)url
                       params:(NSMutableDictionary *)params
                      Success:(ChicSuccessDictionaryBlock)successBlock
                        Error:(ChicErrorBlock)errorBlock;

@end
