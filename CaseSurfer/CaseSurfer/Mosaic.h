//
//  Mosaic.h
//  casesurfer
//
//  Created by Osvaldo on 21-08-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Mosaic : UIView

@property (nonatomic,strong) NSArray *images;

-(id) initMosaic:(NSArray *) caseImages frameView:(CGRect) frameView;

@end
