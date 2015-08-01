//
//  BaseApiModel.h
//  casesurfer
//
//  Created by Osvaldo on 25-04-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CaseConnect.h"

typedef void (^CaseSuccessBlock)(void);
typedef void (^CaseSuccessDictionaryBlock)(NSMutableDictionary *items);
typedef void (^CaseSuccessArrayBlock)(NSArray *items);
typedef void (^CaseErrorBlock)(NSError *error);

@interface BaseApiModel : CaseConnect

@property (assign, nonatomic) NSMutableDictionary *params;
@property (assign, nonatomic) NSString *baseUrl;
@property (assign, nonatomic) NSString *className;

-(id) initWithParams:(NSMutableDictionary *) params;

-(void) find:(int) identifier
     Success:(CaseSuccessDictionaryBlock)successBlock
       Error:(CaseErrorBlock)errorBlock;

-(id) getByKey: (NSString *) field;

-(void) save:(NSMutableDictionary *) params
 withSession:(BOOL) withSession
     Success:(CaseSuccessDictionaryBlock)successBlock
       Error:(CaseErrorBlock)errorBlock;

-(void) index:(NSMutableDictionary *) params
      Success:(CaseSuccessArrayBlock)successBlock
        Error:(CaseErrorBlock)errorBlock;

-(void) update:(int) identifier
        params:(NSMutableDictionary *) params
       Success:(CaseSuccessDictionaryBlock)successBlock
         Error:(CaseErrorBlock)errorBlock;

@end
