//
//  SearchCase.h
//  casesurfer
//
//  Created by Osvaldo on 11-10-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchCase : NSObject

@property (nonatomic, copy) NSString *idCase;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSDictionary *info;

- (id)initWithTitle:(NSString *)title andId:(NSString *)idCase andInfo:(NSDictionary *)info;


@end
