//
//  Utilities.h
//  casesurfer
//
//  Created by Osvaldo on 31-08-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CropInterface.h"

@interface Utilities : NSObject

@property (nonatomic, strong) CropInterface *cropper;

- (UIImage *)squareImageWithImage:(UIImage *)myimage;
- (float)labelHeightWith:(NSString *)message width:(float)width font:(UIFont *)font;
- (float)labelWidthWith:(NSString *)message height:(float)height font:(UIFont *)font;
- (float) screenWidth;
- (float) screenHeight;
- (UIView *) addSeparator: (int) positionY;


@end
