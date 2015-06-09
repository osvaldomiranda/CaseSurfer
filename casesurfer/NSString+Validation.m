//
//  NSString+Validation.h
//  Cranberry
//
//  Created by Osvaldo Antonio Miranda Silva on 30-03-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "NSString+Validation.h"

@implementation NSString(Validation)

- (BOOL)isValidEmail{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)isValidText{
    if (self != nil) {
        return ![self isEmpty];
    }
    return NO;
}

- (BOOL)isEmpty{
    if(self.length>0){
        return NO;
    }
    return YES;
}

@end
