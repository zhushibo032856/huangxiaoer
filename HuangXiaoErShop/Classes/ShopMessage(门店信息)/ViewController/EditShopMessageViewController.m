//
//  EditShopMessageViewController.m
//  HuangXiaoErShop
//
//  Created by apple on 2018/8/7.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "EditShopMessageViewController.h"
#import "ManagerModel.h"

@interface EditShopMessageViewController ()<UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UIView *addOneView;
@property (nonatomic, strong) UIView *addTwoView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UITextField *nameTF;
@property (nonatomic, strong) UITextField *addressTF;
@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UITextView *contentTextView;
@property (nonatomic, strong) UIButton *keepButton;

@property (nonatomic, strong) NSString *uploadImageUrl;

@end

@implementation EditShopMessageViewController

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}

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
    
    self.navigationItem.title = @"编辑信息";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}] ;
}
- (void)leftBarBtnClicked:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColor(240, 240, 240);
    
    [self creatAutoLayout];
    // Do any additional setup after loading the view.
}

- (void)creatAutoLayout{
    
    self.addOneView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, 130)];
    self.addOneView.backgroundColor = [UIColor whiteColor];
    self.addOneView.layer.masksToBounds = YES;
    self.addOneView.layer.cornerRadius = 10;
    [self.view addSubview:self.addOneView];
    
    UILabel *messageLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 15)];
    messageLable.text = @"基础信息";
    messageLable.font = [UIFont systemFontOfSize:13];
    messageLable.textColor = kColor(153, 153, 153);
    [self.addOneView addSubview:messageLable];
    
    UILabel *imageLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, 100, 30)];
    imageLable.text = @"门店头像";
    imageLable.font = [UIFont systemFontOfSize:16];
    [self.addOneView addSubview:imageLable];
    
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.addOneView.right - 80, 10, 60, 60)];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(uploadImage)];
    [self.imageView addGestureRecognizer:tapGesture];
    self.imageView.userInteractionEnabled = YES;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.model.logoImage] placeholderImage:[UIImage imageNamed:@"userName"]];
    [self.addOneView addSubview:self.imageView];
    
    UILabel *lineLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, kScreenWidth - 40, 0.5)];
    lineLable.backgroundColor = kColor(240, 240, 240);
    [self.addOneView addSubview:lineLable];
    
    UILabel *shopName = [[UILabel alloc]initWithFrame:CGRectMake(10, 90, 100, 30)];
    shopName.text = @"门店名";
    shopName.font = [UIFont systemFontOfSize:16];
    [self.addOneView addSubview:shopName];
    
    self.nameTF = [[UITextField alloc]initWithFrame:CGRectMake(kScreenWidth * 0.3, 90, kScreenWidth * 0.6, 30)];
    self.nameTF.textColor = kColor(102, 102, 102);
    self.nameTF.font = [UIFont systemFontOfSize:16];
    self.nameTF.text = self.model.shopSign;
    self.nameTF.textAlignment = NSTextAlignmentRight;
    [self.addOneView addSubview:self.nameTF];
    
    self.addTwoView = [[UIView alloc]initWithFrame:CGRectMake(10, 150, kScreenWidth - 20, 280)];
    self.addTwoView.backgroundColor = [UIColor whiteColor];
    self.addTwoView.layer.masksToBounds = YES;
    self.addTwoView.layer.cornerRadius = 10;
    [self.view addSubview:self.addTwoView];
    
    UILabel *introduceLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 20)];
    introduceLable.text = @"店铺介绍";
    introduceLable.font = [UIFont systemFontOfSize:13];
    introduceLable.textColor = kColor(153, 153, 153);
    [self.addTwoView addSubview:introduceLable];
    
    UILabel *addressLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, 100, 30)];
    addressLable.text = @"地址";
    addressLable.font = [UIFont systemFontOfSize:16];
    [self.addTwoView addSubview:addressLable];
    
    self.addressTF = [[UITextField alloc]initWithFrame:CGRectMake(kScreenWidth * 0.15, 40, kScreenWidth * 0.75, 30)];
    self.addressTF.textColor = kColor(102, 102, 102);
    self.addressTF.font = [UIFont systemFontOfSize:14];
    self.addressTF.textAlignment = NSTextAlignmentRight;
    self.addressTF.text = self.model.address;
    [self.addTwoView addSubview:self.addressTF];
    
    for (int i = 0; i < 2; i ++) {
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(10, 40 * i + 75, kScreenWidth - 40, 0.5)];
        lable.backgroundColor = kColor(240, 240, 240);
        [self. addTwoView addSubview:lable];
    }
    
    
    UILabel *phoneLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, 100, 30)];
    phoneLable.text = @"商家电话";
    phoneLable.font = [UIFont systemFontOfSize:16];
    [self.addTwoView addSubview:phoneLable];
    
    self.phoneTF = [[UITextField alloc]initWithFrame:CGRectMake(kScreenWidth * 0.5, 80, kScreenWidth * 0.4, 30)];
    self.phoneTF.textColor = kColor(102, 102, 102);
    self.phoneTF.font = [UIFont systemFontOfSize:16];
    self.phoneTF.delegate = self;
    self.phoneTF.textAlignment = NSTextAlignmentRight;
    self.phoneTF.text = self.model.phone;
    [self.addTwoView addSubview:self.phoneTF];
    
    UILabel *noticeLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 120, 100, 30)];
    noticeLable.text = @"公告";
    noticeLable.font = [UIFont systemFontOfSize:16];
    [self.addTwoView addSubview:noticeLable];
    
    self.contentTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 150, kScreenWidth - 40, 100)];
    self.contentTextView.text = self.model.data3;
    self.contentTextView.textColor = kColor(102, 102, 102);
    self.contentTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    self.contentTextView.keyboardType = UIKeyboardTypeDefault;
    self.contentTextView.font = [UIFont systemFontOfSize:15];
    //   self.contentTextView.delegate = self;
    [self.addTwoView addSubview:self.contentTextView];
    
    self.keepButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.keepButton.layer.cornerRadius = 25;
    self.keepButton.layer.masksToBounds = YES;
    self.keepButton.frame = CGRectMake(30, CGRectGetMaxY(self.addTwoView.frame) + 15, kScreenWidth - 60, 50);
    [self.keepButton setTintColor:[UIColor blackColor]];
    [self.keepButton setTitle:@"保存" forState:UIControlStateNormal];
    self.keepButton.backgroundColor = kColor(255, 210, 0);
    self.keepButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.keepButton addTarget:self action:@selector(changeMessage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.keepButton];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
    
    //    //注册键盘弹出通知
    //    [[NSNotificationCenter defaultCenter] addObserver:self
    //                                             selector:@selector(keyboardWillShow:)
    //                                                 name:UIKeyboardWillShowNotification
    //                                               object:nil];
    //    //注册键盘隐藏通知
    //    [[NSNotificationCenter defaultCenter] addObserver:self
    //                                             selector:@selector(keyboardWillHide:)
    //                                                 name:UIKeyboardWillHideNotification
    //                                               object:nil];
}

