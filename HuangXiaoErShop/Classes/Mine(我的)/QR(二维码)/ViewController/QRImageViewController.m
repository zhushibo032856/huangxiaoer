//
//  QRImageViewController.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/8/7.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "QRImageViewController.h"
#import "QRModel.h"
#import "ImageModel.h"

@interface QRImageViewController ()

@property (nonatomic, strong) UIView *addView;
@property (nonatomic, strong) UIImageView *qrImageView;
@property (nonatomic, strong) UIButton *keepButton;

@end

@implementation QRImageViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    leftBtn.frame = CGRectMake(0, 0, 30, 30);;
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"itemBack"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBarBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    [self setNavigationController];
    
}
- (void)setNavigationController{

    self.navigationItem.title = @"店铺收款码";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}] ;
    
}
- (void)leftBarBtnClicked:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatAutoLayout];
  //  [self requestDataForQR];
    
    // Do any additional setup after loading the view.
}

- (void)creatAutoLayout{
    
    self.addView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    self.addView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.addView];
    
    UIImageView *shopImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 15, 20, 20)];
    [shopImage setImage:[UIImage imageNamed:@"ShopImage-1"]];
    [self.addView addSubview:shopImage];
    
    UILabel *nameLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxY(shopImage.frame) + 20, 15, 80, 20)];
    nameLable.text = @"店铺名称";
    nameLable.font = [UIFont systemFontOfSize:15];
    [self.addView addSubview:nameLable];
    
    UILabel *shopNameLable = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth * 0.4, 15, kScreenWidth * 0.56, 20)];
    shopNameLable.text = KUSERNAME;
    shopNameLable.font = [UIFont systemFontOfSize:15];
    shopNameLable.textAlignment = NSTextAlignmentRight;
    shopNameLable.textColor = kColor(210, 210, 210);
    [self.addView addSubview:shopNameLable];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 50, kScreenWidth - 30, 1)];
    lineView.backgroundColor = kColor(240, 240, 240);
    [self.view addSubview:lineView];
    
    UIImageView *machImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 65, 20, 20)];
    [machImage setImage:[UIImage imageNamed:@"machImage"]];
    [self.addView addSubview:machImage];
    
    UILabel *macheLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxY(shopImage.frame) + 20, 65, 80, 20)];
    macheLable.text = @"机具号";
    macheLable.font = [UIFont systemFontOfSize:15];
    [self.addView addSubview:macheLable];
    
    UILabel *machNameLable = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth * 0.4, 65, kScreenWidth * 0.5, 20)];
    machNameLable.text = self.model.machineNum;
    machNameLable.font = [UIFont systemFontOfSize:15];
    machNameLable.textAlignment = NSTextAlignmentRight;
    machNameLable.textColor = kColor(210, 210, 210);
    [self.addView addSubview:machNameLable];
    
    UIView *bachView = [[UIView alloc]initWithFrame:CGRectMake(0, 110, kScreenWidth, kScreenWidth * 1.0)];
    bachView.backgroundColor = kColor(240, 240, 240);
    [self.view addSubview:bachView];
    
    UILabel *messageLable = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxX(bachView.frame) + 10, kScreenWidth, 20)];
    messageLable.text = @"保存到手机本地后可自行打印";
    messageLable.font = [UIFont systemFontOfSize:14];
    messageLable.textColor = kColor(150, 150, 150);
    messageLable.textAlignment = NSTextAlignmentCenter;
    [bachView addSubview:messageLable];
    
  //  NSLog(@"%@",self.imageModel);
    
    self.qrImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth * 0.2 , 20, kScreenWidth * 0.6, 1722 * kScreenWidth * 0.6 / 1240)];
    NSString *string = self.model.machineNum;
 //   NSLog(@"%@",string);
    
    [_qrImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://hxefile.oss-cn-hangzhou.aliyuncs.com/qr/%@.png",string]]];
    
    [bachView addSubview:self.qrImageView];
    
    self.keepButton = [UIButton buttonWithType:UIButtonTypeSystem];
    if (iPhoneX) {
        self.keepButton.frame = CGRectMake(0, self.view.bottom - 50 - 86, kScreenWidth, 50);
    } else {
        self.keepButton.frame = CGRectMake(0, self.view.bottom - 50 - 64, kScreenWidth, 50);
    }
    [self.keepButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.keepButton setTintColor:kColor(255, 255, 255)];
    [self.keepButton setBackgroundColor:kColor(255, 210, 0)];
    [self.keepButton addTarget:self action:@selector(keepImageToLocal) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.keepButton];
    
    
    
}
- (void)keepImageToLocal{
    
    UIImageWriteToSavedPhotosAlbum(self.qrImageView.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    
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
        
           NSLog(@"%@",responseObject);
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
