//
//  SBSearchBar.h
//
//
//  Created by xiaoshaobin on 15/12/14.
//  Copyright (c) 2015年 xiaoshaobin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SBSearchBar;
@protocol SBSearchBarDelegate <NSObject>

@optional

- (void)searchBarCancelButtonClicked:(SBSearchBar *)searchBar;

@end

@interface SBSearchBar : UIView

@property (nonatomic,weak) id<SBSearchBarDelegate> delegate;

@property (nonatomic,readonly) UITextField *textField;

@property (nonatomic,readonly) UIButton *cancleButton;

@property (nonatomic,strong) UIView *unActiveView;



@end