//键盘弹出后将视图向上移动
-(void)keyboardWillShow:(NSNotification *)note
{
    NSDictionary *info = [note userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    //目标视图UITextField
    CGRect frame = self.contentTextView.frame;
    int y = frame.origin.y + frame.size.height - (self.view.frame.size.height - keyboardSize.height);
    NSLog(@"%d",y);
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    if(y > 0)
    {
        self.view.frame = CGRectMake(0, -y, self.view.frame.size.width, self.view.frame.size.height);
    }
    [UIView commitAnimations];
}
//键盘隐藏后将视图恢复到原始状态
-(void)keyboardWillHide:(NSNotification *)note
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame =CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [UIView commitAnimations];
}
-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer{
    [self.view endEditing:YES];
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (_phoneTF) {
        return NO;
    }
    return YES;
}


/** 上传图片操作 */
- (void)uploadImage{
    
    UIAlertController *aler = [UIAlertController alertControllerWithTitle:@"选择图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    // 从相册选取
    UIAlertAction *album = [UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
        picker.allowsEditing = YES;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    }];
    
    // 从相机选取
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
        
        picker.allowsEditing = YES;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [aler addAction:cancel];
    [aler addAction:album];
    [aler addAction:camera];
    [self presentViewController:aler animated:YES completion:nil];
    
}
/** 选择图片结束代理方法 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (image){
        // 压缩图片质量
        UIImage *newImage = [CommonClass imageCompressForWidth:image targetWidth:2 * kScreenWidth];
        [self uploadUserPortraitToServerWithHeaderImg:newImage];
    } else {
        [MBProgressHUD showError:@"图片选择失败"];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}

/**
 上传图像至服务器
 
 @param portrait 用户选择的照片
 */
- (void)uploadUserPortraitToServerWithHeaderImg:(UIImage *)portrait {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *imageName = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg",imageName];
    NSData *imageData = UIImageJPEGRepresentation(portrait, 1.0f);
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"正在上传图片...";
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"image/jpeg", @"image/png",@"text/json",@"text/plain", nil];
    [manager POST:[NSString stringWithFormat:@"%@/appimage/image/uploadoss",HXECOMMEN] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imageData name:@"uploadFile" fileName:fileName mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hideAnimated:YES];
        self.uploadImageUrl = responseObject[@"url"];
        //     NSLog(@"%@",self.uploadImageUrl);
        
        if (!self.uploadImageUrl) {
            [MBProgressHUD showError:@"上传图片失败"];
            return ;
        }
        
        [self.imageView setImage:portrait];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //      NSLog(@"%@",error);
        [hud hideAnimated:YES];
    }];
}

- (void)changeMessage{
    
    if (kStringIsEmpty(self.uploadImageUrl)){
        [self requestDataToChagneMessageWithImageUrl:self.model.logoImage ShopName:self.nameTF.text ShopAddress:self.addressTF.text ShopContent:self.contentTextView.text];
    }else{
        [self requestDataToChagneMessageWithImageUrl:self.uploadImageUrl ShopName:self.nameTF.text ShopAddress:self.addressTF.text ShopContent:self.contentTextView.text];
    }
}

- (void)requestDataToChagneMessageWithImageUrl:(NSString *)imageUrl
                                      ShopName:(NSString *)shopName
                                   ShopAddress:(NSString *)shopAddress
                                   ShopContent:(NSString *)shopContent
{
    
    NSDictionary *partner = @{
                              @"address": shopAddress,
                              @"data3": shopContent,
                              @"logoImage": imageUrl,
                              @"shopSign": shopName,
                              @"token": KUSERID,
                              @"id": KUSERSHOPID
                              };
    //   NSLog(@"%@",partner);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"image/jpeg", @"image/png",@"text/json",@"text/plain", nil];
    [manager POST:[NSString stringWithFormat:@"%@/appcommercial/update",HXECOMMEN] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //     NSLog(@"%@",responseObject);
        
        if ([responseObject[@"status"] integerValue] == 200) {
            [MBProgressHUD showSuccess:responseObject[@"msg"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"notiEdit" object:nil];
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
