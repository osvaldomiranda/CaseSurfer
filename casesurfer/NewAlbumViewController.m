//
//  NewAlbumViewController.m
//  casesurfer
//
//  Created by Osvaldo on 11-05-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "NewAlbumViewController.h"
#import "rollGridChoseImageViewController.h"
#import "Album.h"
#import "UIAlertView+Block.h"
#import "NSString+Validation.h"

@interface NewAlbumViewController ()

@end

@implementation NewAlbumViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:TRUE];
    
    [self setSelectedImage: self.imageInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




- (void)setSelectedImage:(IndexableImageView *)image;
{
    ALAssetsLibrary *assetsL = [[ALAssetsLibrary alloc] init];
    
    [assetsL assetForURL: image.assetURL
             resultBlock:^(ALAsset *asset){
                 if (asset != nil){
                     ALAssetRepresentation *repr = [asset defaultRepresentation];
                     UIImage *_img = [UIImage imageWithCGImage:[repr fullResolutionImage] scale:1.0f orientation:(UIImageOrientation)[repr orientation]];
                     
                     self.albumImage.image = _img;
                 }
             }failureBlock:^(NSError *error) {
                 NSLog(@"error: %@", error);
             }
     ];
}

- (IBAction)create:(id)sender {
    [self createCase:self];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)cancel:(id)sender {
      [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)createCase:(id)sender {
    
    if (![self.txtTitle.text isValidText]) {
        [UIAlertView alertViewOopsWithmessage:@"You must place a valid Title."];
    } else {
        Album *album = [[Album alloc] init];
        album.title = self.txtTitle.text;
        album.image = self.imageInfo;
        [album create];
        
        [self.navigationController setNavigationBarHidden:TRUE];
     //   [[NSNotificationCenter defaultCenter] postNotificationName:loginObserver
     //                                                       object:nil];
        
    }
}


@end
