//
//  CTViewController.m
//  CTRIP_TRAVLE
//
//  Created by new_ctrip on 13-7-2.
//  Copyright (c) 2013年 kuolei. All rights reserved.
//

#import "CTViewController.h"

@interface CTViewController ()<interactiveDelegate,CTViewDelegate,UIScrollViewDelegate>

//装载所有的View
@property (nonatomic, strong) NSMutableDictionary *dictViews;
//记录当前显示的View
@property (nonatomic, strong) UIView *currentView;

@property (nonatomic,strong) messageBoxViewController *messageVC;
@end

@implementation CTViewController


#pragma mark - --------------------退出清空--------------------
#pragma mark - --------------------初始化--------------------

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
    [self initData];
    UISwipeGestureRecognizer *threeFingerSwipeRecognizerUp = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(threeFingerSwipeUp)];
    [threeFingerSwipeRecognizerUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [threeFingerSwipeRecognizerUp setNumberOfTouchesRequired:3];
    [self.view addGestureRecognizer:threeFingerSwipeRecognizerUp];
    
    UISwipeGestureRecognizer *threeFingerSwipeRecognizerDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(threeFingerSwipeDown)];
    [threeFingerSwipeRecognizerDown setDirection:UISwipeGestureRecognizerDirectionDown];
    [threeFingerSwipeRecognizerDown setNumberOfTouchesRequired:3];
    [self.view addGestureRecognizer:threeFingerSwipeRecognizerDown];
    
    UITapGestureRecognizer *threeFingerTapped = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(threeFingerTapped)];
    [threeFingerTapped setNumberOfTouchesRequired:2];//先做两指测试
    [self.view addGestureRecognizer:threeFingerTapped];
    
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(backButtonClicked:)];
    // Do any additional setup after loading the view from its nib.
}
-(void)initData
{
    self.dictViews = [[NSMutableDictionary alloc]initWithCapacity:0];
    self.currentView = nil;
}

#pragma mark - --------------------System--------------------


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - --------------------功能函数--------------------

-(void)threeFingerSwipeUp{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)threeFingerSwipeDown{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)threeFingerTapped{
    self.messageVC = nil;
    self.messageVC = [[messageBoxViewController alloc]init];
    self.messageVC.delegate = self;
    [self.messageVC.view setBackgroundColor:[UIColor blackColor]];
    [self presentPopupViewController:self.messageVC animationType:Frost];
}

- (void)cancelButtonClicked:(messageBoxViewController *)messageBoxVC
{
    [self dismissPopupViewControllerWithanimationType:Frost];
    self.messageVC = nil;
}

#pragma mark - --------------------手势事件--------------------

#pragma mark - --------------------按钮事件--------------------

-(void)backButtonClicked:(messageBoxViewController*) messageBoxVC{
    [self dismissPopupViewControllerWithanimationType:Blur];
    self.messageVC = nil;//必须先移除，不然不会有反应，这是为什么
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        NSRange subRange = [viewController.description rangeOfString:@"WXDProjectsViewController"];
        if (subRange.location != NSNotFound) {
            [self.navigationController popToViewController:viewController animated:YES];
        }
    }
}

#pragma mark - --------------------代理方法--------------------

#pragma mark - --------------------属性相关--------------------
#pragma mark - --------------------接口API--------------------

#pragma mark - 动画处理函数
/**
 当前视图做动画
 
 @param transition 进场方式
 @param direction  进场方向
 
 @return nil 不需要返回值
 
 */
-(void)performTransition:(kSceneTransitionType)transition
           withDirection:(kSceneTransitionDirectionType)direction
          onEnteringView:(UIView *)entering
         removingOldView:(UIView *)exiting

{
    [self performTransition:transition withDirection:direction onEnteringView:entering removingOldView:exiting durationTime:0.4f];
}

/**
 当前视图做动画
 
 @param transition 进场方式
 @param direction  进场方向
 @param time       动画时间
 
 @return nil 不需要返回值
 
 */
-(void)performTransition:(kSceneTransitionType)transition
           withDirection:(kSceneTransitionDirectionType)direction
          onEnteringView:(UIView *)entering
         removingOldView:(UIView *)exiting
            durationTime:(NSTimeInterval)time

{
    CGFloat _viewWidth = 320.0f;
    CGFloat _viewHeight = self.view.frame.size.height;
    CGFloat tx = 0.0f;
    CGFloat ty = 0.0f;
    
    if(direction == kSceneTransitionDirectionLeft)          tx = -_viewWidth;
    else if(direction == kSceneTransitionDirectionRight)    tx = _viewWidth;
    else if(direction == kSceneTransitionDirectionUp)       ty = -_viewHeight;
    else if(direction == kSceneTransitionDirectionDown)     ty = _viewHeight;
    
    if (transition == kSceneTransitionPush) {
        entering.transform = CGAffineTransformMakeTranslation(-tx, -ty);
        [UIView animateWithDuration:time animations:^{
            [self.view insertSubview:entering aboveSubview:exiting];
            exiting.transform = CGAffineTransformMakeTranslation(tx, ty);
            entering.transform = CGAffineTransformMakeTranslation(0, 0);
        } completion:^(BOOL finished) {
            [exiting removeFromSuperview];
        }];
    }
    
    else if (transition == kSceneTransitionCover) {
        entering.transform = CGAffineTransformMakeTranslation(-tx, -ty);
        [UIView animateWithDuration:time animations:^{
            [self.view insertSubview:entering aboveSubview:exiting];
            entering.transform = CGAffineTransformMakeTranslation(0.0f, 0.0f);
        } completion:^(BOOL finished) {
            [exiting removeFromSuperview];
        }];
    } else {
         [self.view insertSubview:entering aboveSubview:exiting];
         [exiting removeFromSuperview];
    }
}



/**
 设置背景图片
 
 @param imagePath  背景图片名称
 
 @return nil 不需要返回值
 
 */
-(void)setBackgroundImage:(NSString *)imagePath
{
    if (imagePath.length <= 0) {
        return;
    }
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    if (image == nil) {
        return;
    }
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    imageView.image = image;
    [self.view addSubview:imageView];
}

/**
 添加视图子View
 
 @param viewName  View的名字
 
 @return CTView 一个CTView的实例
 
 */
-(CTView *)addCTView:(NSString *)viewName
{
    CTView *view = [[CTView alloc]initWithFrame:self.view.bounds];
    [self.dictViews setObject:view forKey:viewName];
    return view;
}

-(void)clickHotzoneWith:(id)current
                 target:(id)target
             animatType:(kSceneTransitionType)type
              direction:(kSceneTransitionDirectionType)direction
              delayTime:(float)interval
{
    [self performTransition:type withDirection:direction onEnteringView:target removingOldView:current durationTime:interval];
}
@end