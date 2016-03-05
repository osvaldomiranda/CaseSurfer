//
//  SearchGroup.m
//  casesurfer
//
//  Created by Osvaldo on 15-08-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "SearchGroup.h"

@implementation SearchGroup

- (id)initWithName:(NSString *)name andId:(NSString *)idGroup {
    self = [super init];
    self.name = name;
    self.idGroup = idGroup;
    return self;
}
@end
