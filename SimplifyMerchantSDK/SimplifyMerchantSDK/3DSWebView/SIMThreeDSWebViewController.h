#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "SIM3DSecureData.h"


@protocol SIMThreeDSWebViewControllerDelegate

-(void)acsAuthResult:(NSString *)acsResult;

-(void)acsAuthError:(NSError *)error;

-(void)acsAuthCanceled;

@end

@interface SIMThreeDSWebViewController : UIViewController

/**
 Delegate for SIMThreeDSWebViewControllerDelegate
 */
@property (nonatomic, weak) id <SIMThreeDSWebViewControllerDelegate> delegate;

-(void)authenticateCardHolderWithSecureData:(SIM3DSecureData *) secureData;

@end

