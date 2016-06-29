# ZLShareAction

ZLShareAction是在知了项目开发过程中基于ShareSDK抽象出来，目的在于以注入的形式实现分享。
使用示例：


NSString *contenturl = @"http://www.imzhiliao.com";

NSArray *shareItems = @[
@{@"title"      : @"知了",
@"image"      : [UIImage imageNamed:@"ShareSDK_cicada"],
@"type"       : [NSNumber numberWithInteger:1000],
@"customItem" : [NSNumber numberWithBool:YES]
},
@{
@"title"      : @"微信好友",
@"image"      : [UIImage imageNamed:@"ShareSDK_wechat"],
@"type"       : [NSNumber numberWithInteger:SSDKPlatformSubTypeWechatSession],
@"customItem" : [NSNumber numberWithBool:NO]
},
@{
@"title"      : @"QQ好友",
@"image"      : [UIImage imageNamed:@"ShareSDK_qq"],
@"type"       : [NSNumber numberWithInteger:SSDKPlatformSubTypeQQFriend],
@"customItem" : [NSNumber numberWithBool:NO]
}
];

ZLShareActionView *zlShareActionView = [[ZLShareActionView alloc] initWithShowViewController:self];
[zlShareActionView zlShareActionSheetItems:shareItems
Title:@"知了，理解源自沟通"
Content:@"知了，一款让教师家长沟通更加轻松便捷的软件。快来尝试新的沟通方式吧~"
Url:contenturl
Image:[UIImage imageNamed:@"shar_app_icon"]];
zlShareActionView.zlShareActionBlock = ^(NSDictionary *shareItemDic){
NSLog(@"shareItemDic -> %@", shareItemDic);
// 应用内业务处理
};