//
//  CustomTabBarController.m
//  cranberrychic-iphone-2
//
//  Created by mac1 on 29-09-13.
//  Copyright (c) 2013 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "CustomTabBarController.h"
#import "CSToolBar.h"

@interface CustomTabBarController ()

@end

@implementation CustomTabBarController

@synthesize viewControllersArray;

- (id)init{
    
    self = [super init];
    
    if (self){
        currentSelectedIndex = 0;
        buttonsCreated = FALSE;
    }
    
    return self;
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (!buttonsCreated){
        
        UIView *emptyView = [[UIView alloc] initWithFrame:[self.tabBar bounds]];
        
        [emptyView setUserInteractionEnabled:TRUE];
        [emptyView setTag:99];
        [self.tabBar addSubview:emptyView];
        self.tabBar.layer.borderWidth = 0.0f;
        [self.tabBar.layer setBorderColor:(__bridge CGColorRef)([UIColor whiteColor])];
        
        buttonsCreated = TRUE;
        
        tool = [CSToolBar new];
        
        [tool setPosY:0];
        [tool setDelegate:self];
        
        [emptyView addSubview:tool];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)topViewController{
    return [[self.viewControllersArray objectAtIndex:currentSelectedIndex] topViewController];
}

- (void)changeIndex:(NSInteger)newIndex{
    UIViewController *tViewController = [self.viewControllersArray objectAtIndex:newIndex];
    
    currentSelectedIndex = newIndex;
    
     NSLog(@"%@",tViewController);
    [self setSelectedViewController:tViewController];
}

#pragma mark - CSToolbarDelegate

- (void)actionButtonWithIndex:(NSInteger)index{
    [self changeIndex:index];
}

- (UIView*)obtainViewToShowMenu{
    return [[self topViewController] view];
}

- (id)obtainViewController{
    return [self topViewController];
}

@end
