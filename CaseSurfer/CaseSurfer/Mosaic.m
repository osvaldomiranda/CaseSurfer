//
//  Mosaic.m
//  casesurfer
//
//  Created by Osvaldo on 21-08-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "Mosaic.h"
#import "Definitions.h"
#import "UIImageView+WebCache.h"

@implementation Mosaic

-(id) initMosaic:(NSArray *) caseImages frameView:(CGRect) frameView{
    self = [super init];
    self.frame = frameView;
    self.images = caseImages;
    [self fillView:self.images];
    return self;
}

-(void) fillView:(NSArray *) images{
    
    CGRect firstViewFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width);
    CGRect secondViewFrame = CGRectMake((self.frame.size.width/4)*3, 0, self.frame.size.width/2, self.frame.size.width);
    
    CGRect secondAframe = CGRectMake(2, 0, secondViewFrame.size.width-1, (secondViewFrame.size.height/2)-1);
    CGRect secondBframe = CGRectMake(2, (secondViewFrame.size.height/2)+1, secondViewFrame.size.width-1, (secondViewFrame.size.height/2)-1);
    
    UIView *secondView = [[UIView alloc] init];
    secondView.backgroundColor = [UIColor whiteColor];
    secondView.frame = secondViewFrame;
    
    
    UILabel *lblMas = [[UILabel alloc] init];
    lblMas.text = @"+3";
    [lblMas setFont:[UIFont boldSystemFontOfSize: 40.0f]];
    lblMas.textColor = [UIColor whiteColor];
    
    
    int i = 0;
    for (NSDictionary *image in images) {
        NSDictionary *img = [image valueForKeyPath:@"image"];
        NSDictionary *thumb = [img valueForKeyPath:@"normal"];
        NSString *imgUrl = [NSString stringWithFormat:@"%@%@",DEV_BASE_PATH , [thumb valueForKeyPath:@"url"]];
        NSURL *urlImgCase = [NSURL URLWithString:[imgUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        UIImageView *image = [[UIImageView alloc] init];
        
        [image setImageWithURL:urlImgCase placeholderImage: [UIImage imageNamed:@"logo.png"]];
        if (i==0) {
            image.frame = firstViewFrame;
            [self addSubview:image];
            if ([images count]==2) {
                UIView *back = [[UIView alloc] init];
                back.backgroundColor = [UIColor blackColor];
                back.frame = CGRectMake(0, 0, image.frame.size.width, image.frame.size.width);
                back.alpha = 0.2f;
                [image addSubview:back];
                lblMas.textAlignment = NSTextAlignmentCenter;
                lblMas.text = @"+1";
                lblMas.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width);
                [self addSubview:lblMas];
            }
        }
        
        if ([images count]>2) {
            if (i==1) {
                image.frame = secondAframe;
                [secondView addSubview:image];
            }
            
            if (i==2) {
                image.frame = secondBframe;
                [secondView addSubview:image];
                if ([images count]>3) {
                    UIView *back = [[UIView alloc] init];
                    back.backgroundColor = [UIColor blackColor];
                    back.frame = CGRectMake(0, 0, image.frame.size.width, image.frame.size.width);
                    back.alpha = 0.2f;
                    [image addSubview:back];
                    
                    lblMas.text = [NSString stringWithFormat:@"+%lu", [self.images count]-3];
                    lblMas.frame = CGRectMake(0, 0, image.frame.size.width, image.frame.size.width);
                    lblMas.textAlignment = NSTextAlignmentCenter;
                    [image addSubview:lblMas];
                }
            }
            [self addSubview:secondView];
        }
        
        i++;
    }
}

@end
