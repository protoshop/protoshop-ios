//
//  SSOAuthViewController.m
//  CtripSSOAuth
//
//  Created by Anselz on 14-3-6.
//  Copyright (c) 2014年 Anselz. All rights reserved.
//

#import "SSOAuthViewController.h"
#import "CTSSOLoginView.h"

@interface SSOAuthViewController ()<CTSSOAuthDelegate>
@property (weak, nonatomic) IBOutlet CTSSOLoginView *loginView;

@end


@implementation SSOAuthViewController

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
    self.loginView.delegate = self;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)authSuccess:(NSDictionary *)userInfo
{
//    [self.navigationController popToRootViewControllerAnimated:YES];//不然跳不过去
    if (self.delegate && [self.delegate respondsToSelector:@selector(authSuccess:)]) {
        [self.delegate authSuccess:userInfo];
    }
}

@end
