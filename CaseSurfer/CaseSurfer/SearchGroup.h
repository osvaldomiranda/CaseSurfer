//
//  SearchGroup.h
//  casesurfer
//
//  Created by Osvaldo on 15-08-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchGroup : NSObject
@property (nonatomic, copy) NSString *idGroup;
@property (nonatomic, copy) NSString *name;

- (id)initWithName:(NSString *)name andId:(NSString *)idGroup;

@end
