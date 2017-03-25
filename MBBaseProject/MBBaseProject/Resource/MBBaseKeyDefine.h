//
//  MBBaseKeyDefine.h
//  MBProject
//
//  Created by yunjing on 2017/2/14.
//  Copyright © 2017年 Yuri. All rights reserved.
//

#ifndef MBBaseKeyDefine_h
#define MBBaseKeyDefine_h

/* 登录账号状态 0 商家 1 协助账号 **/
#define DEF_USERSTATUS_KEY_LOGIN        @"loginStatus"
/* 是否已经登录 **/
#define DEF_USERDEFAULTS_KEY_ISLOGIN        @"isLogin"
/** api md5 加密 盐 */
#define DEF_USERDEFAULTS_KEY_MD5_SALT       @"MD5_SALT"
/* token过期 **/
#define DEF_NOTIFICATION_TOKEN_OUT          @"tokenOut"
/* 用户退出 **/
#define DEF_NOTIFICATION_LOGIN_OUT          @"loginOut"
/* 注册成功 **/
#define DEF_NOTIFICATION_REGISTER_SUCCESS   @"registerSuccess"
/* 认证成功 **/
#define DEF_NOTIFICATION_CERT_SUCCESS       @"certificationSuccess"

/* 协作账号登录成功 **/
#define DEF_NOTIFICATION_ASSISTANT_SUCCESS       @"assistantLoginSuccess"
/* 协作账退出成功 **/
#define DEF_NOTIFICATION_ASSISTANT_LOGINOUT       @"assistantLoginOut"

#endif /* MBBaseKeyDefine_h */

/* 日期选择（通知key）**/
#define NOTICE_DATESELECT                   @"dateSelect"

/* 已兑换数据（通知key）**/
#define NOTICE_REQUESTEXCHANGERECORD        @"requestExchangeRecord"


#pragma mark - 发红包
/** 红包的开始时间距当前时间的最小间隔（秒）*/
#define TIMEINTERVAL_MIN_WITHCURRENT (0)

/** 红包的结束时间距开始时间的最小间隔（秒）*/
#define TIMEINTERVAL_MIN_REDENVELOPE (24 * 60 * 60)
