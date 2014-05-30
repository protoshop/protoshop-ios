//
//  messageBoxViewController.m
//  DynamicApp
//
//  Created by HongliYu on 13-12-3.
//  Copyright (c) 2013年 kuolei. All rights reserved.
//

#import "messageBoxViewController.h"

@interface messageBoxViewController ()
@property (strong, nonatomic) IBOutlet UIButton *homeBtn;
@property (strong, nonatomic) IBOutlet UIButton *stayBtn;

@end

@implementation messageBoxViewController

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
    
    self.view.layer.cornerRadius = 5.0;
    self.view.layer.borderWidth = 0.0;
    self.view.layer.borderColor = [[UIColor whiteColor]CGColor];
    
    SET_FONT(_homeBtn.titleLabel,@"FontAwesome",36.f);
    SET_FONT(_stayBtn.titleLabel,@"FontAwesome",36.f);
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backToMainView:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(backButtonClicked:)]) {
        [self.delegate backButtonClicked:self];
    }
}

- (IBAction)stayHere:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelButtonClicked:)]) {
        [self.delegate cancelButtonClicked:self];
    }
}
@end