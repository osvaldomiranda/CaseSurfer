//
//  SearchUser.m
//  casesurfer
//
//  Created by Osvaldo on 29-07-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "SearchUser.h"

@implementation SearchUser

- (id)initWithName:(NSString *)name andId:(NSString *)idUser {
    self = [super init];
    self.name = name;
    self.idUser = idUser;
    return self;
}


@end
