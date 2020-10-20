//
//  DTMoreFooterView.m
//  DuiTang
//
//  Created by guanghai wen on 12-1-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PullMoreFooterView.h"

@implementation PullMoreFooterView

- (id)initWithScrollView:(UIScrollView *)scroll
{
    CGRect frame = CGRectMake(0.0f, 0.0f - scroll.bounds.size.height, scroll.bounds.size.width, scroll.bounds.size.height);
    if ((self = [super initWithFrame:frame]))
    {
        self.backgroundColor = [UIColor clearColor];
        
        //scrollView = [scroll retain];
        scrollView = scroll;
        [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
        
        [scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:NULL];
        
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width, 40.0f)];
        
		_statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		_statusLabel.font = [UIFont boldSystemFontOfSize:13.0f];
		_statusLabel.textColor = [UIColor grayColor];
		_statusLabel.backgroundColor = [UIColor clearColor];
		_statusLabel.textAlignment = NSTextAlignmentCenter;

		[self addSubview:_statusLabel];
        
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		_activityView.frame = CGRectMake(30.0f, 10.0f, 20.0f, 20.0f);
		[self addSubview:_activityView];
        
        [self setState:PullMoreHide];
    }
    return self;
}

#pragma mark -
#pragma mark UIScrollView

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"])
    {
        if (_state == PullMoreNormal | _state == PullMoreHide  )
        {
            CGRect frame = CGRectMake(0.0f, scrollView.contentSize.height, scrollView.contentSize.width, 40.0f);
            self.frame = frame;
            if (scrollView.contentSize.height < scrollView.frame.size.height)
            {
                self.hidden = YES;
            }
            else
            {
                self.hidden = NO;
            }
        }
    }
    
    if ([keyPath isEqualToString:@"contentOffset"])
    {
        if (scrollView.isDragging)
        {
            float bottom = scrollView.contentSize.height - scrollView.frame.size.height;
            if (_state == PullMoreReady)
            {
                //if([RRDevice systemVersionNumber] >= 7)
                if(self.bHasBottom)
                {
                    if (scrollView.contentOffset.y - 50.0 < bottom + 40.0f)
                    {
                        [self setState:PullMoreNormal];
                    }
                }
                else
                {
                    if (scrollView.contentOffset.y < bottom + 40.0f)
                    {
                        [self setState:PullMoreNormal];
                    }
                }
            }
            else if (_state == PullMoreNormal)
            {
                //if([RRDevice systemVersionNumber] >= 7)
                if(self.bHasBottom)
                {
                    if (scrollView.contentOffset.y - 50.0 > bottom + 40.0f)
                    {
                        [self setState:PullMoreReady];
                    }
                }
                else
                {
                    if (scrollView.contentOffset.y > bottom + 40.0f)
                    {
                        [self setState:PullMoreReady];
                    }
                }
            }
        }
        else
        {
            if (_state == PullMoreReady)
            {
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.2f];
                [self setState:PullMoreLoading];
                CGSize size = CGSizeMake(scrollView.contentSize.width,scrollView.contentSize.height+40.0f);
                scrollView.contentSize = size;
                [UIView commitAnimations];
                if ([_delegate respondsToSelector:@selector(pullMoreFooterViewShouldRefresh:)])
                {
                    [_delegate pullMoreFooterViewShouldRefresh:self];
                }
            }
        }
    }
}



- (void)dealloc
{
    [scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [scrollView removeObserver:self forKeyPath:@"contentSize"];
//    [scrollView release];
//    [_statusLabel release];
//    [_activityView release];
    self.delegate = nil;
    //[super dealloc];
}

- (void)setState:(PullMoreState)aState
{
	switch (aState)
    {
		case PullMoreReady:
			_statusLabel.text = NSLocalizedString(@"释放查看更多...", @"Release to refresh status");			
			break;
            
		case PullMoreNormal:
			_statusLabel.text = NSLocalizedString(@"上拉查看更多...", @"Pull down to refresh status");
			[_activityView stopAnimating];
			
			break;
		case PullMoreLoading:
			_statusLabel.text = NSLocalizedString(@"加载中...", @"Loading Status");
			[_activityView startAnimating];
			break;
        case PullMoreHide:
            _statusLabel.text = @"全部加载完毕";
            [_activityView stopAnimating];
            break;
		default:
			break;
	}
	
	_state = aState;
}

- (void)finishedLoading
{
    if (_state == PullMoreLoading)
    {
        /*[UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3f];
        CGSize size = CGSizeMake(scrollView.contentSize.width,scrollView.contentSize.height-40.0f);
        scrollView.contentSize = size;
         */
        [self setState:PullMoreNormal];
        //[UIView commitAnimations];
    }
}

@end
