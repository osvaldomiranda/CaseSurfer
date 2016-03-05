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
    UIView *myview = [[UIView alloc] init];
    myview.frame = CGRectMake(0, 0, 640, 840);
    self.cropper = [[CropInterface alloc]initWithFrame:myview.bounds Image:myimage andRatio:1];
    UIImage *croppedImage = [self.cropper getCroppedImage];
    return croppedImage;
}



@end
