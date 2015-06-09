//
//  BaseApiModel.m
//  casesurfer
//
//  Created by Osvaldo on 25-04-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "BaseApiModel.h"
#import "Definitions.h"
#import "session.h"


@implementation BaseApiModel


-(id) initWithParams:(NSMutableDictionary *) params{
    self = [super init];
    self.params = params;
    self.className =[NSString stringWithFormat:@"%@s",   NSStringFromClass([self class]).lowercaseString];
    return self;
}

-(id) getByKey: (NSString *) field {
    return   [self.params valueForKey: field];
}

    
-(void) save:(NSMutableDictionary *) params
 withSession:(BOOL) withSession
     Success:(CaseSuccessDictionaryBlock)successBlock
       Error:(CaseErrorBlock)errorBlock
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (withSession) {
        Session *mySession = [[Session alloc] init];
        parameters = @{@"auth_token": [mySession getToken] }.mutableCopy;;
    }
    [parameters addEntriesFromDictionary:params];
    
    NSString *className = [NSString stringWithFormat:@"%@s",NSStringFromClass([self class]).lowercaseString];
    NSString *url = [NSString stringWithFormat:@"%@%@.json", @"/", className];
    
    [[CaseConnect sharedCaseSurfer] postWithUrl:url params:parameters Success:^(NSMutableDictionary *items) {
        successBlock(items);
    } Error:^(NSError *error) {
        errorBlock(error);
    }];
}



-(void) find:(int) identifier
             Success:(CaseSuccessDictionaryBlock)successBlock
               Error:(CaseErrorBlock)errorBlock
{
 
    Session *mySession = [[Session alloc] init];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    parameters = @{@"auth_token": [mySession getToken] }.mutableCopy;;
    
    NSString *className = [NSString stringWithFormat:@"%@s",NSStringFromClass([self class]).lowercaseString];
    
    NSString *url = [NSString stringWithFormat:@"%@%@/%d.json", @"/", className, identifier ];
    
    [[CaseConnect sharedCaseSurfer] getDictionaryWithUrl:url params:parameters Success:^(NSMutableDictionary *items) {
        successBlock(items);
    } Error:^(NSError *error) {
        errorBlock(error);
    }];
}

-(void) index:(NSMutableDictionary *) params
     Success:(CaseSuccessArrayBlock)successBlock
       Error:(CaseErrorBlock)errorBlock
{
    Session *mySession = [[Session alloc] init];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    parameters = @{@"auth_token": [mySession getToken] }.mutableCopy;;
    [parameters addEntriesFromDictionary:params];
    
    NSString *className = [NSString stringWithFormat:@"%@s",NSStringFromClass([self class]).lowercaseString];
    NSString *url = [NSString stringWithFormat:@"%@%@.json", @"/", className];
    
    [[CaseConnect sharedCaseSurfer] getWithUrl:url params:parameters Success:^(NSArray *items) {
        successBlock(items);
    } Error:^(NSError *error) {
        errorBlock(error);
    }];
}



@end
