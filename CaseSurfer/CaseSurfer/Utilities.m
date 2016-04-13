//
//  Utilities.m
//  casesurfer
//
//  Created by Osvaldo on 31-08-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "Utilities.h"
#import "Definitions.h"

@implementation Utilities

- (float)labelHeightWith:(NSString *)message width:(float)width font:(UIFont *)font{
    CGSize max_size = CGSizeMake(width, CGFLOAT_MAX);
    CGRect rect =
    [message boundingRectWithSize:max_size
                          options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                       attributes:@{NSFontAttributeName: font} context:nil];
    return ceilf(rect.size.height);
}

- (float)labelWidthWith:(NSString *)message height:(float)height font:(UIFont *)font{
    CGSize max_size = CGSizeMake(CGFLOAT_MAX, height);
    CGRect rect =
    [message boundingRectWithSize:max_size
                          options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                       attributes:@{NSFontAttributeName: font} context:nil];
    return ceilf(rect.size.width);
}


-(float) screenHeight {
   CGFloat screenHeight = [UIScreen mainScreen].applicationFrame.size.height;
    return screenHeight;
}

-(float) screenWidth {
    CGFloat screenWidth = [UIScreen mainScreen].applicationFrame.size.width;
    return screenWidth;
}

- (UIView *) addSeparator: (int) positionY {
    Utilities *util = [[Utilities alloc] init];
    CGRect frameView  = CGRectMake(0, positionY, [util screenWidth] , 8);
    
    UIView *separator = [[UIView alloc] initWithFrame:frameView];
    UIView *shadow1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [util screenWidth], 1)];
    UIView *block = [[UIView alloc] initWithFrame:CGRectMake(0, 1, [util screenWidth], 7)];
    UIView *shadow2 = [[UIView alloc] initWithFrame:CGRectMake(0, 8, [util screenWidth], 1)];
    
    [separator setBackgroundColor:[UIColor clearColor]];
    [shadow1 setBackgroundColor:grayShadowSep];
    [block setBackgroundColor:graySep];
    [shadow2 setBackgroundColor:grayShadowSep];
    
    [separator addSubview:shadow1];
    [separator addSubview:block];
    [separator addSubview:shadow2];
    [separator setTag:1];
    return separator;
}

- (UIImage *)squareImageWithImage:(UIImage *)myimage {

    
    int centropropy = 0;
    int centropropx = 0;
    int a = myimage.size.height*640/myimage.size.width;
    int b = myimage.size.width*640/myimage.size.height;
    
     UIImage *image = [self imageWithImage:myimage convertToSize: CGSizeMake(640,a )];
    
    if (myimage.size.height>myimage.size.width) {
        centropropy = (a/2) - 320;
    }else {
        centropropx = (b/2) - 320;
        image = [self imageWithImage:myimage convertToSize: CGSizeMake(b,640 )];
    }

    
   
   
    CGRect rect =  CGRectMake(centropropx, centropropy, 640, 640);
        if (&UIGraphicsBeginImageContextWithOptions) {
            UIGraphicsBeginImageContextWithOptions(rect.size,
                                                   /* opaque */ NO,
                                                   /* scaling factor */ 0.0);
        } else {
            UIGraphicsBeginImageContext(rect.size);
        }
        [image drawAtPoint:CGPointMake(-rect.origin.x, -rect.origin.y)];
        UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return result;
}

- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    return destImage;
}


@end
