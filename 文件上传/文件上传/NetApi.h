//
//  NetApi.h
//  文件上传
//
//  Created by 徐豪 on 15/12/4.
//  Copyright © 2015年 qianfeng. All rights reserved.
//

#ifndef NetApi_h
#define NetApi_h


#define BASE_URL @"http://u.xiyou.cntv.cn/videoupload.php"

/*
 sns 注册接口
 参数说明
 username  用户名
 password  密码
 email     邮箱
 */

#define NET_REGISTER_URL @"http://10.0.8.8/sns/my/register.php"


/*
 登录接口
 参数
 username  必填
 password  必填
 */
#define  NET_LOGIN_URL @"http://10.0.8.8/sns/my/login.php"


/*
 用户头像的接口
 uid  必填
 */

#define NET_USER_HEADIMAGE @"http://10.0.8.8/sns/my/headimage.php"


/*
 上传用户头像的接口
 参数 headimage
 */

#define NET_UPLOAD_HEADIAMGE @"http://10.0.8.8/sns/my/upload_headimage.php"


#endif /* NetApi_h */
