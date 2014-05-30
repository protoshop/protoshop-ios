//
//  UINavigationController+hlyu.m
//  DynamicNavigation
//
//  Created by HongliYu on 14-4-21.
//  Copyright (c) 2014年 HongliYu. All rights reserved.
//

#import "UINavigationController+hlyu.h"
#define mainScreenWidth 320
#define mainScreenHeight 568

@implementation UINavigationController (hlyu)

-(void)pushViewControllerFrom:(UIViewController *)currentVC
                           to:(UIViewController *)nextVC
                   animatType:(kSceneTransitionType)type
                    direction:(kSceneTransitionDirectionType)direction
                    delayTime:(float)interval{
    if (type == kSceneTransitionCover) {
        if (direction == kSceneTransitionDirectionRight) {
            nextVC.view.frame = CGRectMake(-mainScreenWidth, nextVC.view.frame.origin.y, nextVC.view.frame.size.width, nextVC.view.frame.size.height);
            [currentVC.view addSubview:nextVC.view];
            
            [UIView animateWithDuration:interval animations:^{
                nextVC.view.frame = CGRectMake(0, nextVC.view.frame.origin.y, nextVC.view.frame.size.width, nextVC.view.frame.size.height);
            } completion:^(BOOL finished) {
                [self pushViewController:nextVC animated:NO];
            }];
        }
        
        if (direction == kSceneTransitionDirectionLeft) {
            nextVC.view.frame = CGRectMake(+mainScreenWidth, nextVC.view.frame.origin.y, nextVC.view.frame.size.width, nextVC.view.frame.size.height);
            [currentVC.view addSubview:nextVC.view];
            
            [UIView animateWithDuration:interval animations:^{
                nextVC.view.frame = CGRectMake(0, nextVC.view.frame.origin.y, nextVC.view.frame.size.width, nextVC.view.frame.size.height);
            } completion:^(BOOL finished) {
                [self pushViewController:nextVC animated:NO];
            }];
        }
        
        if (direction == kSceneTransitionDirectionUp) {
            nextVC.view.frame = CGRectMake(nextVC.view.frame.origin.x, mainScreenHeight, nextVC.view.frame.size.width, nextVC.view.frame.size.height);
            [currentVC.view addSubview:nextVC.view];
            
            [UIView animateWithDuration:interval animations:^{
                nextVC.view.frame = CGRectMake(nextVC.view.frame.origin.x,0, nextVC.view.frame.size.width, nextVC.view.frame.size.height);
            } completion:^(BOOL finished) {
                [self pushViewController:nextVC animated:NO];
            }];
        }
        
        if (direction == kSceneTransitionDirectionDown) {
            nextVC.view.frame = CGRectMake(nextVC.view.frame.origin.x, -mainScreenHeight, nextVC.view.frame.size.width, nextVC.view.frame.size.height);
            [currentVC.view addSubview:nextVC.view];
            
            [UIView animateWithDuration:interval animations:^{
                nextVC.view.frame = CGRectMake(nextVC.view.frame.origin.x, 0, nextVC.view.frame.size.width, nextVC.view.frame.size.height);
            } completion:^(BOOL finished) {
                [self pushViewController:nextVC animated:NO];
            }];
        }
        
        if (direction == kSceneTransitionDirectionNone) {
                [self pushViewController:nextVC animated:YES];
        }
    }
    
    if (type == kSceneTransitionPush) {
        if (direction == kSceneTransitionDirectionRight) {
            nextVC.view.frame = CGRectMake(-mainScreenWidth, nextVC.view.frame.origin.y, nextVC.view.frame.size.width, nextVC.view.frame.size.height);
            [currentVC.view addSubview:nextVC.view];
            [UIView animateWithDuration:interval animations:^{
                currentVC.view.frame = CGRectMake(mainScreenWidth, currentVC.view.frame.origin.y, currentVC.view.frame.size.width, currentVC.view.frame.size.height);
            } completion:^(BOOL finished) {
                [self pushViewController:nextVC animated:NO];
            }];
        }
        
        if (direction == kSceneTransitionDirectionLeft) {
            nextVC.view.frame = CGRectMake(mainScreenWidth, nextVC.view.frame.origin.y, nextVC.view.frame.size.width, nextVC.view.frame.size.height);
            
            [currentVC.view addSubview:nextVC.view];
            [UIView animateWithDuration:interval animations:^{
                
                currentVC.view.frame = CGRectMake(-mainScreenWidth, currentVC.view.frame.origin.y, currentVC.view.frame.size.width, currentVC.view.frame.size.height);
                
            } completion:^(BOOL finished) {
                [self pushViewController:nextVC animated:NO];
            }];
        }

        if (direction == kSceneTransitionDirectionUp) {
            nextVC.view.frame = CGRectMake( nextVC.view.frame.origin.x,mainScreenHeight, nextVC.view.frame.size.width, nextVC.view.frame.size.height);
            [currentVC.view addSubview:nextVC.view];
            [UIView animateWithDuration:interval animations:^{
                currentVC.view.frame = CGRectMake(currentVC.view.frame.origin.x, -mainScreenHeight, currentVC.view.frame.size.width, currentVC.view.frame.size.height);
            } completion:^(BOOL finished) {
                [self pushViewController:nextVC animated:NO];
            }];
        }
        
        if (direction == kSceneTransitionDirectionDown) {
            nextVC.view.frame = CGRectMake( nextVC.view.frame.origin.x,-mainScreenHeight, nextVC.view.frame.size.width, nextVC.view.frame.size.height);
            [currentVC.view addSubview:nextVC.view];
            [UIView animateWithDuration:interval animations:^{
                currentVC.view.frame = CGRectMake(currentVC.view.frame.origin.x, mainScreenHeight, currentVC.view.frame.size.width, currentVC.view.frame.size.height);
            } completion:^(BOOL finished) {
                [self pushViewController:nextVC animated:NO];
            }];
        }
        
        if (direction == kSceneTransitionDirectionNone) {
            [self pushViewController:nextVC animated:YES];
        }
    }
    
    if (type == kSceneTransitionNone) {
        [self pushViewController:nextVC animated:YES];
    }
    
}

