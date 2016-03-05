//
//  NSString+Validation.h
//  Cranberry
//
//  Created by Osvaldo Antonio Miranda Silva on 30-03-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Validation)

- (BOOL)isValidEmail;
- (BOOL)isValidText;

@end
