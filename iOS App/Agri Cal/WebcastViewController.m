//
//  WebcastViewController.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 3/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WebcastViewController.h"

@interface WebcastViewController ()

@end

@implementation WebcastViewController
@synthesize webView;
@synthesize url = _url;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self embedYouTube:self.url];
}
- (void)embedYouTube:(NSString*)urlString {  
    NSString *embedHTML = @"\
    <html><head>\
    <style type=\"text/css\">\
    body {\
    background-color: black;\
    }\
    #container{\
    position: relative;\
    z-index:1;\
    }\
    #video,#videoc{\
    position:absolute;\
    z-index: 1;\
    border: none;\
    }\
    #tv{\
    background: transparent url(tv.png) no-repeat;\
    width: 320px;\
    height: 367px;\
    position: absolute;\
    top: 0;\
    z-index: 999;\
    }\
    </style>\
    </head><body style=\"margin:0\">\
    <div id=\"tv\"></div>\
    <object id=\"videoc\" width=\"320\" height=\"367\">\
    <param name=\"movie\" value=\"%@\"></param>\
    <param name=\"wmode\" value=\"transparent\"></param>\
    <embed wmode=\"transparent\" id=\"video\" src=\"%@&autoplay=1\" type=\"application/x-shockwave-flash\" \
    width=\"320\" height=\"367\"></embed>\
    </object>\
    </body></html>";
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];      
    NSString *html = [NSString stringWithFormat:embedHTML, urlString,urlString];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(queue, ^{
        [self.webView loadHTMLString:html baseURL:baseURL];
    });
}

/*
    A little hack to make the video start with no user interaction required. 
 */
- (void)webViewDidFinishLoad:(UIWebView *)_webView {
    UIButton *b = [self findButtonInView:_webView];
    [b sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (UIButton *)findButtonInView:(UIView *)view {
    UIButton *button = nil;
    
    if ([view isMemberOfClass:[UIButton class]]) {
        return (UIButton *)view;
    }
    
    if (view.subviews && [view.subviews count] > 0) {
        for (UIView *subview in view.subviews) {
            button = [self findButtonInView:subview];
            if (button) return button;
        }
    }
    return button;
}
- (void)viewDidUnload
{
    [self setWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
