//
//  UIAlertView+Block.m
//  Cranberry Chic
//
//  Created by Aldrin Martoq on 4/20/13.
//  Copyright (c) 2013 Cranberry Chic. All rights reserved.
//

#import "UIAlertView+Block.h"
#import <objc/runtime.h>

static char DISMISS_IDENTIFER = 'd';
static char CANCEL_IDENTIFER = 'c';

@implementation UIAlertView (Block)

- (void)setDismissBlock:(DismissBlock)dismissBlock {
    objc_setAssociatedObject(self, &DISMISS_IDENTIFER, dismissBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (DismissBlock)dismissBlock {
    return objc_getAssociatedObject(self, &DISMISS_IDENTIFER);
}

- (void)setCancelBlock:(CancelBlock)cancelBlock {
    objc_setAssociatedObject(self, &CANCEL_IDENTIFER, cancelBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CancelBlock)cancelBlock {
    return objc_getAssociatedObject(self, &CANCEL_IDENTIFER);
}

+ (UIAlertView*) alertViewWithTitle:(NSString*) title
                            message:(NSString*) message
                  cancelButtonTitle:(NSString*) cancelButtonTitle
                  otherButtonTitles:(NSArray*) otherButtons
                          onDismiss:(DismissBlock) dismissed
                           onCancel:(CancelBlock) cancelled {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:[self class]
                                          cancelButtonTitle:cancelButtonTitle
                                          otherButtonTitles:nil];
    
    [alert setDismissBlock:dismissed];
    [alert setCancelBlock:cancelled];
    
    for(NSString *buttonTitle in otherButtons)
        [alert addButtonWithTitle:buttonTitle];
    
    [alert show];
    return alert;
}

+ (void)alertView:(UIAlertView*) alertView didDismissWithButtonIndex:(NSInteger) buttonIndex {
	if(buttonIndex == [alertView cancelButtonIndex]) {
		if (alertView.cancelBlock) {
            alertView.cancelBlock();
        }
	} else {
        if (alertView.dismissBlock) {
            alertView.dismissBlock(buttonIndex - 1.0); // cancel button is button 0
        }
    }
}

+ (UIAlertView*) alertViewWithTitle:(NSString*) title
                            message:(NSString*) message
                  cancelButtonTitle:(NSString*) cancelButtonTitle {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:cancelButtonTitle
                                          otherButtonTitles: nil];
    [alert show];
    return alert;
}

+ (UIAlertView*) alertViewWithTitle:(NSString*) title
                            message:(NSString*) message {
    
    return [UIAlertView alertViewWithTitle:title
                                   message:message
                         cancelButtonTitle:NSLocalizedString(@"Dismiss", @"")];
}

+ (UIAlertView*) alertViewOopsWithmessage:(NSString*) message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"¡Alert!"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    return alert;
}

@end
