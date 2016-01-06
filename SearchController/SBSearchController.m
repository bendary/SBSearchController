//
//  SBSearchController.m
//  
//
//  Created by xiaoshaobin on 15/12/14.
//  Copyright (c) 2015年 xiaoshaobin. All rights reserved.
//

#import "SBSearchController.h"
#import "SBSearchTool.h"

@interface SBSearchController ()

@property (nonatomic,strong) UIViewController *searchResultController;

@property (nonatomic,strong) SBSearchBar *searchBar;

@property (nonatomic,strong) UIView *searchBarBackground;

@property (nonatomic,strong) UIView *containView;

@property (nonatomic,assign) BOOL isAnimated;

@property (nonatomic,assign) CGRect statusBarFrame;

@property (nonatomic,strong) UINavigationController *navigationController;

@end

@implementation SBSearchController

- (SBSearchBar *)searchBar
{
    if (!_searchBar)
    {
        CGRect rect = CGRectMake(0,CGRectGetHeight(self.statusBarFrame) + 44, CGRectGetWidth(self.view.frame), 44);
        _searchBar = [[SBSearchBar alloc] initWithFrame:rect];
        _searchBar.backgroundColor = [UIColor whiteColor];
    }
    return _searchBar;
}

- (UINavigationController *)navigationController
{
    if (!_navigationController)
    {
        _navigationController = [[UINavigationController alloc] initWithRootViewController:self];
        _navigationController.definesPresentationContext = YES;
        _navigationController.providesPresentationContextTransitionStyle = YES;
        _navigationController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [_navigationController setNavigationBarHidden:YES];
        _navigationController.view.backgroundColor = [UIColor clearColor];
    }
    return _navigationController;
}

- (UIView *)searchBarBackground
{
    if (!_searchBarBackground)
    {
        CGRect rect = CGRectZero;
        rect.origin.y = -CGRectGetHeight(self.statusBarFrame);
        rect.size.width = CGRectGetWidth(self.view.frame);
        rect.size.height = CGRectGetHeight(self.searchBar.frame) + CGRectGetHeight(self.statusBarFrame);
        _searchBarBackground = [[UIView alloc] initWithFrame:rect];
        _searchBarBackground.backgroundColor = [UIColor whiteColor];
    }
    return _searchBarBackground;
}

- (UIView *)containView
{
    if (!_containView)
    {
        _containView = [[UIView alloc] initWithFrame:self.view.frame];
        _containView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return _containView;
}

- (CGRect)statusBarFrame
{
    return [UIApplication sharedApplication].statusBarFrame;
}

#pragma mark - Setter

- (void)setSearchResultController:(UIViewController *)searchResultController
{
    _searchResultController = searchResultController;
}

- (void)setActive:(BOOL)active
{
    [self setActive:active animated:NO];
}

- (void)setActive:(BOOL)active animated:(BOOL)animated
{
    _active = active;
    
    if (self.delegate)
    {
        UIViewController *presentingVC = [self.delegate presentingController];
        if (_active)
        {
            if ([self.delegate respondsToSelector:@selector(SB_searchControllerWillPresented:)])
            {
                [self.delegate SB_searchControllerWillPresented:self];
            }
            
            [presentingVC presentViewController:self.navigationController animated:NO completion:^{
                [self showContentView:_active animated:animated animations:^{
                    
                    [presentingVC.navigationController setNavigationBarHidden:YES animated:YES];
                    self.view.userInteractionEnabled = NO;
                    
                } complete:^(BOOL finished) {
                    
                    [self.view addSubview:self.containView];
                    self.view.userInteractionEnabled = YES;
                    
                    if ([self.delegate respondsToSelector:@selector(SB_searchControllerDidPresented:)])
                    {
                        [self.delegate SB_searchControllerDidPresented:self];
                    }
                    
                    
                }];
            }];
        }
        else if (!_active)
        {
            
            [self showContentView:_active animated:animated animations:^{
                
                [presentingVC.navigationController setNavigationBarHidden:NO animated:YES];
                self.view.userInteractionEnabled = NO;
                
            } complete:^(BOOL finished){
                
                if ([self.delegate respondsToSelector:@selector(SB_searchControllerWillDismissed:)])
                {
                    [self.delegate SB_searchControllerWillDismissed:self];
                }
                
                [presentingVC dismissViewControllerAnimated:NO completion:^{
                    
                    if ([self.delegate respondsToSelector:@selector(SB_searchControllerDidDismissed:)])
                    {
                        [self.delegate SB_searchControllerDidDismissed:self];
                    }
                    
                }];
                self.view.userInteractionEnabled = YES;
            }];
        }
    }
    
}

#pragma mark - 初始化

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.definesPresentationContext = YES;
        self.providesPresentationContextTransitionStyle = YES;
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    return self;
}

- (instancetype)initWithDelegate:(id<SBSearchControllerDelegate>)delegate
{
    self = [super init];
    if (self)
    {
        self.delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.searchBar];
    
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

#pragma mark - 其他

- (void)tap:(UITapGestureRecognizer *)tap
{
    [self setActive:NO animated:YES];
}

- (void)showContentView:(BOOL)show animated:(BOOL)animated animations:(void (^)(void))animations complete:(void (^)(BOOL finished))complete
{
    CGRect beginRect,endRect;
    beginRect = endRect = self.searchBar.frame;
    CGFloat height = CGRectGetHeight(beginRect);
    CGFloat statusHeight = CGRectGetHeight(self.statusBarFrame);
    
    CGRect bgBeginRect,bgEndRect;
    bgBeginRect = bgEndRect = self.searchBarBackground.frame;
    
    CGRect containRect = self.containView.frame;
    containRect.origin.x = 0;
    containRect.origin.y = CGRectGetMaxY(self.searchBar.frame);
    containRect.size.width = CGRectGetWidth(self.view.frame);
    containRect.size.height = CGRectGetHeight(self.view.frame) - CGRectGetMinY(containRect);
    self.containView.frame = containRect;
    
    if (show)
    {
        beginRect.origin.y = height + statusHeight;
        endRect.origin.y   = statusHeight;
        
        bgBeginRect = bgBeginRect;
        bgBeginRect.origin.y = CGRectGetMinY(beginRect);
        bgBeginRect.size.height = statusHeight;
        
        bgEndRect.origin.y = 0;
        bgEndRect.size.height = height + statusHeight;
        
        containRect.origin.y = CGRectGetMaxY(endRect);
    }
    else
    {
        beginRect.origin.y = statusHeight;
        endRect.origin.y   = height + statusHeight;
        
        bgBeginRect.origin.y = 0;
        bgEndRect = endRect;
        
        containRect.origin.y = CGRectGetMaxY(endRect);
    }
    
    containRect.size.height = CGRectGetHeight(self.view.frame) - CGRectGetMinY(containRect);
    
    self.searchBar.frame = beginRect;
    self.searchBarBackground.frame = bgBeginRect;
    
    self.searchBar.alpha = self.searchBarBackground.alpha = show ? 0 : 1;
    
    [UIView animateWithDuration:animated ? 0.25 : 0 animations:^{
        
        self.searchBar.frame = endRect;
        self.searchBarBackground.frame = bgEndRect;
        self.containView.frame = containRect;
        
        self.searchBar.alpha = self.searchBarBackground.alpha = show ? 1 : 0.5;
        
        if (animations)
        {
            animations();
        }
        
    } completion:^(BOOL finished) {
        
        
        if (complete)
        {
            complete(finished);
        }
    }];
    
}



@end
