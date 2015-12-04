//
//  ViewController.m
//  文件上传
//
//  Created by 徐豪 on 15/12/4.
//  Copyright © 2015年 qianfeng. All rights reserved.
//

#import "ViewController.h"

#import "AFNetworking.h"

#import "Networking.h"

#import "NetApi.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *username;

@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *email;

@end

@implementation ViewController
/*
   1 sdwebImage,AFNETworking第三方库的简单使用
   2 文档的查看
   3注册，登录，上传头像，上传视频等一些操作
 AFNETworking的使用步骤
 1先导入这个第三方库
 2.运行项目看会不会报错
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
//注册
- (IBAction)resign:(id)sender {
    
    //除非这三个参数都有值才能够进入下面的程序
    if (self.username.text.length&&self.password.text.length&&self.email.text.length) {
        NSDictionary *dic = @{@"username":self.username.text,@"password":self.password.text,@"email":self.email.text};
        
        //AFHTTPSessionManager 封装NSURLSession
        AFHTTPSessionManager *mg = [AFHTTPSessionManager manager];
        //序列化
        mg.responseSerializer = [AFHTTPResponseSerializer serializer];
        //get请求 注册参数1：传请求路径 参数2
        [mg GET:NET_REGISTER_URL parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
            //
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:NULL];
            
            NSLog(@"dic = %@",dic);
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"error = %@",error);
        }];
        
    }
    
}
//登录
- (IBAction)login:(id)sender {
    
    if (self.username.text.length&&self.password.text.length){
        NSDictionary *dic = @{@"username":self.username.text,@"password":self.password.text};
        AFHTTPSessionManager *mg = [AFHTTPSessionManager manager];
        mg.responseSerializer = [AFHTTPResponseSerializer serializer];
        [mg GET:NET_LOGIN_URL parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:NULL];
            NSLog(@"dic = %@",dic);
            NSString *code = [dic objectForKey:@"code"];
            if ([code isEqualToString:@"login_success"]){
                //登录成功
                //1获得用户uid
                NSString *uid = dic[@"uid"];
                //2本地保存uid
                [[NSUserDefaults  standardUserDefaults]setObject:uid forKey:@"uid"];
                //3同步到磁盘
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                //用户登录成功我们也把用户名字和密码写入到沙盒目录
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                [user setValue:self.username.text forKey:@"username"];
                [user setValue:self.password.text forKey:@"password"];
                [user synchronize];
                
                
            }
            
            
            
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"error %@",error);
        }];
    }

    
}
//上传头像
- (IBAction)updataHeadImage:(id)sender {
    
    //文件上传一定是post请求
    
    AFHTTPSessionManager *mg = [AFHTTPSessionManager manager];
    mg.responseSerializer = [AFHTTPResponseSerializer serializer];

    [mg POST:NET_UPLOAD_HEADIAMGE parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //上传的文件信息写到请求体里面
        UIImage *image = [UIImage imageNamed:@"01.png"];
        //上传文件的格式 二进制
        NSData *data = UIImagePNGRepresentation(image);
        
        
        //获取mimeType
        
        //参数1 要上传的二进制数据
        //参数2 服务器（后台）要求咱们上传的参数名称
        //参数3 上传的文件在服务器上面的名称
        //参数4 mimeType 固定格式
        [formData appendPartWithFileData:data name:@"headimage" fileName:@"test" mimeType:@"image/png"];
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:NULL];
        NSLog(@"dic %@",dic);
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error %@",error);
    }];
    
    
    
}
//上传视频
- (IBAction)updataVideo:(id)sender {
    
    //获取文件路径
    NSString *path = @"/Users/haoxu/Desktop/test1.mp4";
    
    //转化成二进制
    NSData *videoData = [NSData dataWithContentsOfFile:path];
    // 上传参数
    NSDictionary *paras = @{@"client_id"    : @"88el6o736x",
                            @"eid"          : @"356",
                            @"access_token" : @"d6a8dd3cc585a2432a1eaac1dd095b12",
                            @"title"        : @"shipinbiaoti-000",
                            @"description"  : @"shipinmiaoshu2222-000",
                            @"categoryid"   : @"105"};
    
    [Networking UploadDataWithUrlString:BASE_URL parameters:paras timeoutInterval:nil requestType:HTTPRequestType responseType:JSONResponseType constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        /*
         此方法参数
         1. 要上传的[二进制数据]
         2. 对应网站上[upload.php中]处理文件的[字段"file"]（跟服务器商量好）
         3. 要保存在服务器上的[文件名](随便写)
         4. 上传文件的[mimeType]
         */
        [formData appendPartWithFileData:videoData name:@"upload_file" fileName:@"upload_file" mimeType:@"Video/mp4"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 请求头
        //        NSLog(@"operation.request : %@", operation.request.allHTTPHeaderFields);
        
        // 服务器回复的头
        //        NSLog(@"operation.response : %@", operation.response);
        
        // 返回数据
        NSLog(@"responseObject : %@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // 错误信息
        NSLog(@"error : %@", error);
    }];
    

    
}

@end
