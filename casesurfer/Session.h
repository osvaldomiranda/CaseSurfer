//
//  session.h
//  casesurfer
//
//  Created by Osvaldo on 04-06-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseApiModel.h"


@interface Session : BaseApiModel

@property (nonatomic, retain) NSString *token;
@property (nonatomic, retain) NSString *email;

-(NSString *) getToken;
-(NSString *) getEmail;
-(void)saveEmail:(NSString *) email;
-(void)saveToken:(NSString *) token;



-(BOOL) login: (NSMutableDictionary *) params
      Success:(CaseSuccessDictionaryBlock)successBlock
        Error:(CaseErrorBlock)errorBlock;

-(void)destroy;

@end
