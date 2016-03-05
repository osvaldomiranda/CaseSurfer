//
//  ViewController.m
//  casesurfer
//
//  Created by Osvaldo on 25-04-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "ViewController.h"
#import "UserNewTableViewController.h"
#import "CBCNavigationController.h"
#import "CustomTabBarController.h"
#import "LoginTableViewController.h"
#import "FeedViewController.h"
#import "Definitions.h"
#import "session.h"


@interface ViewController ()

@end

@implementation ViewController



- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(shouldLogin)
                                                     name:loginObserver
                                                   object:nil];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setStateUploading];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES];
    
    self.btnSignUp.layer.cornerRadius = 22;
    self.btnSignUp.layer.masksToBounds = YES;
    self.btnSignUp.layer.borderColor = [UIColor whiteColor].CGColor;
    self.btnSignUp.layer.borderWidth = 2.0f;
    
    self.btnLogin.layer.cornerRadius = 22;
    self.btnLogin.layer.masksToBounds = YES;
    self.btnLogin.layer.borderColor = [UIColor whiteColor].CGColor;
    self.btnLogin.layer.borderWidth = 2.0f;
    
    Session *mySession = [[Session alloc] init];
    if ([mySession getToken] != nil ) {
        [self shouldLogin];
    }
}


-(int) screen {
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    
    return screenWidth;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    
}

-(void) setStateUploading{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"NO" forKey:@"uploading"];
    [defaults synchronize];
}

- (IBAction)buttonLogin:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginTableViewController *cController = [storyBoard instantiateViewControllerWithIdentifier:@"Login"];
    [self.navigationController pushViewController:cController animated:YES];
}

- (IBAction)ButtonSignUp:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UserNewTableViewController *cController = [storyBoard instantiateViewControllerWithIdentifier:@"UserNew"];
    [self.navigationController pushViewController:cController animated:YES];
}


- (id)initViewControllers{
    
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    id viewController0 = [storyBoard instantiateViewControllerWithIdentifier:@"Feed"];
    
    id viewController1 = [storyBoard instantiateViewControllerWithIdentifier:@"Albums"];
    
    id viewController3 = [storyBoard instantiateViewControllerWithIdentifier:@"Groups"];
    
    id viewController4 = [storyBoard instantiateViewControllerWithIdentifier:@"Setings"];
    
    CBCNavigationController *navController0 = [[CBCNavigationController alloc] initWithRootViewController:viewController0];
    CBCNavigationController *navController1 = [[CBCNavigationController alloc] initWithRootViewController:viewController1];
    CBCNavigationController *navController3 = [[CBCNavigationController alloc] initWithRootViewController:viewController3];
    CBCNavigationController *navController4 = [[CBCNavigationController alloc] initWithRootViewController:viewController4];
    

    NSArray *viewControllersArray = viewControllersArray = [[NSArray alloc] initWithObjects:navController0, navController1, navController3, navController4, nil];
    
    CustomTabBarController *tabBarController = [CustomTabBarController new];
    
    
    [tabBarController setViewControllersArray:viewControllersArray];
    [tabBarController setViewControllers:viewControllersArray];
    
    return tabBarController;
}

- (void)shouldLogin{
    
    [self.navigationController setNavigationBarHidden:TRUE];
    [[self navigationController] pushViewController:[self initViewControllers]
                                           animated:TRUE];
    
}







@end
