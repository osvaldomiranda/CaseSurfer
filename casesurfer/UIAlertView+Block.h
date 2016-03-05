//
//  UIAlertView+Block.h
//  Cranberry Chic
//
//  Created by Aldrin Martoq on 4/20/13.
//  Copyright (c) 2013 Cranberry Chic. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^DismissBlock)(int buttonIndex);
typedef void (^CancelBlock)();

@interface UIAlertView (Block)

+ (UIAlertView*) alertViewWithTitle:(NSString*) title
                            message:(NSString*) message
                  cancelButtonTitle:(NSString*) cancelButtonTitle
                  otherButtonTitles:(NSArray*) otherButtons
                          onDismiss:(DismissBlock) dismissed
                           onCancel:(CancelBlock) cancelled;
+ (UIAlertView*) alertViewWithTitle:(NSString*) title
                            message:(NSString*) message;
+ (UIAlertView*) alertViewOopsWithmessage:(NSString*) message;
@property (nonatomic, copy) DismissBlock dismissBlock;
@property (nonatomic, copy) CancelBlock cancelBlock;

@end
