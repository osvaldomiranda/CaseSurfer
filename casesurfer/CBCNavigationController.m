//
//  CBCNavigationController.m
//  Cranberry
//
//  Created by Santos Ramon Brito on 25-03-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "CBCNavigationController.h"
#import "Definitions.h"

@interface CBCNavigationController ()

@end

@implementation CBCNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    if (self = [super initWithRootViewController:rootViewController]) {
        
    }
    return self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:animated];
    
    if ([self.viewControllers indexOfObject:viewController] != NSNotFound &&
        [self.viewControllers indexOfObject:viewController] > 0){
        [self.navigationBar setBackgroundColor: [UIColor whiteColor]];
        self.navigationBar.translucent = NO;
        //config back button
        UIImage *img = [UIImage imageNamed:@"icon_back"];
        UIBarButtonItem *barBackButtonItem = [[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStylePlain target:self action:@selector(popCurrentViewController)];
        barBackButtonItem.tintColor = backButtonColor;
        [viewController.navigationItem setLeftBarButtonItem: barBackButtonItem];
        
        viewController.navigationItem.hidesBackButton   = YES;
        //config title
        self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: greenColor,
                                                   NSFontAttributeName: [UIFont systemFontOfSize:17.0]
                                                   };
    }
}

- (void)popCurrentViewController
{
    [self popViewControllerAnimated:YES];
}

@end
