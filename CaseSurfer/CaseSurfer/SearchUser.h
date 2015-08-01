//
//  SearchUser.h
//  casesurfer
//
//  Created by Osvaldo on 29-07-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchUser : NSObject
@property (nonatomic, copy) NSString *idUser;
@property (nonatomic, copy) NSString *name;

- (id)initWithName:(NSString *)name andId:(NSString *)idUser;
@end
