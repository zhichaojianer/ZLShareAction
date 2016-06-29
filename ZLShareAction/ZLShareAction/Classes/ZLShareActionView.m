//
//  ZLShareActionView.m
//  Pods
//
//  Created by liuchao on 16/6/27.
//
//

#import "ZLShareActionView.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDKUI/SSUIShareActionSheetItem.h>

@interface ZLShareActionView () <MFMessageComposeViewControllerDelegate>

@property (nonatomic, weak) UIViewController *showViewController;

@end

@implementation ZLShareActionView

- (instancetype) initWithShowViewController:(UIViewController *) viewController {
    self = [super init];
    if (self) {
        self.showViewController = viewController;
    }
    
    return self;
}

/*
 *
 *  @param platformType 平台类型
 *  @param parameters   分享参数
 *
 */
- (void) zlShareWithPlatformType:(SSDKPlatformType)platformType
                      parameters:(NSMutableDictionary *)parameters {
    [ShareSDK share:platformType  parameters:parameters onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        switch (state) {
            case SSDKResponseStateSuccess:
                NSLog(@"SSDKResponseStateSuccess");
                
                break;
            case SSDKResponseStateFail:
                NSLog(@"SSDKResponseStateFail");
                
                break;
            default:
                break;
        }
    }];
}

/**
 *
 *  分享类别：【备注：第三方分享需在相关平台注册应用】
 *  eg.应用内分享【知了、班级成员】第三方分享【微信好友、微信朋友圈、QQ好友等】
 *  说明：title 标题, image 图标, customItem 自定义分享类别【BOOL】
 *       type 分享类型【应用内参数设定为四位数，eg.10000, 第三方分享依据ShareType】
 *  @param  shareItems -> [{@"title": title, @"image": image, @"type": type, @"customItem": customItem}]
 *
 *	@param 	shareTitle          标题
 *	@param 	shareContent        分享内容
 *	@param 	shareUrl            链接
 *	@param 	shareImage          分享图片
 *
 */
- (void) zlShareActionSheetItems:(NSArray *) shareItems
                           Title:(NSString *) shareTitle
                         Content:(NSString *) shareContent
                             Url:(NSString *) shareUrl
                           Image:(id ) shareImage{
    //1、创建分享参数
    //注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    NSArray* imageArray;
    if ([shareImage isKindOfClass:[NSURL class]]) {
        imageArray = @[[NSString stringWithFormat:@"%@", shareImage]];
    }else if([shareImage isKindOfClass:[UIImage class]]){
        imageArray = @[shareImage];
    }else {
        imageArray = @[[UIImage imageNamed:shareImage]];
    }
    if (imageArray) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:shareContent
                                         images:imageArray
                                            url:[NSURL URLWithString:shareUrl]
                                          title:shareTitle
                                           type:SSDKContentTypeAuto];
        
        NSMutableArray *platforms = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *shareItemDic in shareItems) {
            NSString *itemName = [NSString stringWithFormat:@"%@",shareItemDic[@"title"]];
            UIImage  *itemIcon = (UIImage *)shareItemDic[@"image"];
            BOOL customItem = [shareItemDic[@"customItem"] boolValue];
            SSUIShareActionSheetItem *item = [SSUIShareActionSheetItem itemWithIcon:itemIcon label:itemName onClick:^{
                if (customItem) {
                    self.zlShareActionBlock(shareItemDic);
                }else{
                    SSDKPlatformType shareType = [shareItemDic[@"type"] unsignedIntValue];
                    [self zlShareWithPlatformType:shareType parameters:shareParams];
                }
            }];
            [platforms addObject:item];         
        }
        
        //2、分享
        [ShareSDK showShareActionSheet:self.showViewController.view items:platforms shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
            switch (state) {
                case SSDKResponseStateSuccess:
                    NSLog(@"SSDKResponseStateSuccess");
                    
                    break;
                case SSDKResponseStateFail:
                    NSLog(@"SSDKResponseStateFail");

                    break;
                default:
                    break;
            }
        }];
    }
}

#pragma mark -
#pragma mark 自带短信功能实现短信共享
-(void)displaySMSComposerSheet:(NSString *)SMSContent
{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    [picker.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:74/250.f green:74/250.f blue:74/250.f alpha:1], NSForegroundColorAttributeName, nil]];
    picker.messageComposeDelegate = self;
    picker.body = SMSContent;
    [self.showViewController presentViewController:picker animated:YES completion:^{
        
    }];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    
    // Notifies users about errors associated with the interface
    [controller dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    switch (result)
    {
        case MessageComposeResultCancelled:
            //            [self showAlertMessage:@"您已取消短信发送"];
            break;
        case MessageComposeResultSent:
            //            [self showAlertMessage:@"短信已发送"];
            break;
        case MessageComposeResultFailed:
            //            [self showAlertMessage:@"短信发送失败"];
            break;
        default:
            //            [self showAlertMessage:@"Result: SMS not sent"];
            break;
    }
    
}

-(void)showSMSPicker:(NSString *)SMSContent
{
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    
    if (messageClass != nil) {
        // Check whether the current device is configured for sending SMS messages
        if ([messageClass canSendText]) {
            [self displaySMSComposerSheet:SMSContent];
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"设备不支持短信功能" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"设备不支持短信功能" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

@end
