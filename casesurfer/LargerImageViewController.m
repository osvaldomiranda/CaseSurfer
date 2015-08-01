//
//  LargerImageViewController.m
//  casesurfer
//
//  Created by Osvaldo on 27-05-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "LargerImageViewController.h"
#import "Definitions.h"
#import "UIImageView+WebCache.h"

@interface LargerImageViewController ()

@end



@implementation LargerImageViewController
@synthesize scrollView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
  //  self.displayImage.image = self.originalImage;
    [self setScrollViewProperties];
    [self fillHorizontalView:self.images];
    
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


-(void)setScrollViewProperties{
    scrollView = [[photoGalery alloc] initGrid:4 gridHeight:360];
    
    scrollView.contentMode = (UIViewContentModeScaleAspectFill);
    scrollView.contentSize =  CGSizeMake(360,85);
    scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = YES;
    scrollView.alwaysBounceVertical = NO;
    scrollView.alwaysBounceHorizontal = NO;
    scrollView.autoresizingMask = (UIViewAutoresizingFlexibleHeight);
    scrollView.maximumZoomScale = 3;
    scrollView.minimumZoomScale = 1;
    scrollView.clipsToBounds = YES;
    scrollView.frame = CGRectMake(0, 150, 380, 360);
    scrollView.gridDelegate = self;
    
    [self.view addSubview:scrollView];
}

-(void) fillHorizontalView:(NSArray *) images{
    
    int i = 0;
    for (NSDictionary *image in images) {
        
        NSDictionary *img = [image valueForKeyPath:@"image"];
        NSDictionary *thumb = [img valueForKeyPath:@"thumb"];
        NSString *imgUrl = [NSString stringWithFormat:@"%@", [thumb valueForKeyPath:@"url"]];
        NSURL *urlImgCase = [NSURL URLWithString:[imgUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        //     IndexableImageView *imageInfo = [[IndexableImageView alloc] initWithUrl:urlImgCase andImageInfo:image];
        
        UIImageView *coverAlbum = [[UIImageView alloc] init];
        [coverAlbum setImageWithURL:urlImgCase placeholderImage:nil options:0 success:^(UIImage *image, BOOL cached) {
            
            [scrollView insertPicture:image withAssetURL:urlImgCase index:i];
            
        } failure:^(NSError *error) {
        }];
        
        i++;
    }
    
}


#pragma GridScrollView

- (void) selectImageWithAssetURL:(UIImage *)image indexImage:(int)indexImage assetUrl:(NSURL *)assetUrl
{
    
    NSDictionary *imageInfo = self.images[indexImage];
    NSDictionary *img = [imageInfo valueForKeyPath:@"image"];
    NSDictionary *thumb = [img valueForKeyPath:@"normal"];
    NSString *imgUrl = [NSString stringWithFormat:@"%@", [thumb valueForKeyPath:@"url"]];
    NSURL *urlImgCase = [NSURL URLWithString:[imgUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    
    [imageView setImageWithURL:urlImgCase placeholderImage:nil options:0 success:^(UIImage *image, BOOL cached) {

        
    } failure:^(NSError *error) {
    }];
    
    
    
}
#pragma END GridScrollView

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
