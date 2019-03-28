//
//  3DSWebViewController.m
//  Simplify
//
//  Created by Andrew Joyce on 27/03/2019.
//  Copyright © 2019 MasterCard Labs. All rights reserved.
//

#import "SIM3DSWebViewController.h"

@interface SIM3DSWebViewController () <WKNavigationDelegate>
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@property (nonatomic) WKWebView *webView;
@end

@implementation SIM3DSWebViewController



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
    
    self.navBar = [[UINavigationBar alloc] init];
    self.navBar.translatesAutoresizingMaskIntoConstraints = false;
    self.navBar.backgroundColor = UIColor.whiteColor;
    self.navBar.items = [[NSArray alloc] initWithObjects:navItem, nil];
    [self.view addSubview:self.navBar];
    
    self.webView = [[WKWebView alloc]init];
    self.webView.translatesAutoresizingMaskIntoConstraints = false;
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    
    NSMutableArray *constraints = [[NSMutableArray alloc] init];
    if (@available(iOS 11.0, *)) {
        [constraints addObject:[NSLayoutConstraint constraintWithItem: self.navBar attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem: self.view.safeAreaLayoutGuide attribute: NSLayoutAttributeTop multiplier: 1 constant: 0]];
    } else {
        // Fallback on earlier versions
         [constraints addObject:[NSLayoutConstraint constraintWithItem: self.navBar attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem: self.view attribute: NSLayoutAttributeTop multiplier: 1 constant: 0]];
    }
     [constraints addObject:[NSLayoutConstraint constraintWithItem: self.navBar attribute: NSLayoutAttributeLeading relatedBy: NSLayoutRelationEqual toItem: self.view attribute: NSLayoutAttributeLeading multiplier: 1 constant: 0]];
     [constraints addObject:[NSLayoutConstraint constraintWithItem: self.navBar attribute: NSLayoutAttributeTrailing relatedBy: NSLayoutRelationEqual toItem: self.view attribute: NSLayoutAttributeTrailing multiplier: 1 constant: 0]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem: self.webView attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem: self.navBar attribute: NSLayoutAttributeBottom multiplier: 1 constant: 0]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem: self.webView attribute: NSLayoutAttributeLeading relatedBy: NSLayoutRelationEqual toItem: self.view attribute: NSLayoutAttributeLeading multiplier: 1 constant: 0]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem: self.webView attribute: NSLayoutAttributeTrailing relatedBy: NSLayoutRelationEqual toItem: self.view attribute: NSLayoutAttributeTrailing multiplier: 1 constant: 0]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem: self.webView attribute: NSLayoutAttributeBottom relatedBy: NSLayoutRelationEqual toItem: self.view attribute: NSLayoutAttributeBottom multiplier: 1 constant: 0]];
    [NSLayoutConstraint activateConstraints:constraints];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)cancelAction {
    [self.delegate acsAuthCanceled];
    [self dismissViewControllerAnimated:true completion:nil];
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
    NSURLComponents *components = [NSURLComponents componentsWithString:@"https://young-chamber-23463.herokuapp.com/mobile3ds1.html"];
    NSURLQueryItem *acsUrl = [NSURLQueryItem queryItemWithName:@"acsUrl" value:secureData.acsUrl];
    NSURLQueryItem *paReq = [NSURLQueryItem queryItemWithName:@"paReq" value:secureData.paReq];
    NSURLQueryItem *md = [NSURLQueryItem queryItemWithName:@"md" value:secureData.md];
    NSURLQueryItem *termUrl = [NSURLQueryItem queryItemWithName:@"paReq" value:secureData.termUrl];
    components.queryItems = @[acsUrl, paReq, md, termUrl];
    [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:components.URL]];
}

@end

