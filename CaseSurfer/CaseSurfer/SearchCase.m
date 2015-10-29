//
//  SearchCase.m
//  casesurfer
//
//  Created by Osvaldo on 11-10-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "SearchCase.h"

@implementation SearchCase

- (id)initWithTitle:(NSString *)title andId:(NSString *)idCase andInfo:(NSDictionary *)info{
    self = [super init];
    self.title = title;
    self.idCase = idCase;
    self.info = info;
    return self;
}
@end
