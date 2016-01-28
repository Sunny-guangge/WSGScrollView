//
//  ViewController.m
//  WSGScrollView
//
//  Created by user on 16/1/27.
//  Copyright © 2016年 user. All rights reserved.
//

#import "ViewController.h"
#import "WSGScrollView.h"

@interface ViewController ()<UIScrollViewDelegate>
{
    UIScrollView *scr;
}
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
//                            @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/2016158/avalanche.jpg",
//                            @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/2016158/avalanche.jpg",
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
    
    
    
    scr = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 200, self.view.frame.size.width, 180)];
    scr.bounces = NO;
    scr.showsHorizontalScrollIndicator = NO;
    scr.showsVerticalScrollIndicator = NO;
    scr.contentSize = CGSizeMake(self.view.frame.size.width * 3, 180);
    scr.contentOffset = CGPointMake(self.view.frame.size.width, 0);
    scr.pagingEnabled = YES;
    scr.delegate = self;
    scr.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:scr];
    
    UIView *oneView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 180)];
    oneView.backgroundColor = [UIColor redColor];
    [scr addSubview:oneView];
    
    UIView *twoView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, 180)];
    twoView.backgroundColor = [UIColor blueColor];
    [scr addSubview:twoView];
    
    UIView *threeView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 2, 0, self.view.frame.size.width, 180)];
    threeView.backgroundColor = [UIColor greenColor];
    [scr addSubview:threeView];
}

- (void)didClickLeftButton
{
    [scr setContentOffset:CGPointMake(self.view.frame.size.width * 2, 0) animated:YES];
}

- (void)didClickRightButton
{
    scr.contentOffset = CGPointMake(self.view.frame.size.width, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
