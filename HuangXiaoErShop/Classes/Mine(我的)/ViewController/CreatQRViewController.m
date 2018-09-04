//
//  CreatQRViewController.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/8/6.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "CreatQRViewController.h"

@interface CreatQRViewController ()

@property (nonatomic, strong) UIImageView *qrImageView;

@end

@implementation CreatQRViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    leftBtn.frame = CGRectMake(0, 0, 30, 30);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"itemBack"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBarBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    [self setNavigationController];
    
}
- (void)setNavigationController{
    
    self.navigationItem.title = @"收款码";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}] ;
    
}
- (void)leftBarBtnClicked:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //    1240 1722
    //   int y = 1722 * kScreenWidth / 1240;
    self.qrImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 1722 * kScreenWidth / 1240)]                            ;
    UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(keepImageToLocal:)];
    self.qrImageView.userInteractionEnabled = YES;
    longTap.minimumPressDuration = 1;
    [self.qrImageView addGestureRecognizer:longTap];
    
    [self.view addSubview:self.qrImageView];
    
    
    [self requestDataForQR];
    // Do any additional setup after loading the view.
}

- (void)keepImageToLocal:(UILongPressGestureRecognizer *)gesture{
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        UIImageWriteToSavedPhotosAlbum(self.qrImageView.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    }
}
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if(!error) {
        [MBProgressHUD showSuccess:@"图片保存成功"];
    }else{
        [MBProgressHUD showSuccess:@"图片保存失败"];
    }
}

- (void)requestDataForQR{
    
    NSDictionary *partner = @{
                              @"id": KUSERSHOPID
                              };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html", nil];
    
    [manager POST:[NSString stringWithFormat:@"%@/qr/createQrCode",HXEORDER] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //   NSLog(@"%@",responseObject);
        if ([responseObject[@"status"] integerValue] == 200) {
            [self.qrImageView sd_setImageWithURL:responseObject[@"data"]];
        }else{
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