- (void)popViewControllerFrom:(UIViewController *)currentVC
                   animatType:(kSceneTransitionType)type
                    direction:(kSceneTransitionDirectionType)direction
                    delayTime:(float)interval{
    //先要取得 preVC，在UIViewController
    //谁有更好的方法？
    UIViewController *preVC;
    NSArray *VCArr =self.viewControllers;
    for (int i =0; i<[VCArr count]; i++) {
        if (VCArr[i] == currentVC) {
           preVC = VCArr[i-1];
        }
    }
    
    if (type == kSceneTransitionCover) {
        if (direction == kSceneTransitionDirectionRight) {
            preVC.view.frame = CGRectMake(-mainScreenWidth, preVC.view.frame.origin.y, preVC.view.frame.size.width, preVC.view.frame.size.height);
            //谁有更好的方法？
            UIView* tempView = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:preVC.view]];
            [currentVC.view addSubview:tempView];
            [UIView animateWithDuration:interval animations:^{
                tempView.frame = CGRectMake(0, tempView.frame.origin.y, tempView.frame.size.width, tempView.frame.size.height);
            } completion:^(BOOL finished) {
                [self popViewControllerAnimated:NO];
            }];
        }
        
        if (direction == kSceneTransitionDirectionLeft) {
            preVC.view.frame = CGRectMake(mainScreenWidth, preVC.view.frame.origin.y, preVC.view.frame.size.width, preVC.view.frame.size.height);
            UIView* tempView = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:preVC.view]];
            [currentVC.view addSubview:tempView];
            [UIView animateWithDuration:interval animations:^{
                tempView.frame = CGRectMake(0, tempView.frame.origin.y, tempView.frame.size.width, tempView.frame.size.height);
            } completion:^(BOOL finished) {
                [self popViewControllerAnimated:NO];
            }];
        }
        
        if (direction == kSceneTransitionDirectionUp) {
            preVC.view.frame = CGRectMake(preVC.view.frame.origin.x, mainScreenHeight, preVC.view.frame.size.width, preVC.view.frame.size.height);
            UIView* tempView = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:preVC.view]];
            [currentVC.view addSubview:tempView];
            [UIView animateWithDuration:interval animations:^{
                tempView.frame = CGRectMake(preVC.view.frame.origin.x, 0, tempView.frame.size.width, tempView.frame.size.height);
            } completion:^(BOOL finished) {
                [self popViewControllerAnimated:NO];
            }];
        }
        
        if (direction == kSceneTransitionDirectionDown) {
            preVC.view.frame = CGRectMake(preVC.view.frame.origin.x, -mainScreenHeight, preVC.view.frame.size.width, preVC.view.frame.size.height);
            UIView* tempView = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:preVC.view]];
            [currentVC.view addSubview:tempView];
            [UIView animateWithDuration:interval animations:^{
                tempView.frame = CGRectMake(preVC.view.frame.origin.x, 0, tempView.frame.size.width, tempView.frame.size.height);
            } completion:^(BOOL finished) {
                [self popViewControllerAnimated:NO];
            }];
        }
        
        if (direction == kSceneTransitionDirectionNone) {
            [self popViewControllerAnimated:YES];
        }
        
    }
    
    if (type == kSceneTransitionPush) {
        if (direction == kSceneTransitionDirectionRight) {
            preVC.view.frame = CGRectMake(-mainScreenWidth, preVC.view.frame.origin.y, preVC.view.frame.size.width, preVC.view.frame.size.height);
            UIView* tempView = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:preVC.view]];

            [currentVC.view addSubview:tempView];
            [UIView animateWithDuration:interval animations:^{
                currentVC.view.frame = CGRectMake(mainScreenWidth, currentVC.view.frame.origin.y, currentVC.view.frame.size.width, currentVC.view.frame.size.height);
            } completion:^(BOOL finished) {
                [self popViewControllerAnimated:NO];
            }];
        }
        
        if (direction == kSceneTransitionDirectionLeft) {
            preVC.view.frame = CGRectMake(mainScreenWidth, preVC.view.frame.origin.y, preVC.view.frame.size.width, preVC.view.frame.size.height);
            UIView* tempView = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:preVC.view]];
            
            [currentVC.view addSubview:tempView];
            [UIView animateWithDuration:interval animations:^{
                currentVC.view.frame = CGRectMake(-mainScreenWidth, currentVC.view.frame.origin.y, currentVC.view.frame.size.width, currentVC.view.frame.size.height);
            } completion:^(BOOL finished) {
                [self popViewControllerAnimated:NO];
            }];
        }
        
        if (direction == kSceneTransitionDirectionUp) {
            preVC.view.frame = CGRectMake(preVC.view.frame.origin.x,mainScreenHeight, preVC.view.frame.size.width, preVC.view.frame.size.height);
            UIView* tempView = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:preVC.view]];
            
            [currentVC.view addSubview:tempView];
            [UIView animateWithDuration:interval animations:^{
                currentVC.view.frame = CGRectMake(currentVC.view.frame.origin.x, -mainScreenHeight, currentVC.view.frame.size.width, currentVC.view.frame.size.height);
            } completion:^(BOOL finished) {
                [self popViewControllerAnimated:NO];
            }];
        }
        
        if (direction == kSceneTransitionDirectionDown) {
            preVC.view.frame = CGRectMake(preVC.view.frame.origin.x, -mainScreenHeight, preVC.view.frame.size.width, preVC.view.frame.size.height);
            UIView* tempView = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:preVC.view]];
            
            [currentVC.view addSubview:tempView];
            [UIView animateWithDuration:interval animations:^{
                currentVC.view.frame = CGRectMake(currentVC.view.frame.origin.x, mainScreenHeight, currentVC.view.frame.size.width, currentVC.view.frame.size.height);
            } completion:^(BOOL finished) {
                [self popViewControllerAnimated:NO];
            }];
        }
        
        if (direction == kSceneTransitionDirectionNone) {
            [self popViewControllerAnimated:YES];
        }
        
    }
    
    if (type == kSceneTransitionNone) {
        [self popViewControllerAnimated:YES];
    }
    
}
@end
