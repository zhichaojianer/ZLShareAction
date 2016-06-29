//
//  ZLShareActionView.h
//  Pods
//
//  Created by liuchao on 16/6/27.
//
//

#import <UIKit/UIKit.h>
#import <ShareSDK/ShareSDK.h>

typedef void(^ZLShareActionBlock)(NSDictionary *shareItemDic);

@interface ZLShareActionView : UIView

@property (nonatomic, copy) ZLShareActionBlock zlShareActionBlock;

- (instancetype) initWithShowViewController:(UIViewController *) viewController;

/*
 *
 *  @param platformType 平台类型
 *  @param parameters   分享参数
 *
 */
- (void) zlShareWithPlatformType:(SSDKPlatformType)platformType
                      parameters:(NSMutableDictionary *)parameters;

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
                           Image:(id) shareImage;
@end
