//
//  3DSWebViewController.m
//  Simplify
//
//  Created by Andrew Joyce on 27/03/2019.
//  Copyright © 2019 MasterCard Labs. All rights reserved.
//

#import "SIMThreeDSWebViewController.h"

@interface SIMThreeDSWebViewController () <WKNavigationDelegate>
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@property (nonatomic) WKWebView *webView;
@end

@implementation SIMThreeDSWebViewController



- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    [self setupView];
//    if (self) {
//
//    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    [self setupView];
    //    if (self) {
    //
    //    }
    return self;
}

-(void)setupView {
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
    self.activityIndicator.hidesWhenStopped = true;
    
    self.cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel target: self action: @selector(cancelAction)];
    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    navItem.leftBarButtonItem = self.cancelButton;
    navItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicator];
    
    
}

-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)cancelAction {
    [self.delegate acsAuthCanceled];
}


-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self.activityIndicator startAnimating];
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.activityIndicator stopAnimating];
}

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *url = navigationAction.request.URL;
    NSURLComponents *components = [[NSURLComponents alloc] initWithURL:url resolvingAgainstBaseURL:false];
    
    if ([components.scheme isEqualToString:@"simplifysdk"]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        
        NSString *result;
        
        for (NSURLQueryItem *queryItem in components.queryItems) {
            if ([queryItem.name isEqualToString:@"result"]) {
                result = queryItem.value;
            }
        }
        
        [self.delegate acsAuthResult:result];
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

-(void)authenticateCardHolderWithSecureData:(SIM3DSecureData *)secureData {
    NSString *baseUrl = @"https://young-chamber-23463.herokuapp.com/mobile3ds1.html";
    NSMutableString *acsRequest = [[NSMutableString alloc] initWithString:baseUrl];
    [acsRequest appendString:@"?acsUrl="];
    [acsRequest appendString:secureData.acsUrl];
    [acsRequest appendString:@"&paReq="];
    [acsRequest appendString:secureData.paReq];
    [acsRequest appendString:@"&md="];
    [acsRequest appendString:secureData.md];
    [acsRequest appendString:@"&termUrl="];
    [acsRequest appendString:secureData.termUrl];
    [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:acsRequest]]];
}

@end

