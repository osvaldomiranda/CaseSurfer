//
//  NewAlbumViewController.m
//  casesurfer
//
//  Created by Osvaldo on 11-05-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "NewAlbumViewController.h"
#import "Album.h"
#import "UIAlertView+Block.h"
#import "NSString+Validation.h"
#import "Definitions.h"
#import "UIImageView+WebCache.h"


@interface NewAlbumViewController ()

@end

@implementation NewAlbumViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:TRUE];
    
    if (self.albumId != nil) {
        [self setAlbum];
    }
    
    
    [self setSelectedImage: self.imageInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.hidesBottomBarWhenPushed =  YES;
}

-(void) setAlbum{
    Album *album=[[Album alloc] init];
    
    [album find:self.albumId Success:^(NSMutableDictionary *items) {
        self.txtTitle.text = [items valueForKeyPath:@"name"];
        NSMutableDictionary *coverA = [items valueForKeyPath:@"cover"];
        NSMutableDictionary *coverb = [coverA valueForKeyPath:@"cover"];
        NSMutableDictionary *normal = [coverb valueForKeyPath:@"normal"];
        
        NSString *coverUrl = [NSString stringWithFormat:@"%@%@",DEV_BASE_PATH, [normal valueForKeyPath:@"url"]];
        NSURL *urlCoverAlbum = [NSURL URLWithString:[coverUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        [self.albumImage setImageWithURL:urlCoverAlbum placeholderImage: [UIImage imageNamed:@"logo.png"]];
        
    } Error:^(NSError *error) {
    }];
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
    
    if (self.albumImage.image == nil) {
        self.albumImage.image = [UIImage imageNamed:@"logo.png"];
    }
}

- (IBAction)create:(id)sender {
    if (self.albumId == nil) {
        [self createAlbum:self];
    }else{
        [self updateAlbum: self];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancel:(id)sender {
      [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)selectImage:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    rollGridChoseImageViewController *cController = [storyBoard instantiateViewControllerWithIdentifier:@"rollGridChose"];
    
    cController.delegate = self;
    cController.callerViewController = self;
    
    self.hidesBottomBarWhenPushed =  YES;
    [self.navigationController pushViewController:cController animated:YES];
}

- (IBAction)createAlbum:(id)sender {
    
    if (![self.txtTitle.text isValidText]) {
        [UIAlertView alertViewOopsWithmessage:@"You must place a valid Title."];
    } else {
        Album *album = [[Album alloc] init];
        album.title = self.txtTitle.text;
        album.image = self.albumImage.image;
        [album createOrUpdate:@"" action:@"create"];
    }
}

- (IBAction)updateAlbum:(id)sender {
    
    if (![self.txtTitle.text isValidText]) {
        [UIAlertView alertViewOopsWithmessage:@"You must place a valid Title."];
    } else {
        Album *album = [[Album alloc] init];
        album.title = self.txtTitle.text;
        album.image = self.albumImage.image;
        [album createOrUpdate: [NSString stringWithFormat:@"%d",self.albumId] action:@"update"];
    }
}

- (void)onSelectImage:(IndexableImageView *) image{
    [self setSelectedImage: image];
}


@end
