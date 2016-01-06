//
//  SBSearchController.h
//
//
//  Created by xiaoshaobin on 15/12/14.
//  Copyright (c) 2015年 xiaoshaobin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBSearchBar.h"

@class SBSearchController;
@protocol SBSearchControllerDelegate <NSObject>

@required

- (UIViewController *)presentingController;

@optional

- (void)SB_searchControllerWillPresented:(SBSearchController *)searchControlle;
- (void)SB_searchControllerDidPresented:(SBSearchController *)searchControlle;
- (void)SB_searchControllerWillDismissed:(SBSearchController *)searchControlle;
- (void)SB_searchControllerDidDismissed:(SBSearchController *)searchControlle;

@end

@interface SBSearchController : UIViewController

- (instancetype)initWithDelegate:(id<SBSearchControllerDelegate>) delegate;

@property (nonatomic,weak) id<SBSearchControllerDelegate> delegate;

@property (nonatomic,assign,getter = isActive) BOOL active;
- (void)setActive:(BOOL)active animated:(BOOL)animated;

@property (nonatomic,readonly) SBSearchBar *searchBar;

@property (nonatomic,readonly) UIView *searchBarBackground;

@property (nonatomic,readonly) UIView *containView;

@property (nonatomic,readonly) UINavigationController *navigationController;

@end
