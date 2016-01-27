//
//  ViewController.m
//  WSGScrollView
//
//  Created by user on 16/1/27.
//  Copyright © 2016年 user. All rights reserved.
//

#import "ViewController.h"
#import "WSGScrollView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray *imageArray = @[
                            @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/2047158/beerhenge.jpg",
                            @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/2016158/avalanche.jpg",
                            @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1839353/pilsner.jpg",
                            @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1833469/porter.jpg",
                            @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/2016158/avalanche.jpg",
                            @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/2016158/avalanche.jpg",
                            ];
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:imageArray];
    
    WSGScrollView *scroll = [WSGScrollView scrollViewWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 200) imageArray:array placeHolderImage:@"" pageControlShowStyle:WSGPageControlShowStyleCenter];
    scroll.isAutoScrool = YES;
    scroll.scrollTime = 2.0f;
    scroll.tapcallbackBlock = ^(NSUInteger index,NSString *imageURL){
        
        NSLog(@"%lu  \n %@",(unsigned long)index,imageURL);
        
    };
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:scroll];
    
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(didClickLeftButton)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(didClickRightButton)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    
}

- (void)didClickLeftButton
{
    
}

- (void)didClickRightButton
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
