//
//  session.m
//  casesurfer
//
//  Created by Osvaldo on 04-06-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "Session.h"

@implementation Session


-(BOOL) login: (NSMutableDictionary *) params
      Success:(CaseSuccessDictionaryBlock)successBlock
        Error:(CaseErrorBlock)errorBlock
{

    NSString *url = [NSString stringWithFormat:@"/sessions.json"];
    
    [[CaseConnect sharedCaseSurfer] postWithUrl:url params:params Success:^(NSMutableDictionary *items) {
        [self saveUserId:[items valueForKeyPath:@"id"]];
        [self saveToken:[items valueForKeyPath:@"auth_token"]];
        [self saveEmail:[items valueForKeyPath:@"email"]];
        
      //  NSLog(@"USERID in login %@ ",[items valueForKeyPath:@"id"]);
        
        successBlock(items);
    } Error:^(NSError *error) {
        errorBlock(error);
    }];
    return TRUE;
}


-(void)saveToken:(NSString *) token {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:token forKey:@"token"];
    [defaults synchronize];
}

-(void)saveEmail:(NSString *) email {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:email forKey:@"email"];
    [defaults synchronize];
}


-(void)saveUserId:(NSString *) userId {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userId forKey:@"UserId"];
    [defaults synchronize];
}

-(NSString *) getUserId{
    if ((self.userId == nil) || ([self.userId isEqualToString:@""])) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.userId = [defaults objectForKey:@"UserId"];
    }
    return self.userId;
}

-(NSString *) getToken{
    if ((self.token == nil) || ([self.token isEqualToString:@""])) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.token = [defaults objectForKey:@"token"];
    }
    return self.token;
}

-(NSString *) getEmail{
    if ((self.email == nil) || ([self.email isEqualToString:@""])) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.email = [defaults objectForKey:@"email"];
    }
    return self.email;
}

-(void)destroy {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"token"];
    [defaults synchronize];
    [defaults removeObjectForKey:@"notifications"];
    [defaults synchronize];
}


@end
