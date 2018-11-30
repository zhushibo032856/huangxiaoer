//
//  FoodEditViewController.m
//  HXEshop
//
//  Created by apple on 2018/3/28.
//  Copyright © 2018年 aladdin. All rights reserved.
//

#import "FoodEditViewController.h"
#import "BRTextField.h"
#import "LeftDataModel.h"
#import "RightDataModel.h"
#import "DishesManagerViewController.h"

@interface FoodEditViewController ()<UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, strong) UITextField *nameTF;//菜品名称
@property (nonatomic, strong) UITextField *priceTF;//优惠价格
@property (nonatomic, strong) UITextField *activeTF;//真实价格
@property (nonatomic, strong) BRTextField *cateGoryTF;//分类
@property (nonatomic, strong) UIImageView *foodImage;//图片
@property (nonatomic, strong) UITextField *packTF;//餐盒费

@property (nonatomic, strong) UIButton *keepButton;

@property (nonatomic, strong) NSString *uploadImageUrl;

@property (nonatomic, strong) NSMutableDictionary *dic;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UIView *firstView;

@end

@implementation FoodEditViewController

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}

- (NSMutableDictionary *)dic{
    if (!_dic) {
        _dic = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _dic;
}

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
    leftBtn.frame = CGRectMake(0, 0, 30, 30);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"itemBack"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBarBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    rightBtn.frame = CGRectMake(0, 0, 40, 40);
    [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    [rightBtn setTintColor:[UIColor whiteColor]];
    [rightBtn addTarget:self action:@selector(KeepButton:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    
    [self setNavigationController];
    
}
- (void)setNavigationController{
    
 //   [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"backcolor"] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationItem.title = @"商品编辑";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}] ;
    
}
- (void)leftBarBtnClicked:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    RightDataModel *model = self.dataSource[self.index];
    self.foodImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth - 90, 5, 60, 60)];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(uploadImage)];
    [self.foodImage addGestureRecognizer:tapGesture];
    self.foodImage.userInteractionEnabled = YES;
    
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.imageUrl]];
//    [self.foodImage setImage:[UIImage imageWithData:data]];
    [self.foodImage sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:[UIImage imageNamed:@"userName"]];
    [_firstView addSubview:self.foodImage];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColor(240, 240, 240);
    
    UILabel *messageLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 80, 30)];
    messageLable.text = @"基本信息";
    [self.view addSubview:messageLable];
    
    _firstView = [[UIView alloc]initWithFrame:CGRectMake(10, 50, kScreenWidth - 20, 120)];
    _firstView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_firstView];
    
    UILabel *imageLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 100, 30)];
    imageLable.text = @"菜品图片";
    [_firstView addSubview:imageLable];
    
    RightDataModel *model = self.model;
//    self.foodImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth - 80, 10, 50, 50)];
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(uploadImage)];
//    [self.foodImage addGestureRecognizer:tapGesture];
//    self.foodImage.userInteractionEnabled = YES;
    
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.imageUrl]];
//    [self.foodImage setImage:[UIImage imageWithData:data]];
//    [firstView addSubview:self.foodImage];
    
    UILabel *lineLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, kScreenWidth - 40, 1)];
    lineLable.backgroundColor = kColor(240, 240, 240);
    [_firstView addSubview:lineLable];
    
    UILabel *nameLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, 100, 30)];
    nameLable.text = @"菜品名称";
    [_firstView addSubview:nameLable];
    
    self.nameTF = [[UITextField alloc]initWithFrame:CGRectMake(kScreenWidth * 0.6, 80, kScreenWidth * 0.3, 30)];
    self.nameTF.text = model.name;
    self.nameTF.textAlignment = NSTextAlignmentRight;
    self.nameTF.font = [UIFont systemFontOfSize:15];
    [_firstView addSubview:self.nameTF];
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(20, 180, kScreenWidth - 40, 30)];
    lable.text = @"菜品规格";
    [self.view addSubview:lable];
    
    UIView *twoView = [[UIView alloc]initWithFrame:CGRectMake(10, 220, kScreenWidth - 20, 200)];
    twoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:twoView];
    
    UILabel *priceLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 30)];
    priceLable.text = @"原定价";
    [twoView addSubview:priceLable];
    
    self.priceTF = [[UITextField alloc]initWithFrame:CGRectMake(kScreenWidth * 0.5, 10, kScreenWidth * 0.4, 30)];
    self.priceTF.text = [NSString stringWithFormat:@"%@",model.activityPrice];
    self.priceTF.textAlignment = NSTextAlignmentRight;
    [twoView addSubview:self.priceTF];
    
    UILabel *lineLableTwo = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, kScreenWidth - 40, 1)];
    lineLableTwo.backgroundColor = kColor(240, 240, 240);
    [twoView addSubview:lineLableTwo];
    
    UILabel *activeLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 60, kScreenWidth * 0.6, 30)];
    activeLable.text = @"优惠价";
    [twoView addSubview:activeLable];
    
    self.activeTF = [[UITextField alloc]initWithFrame:CGRectMake(kScreenWidth * 0.5, 60, kScreenWidth * 0.4, 30)];
    self.activeTF.textAlignment = NSTextAlignmentRight;
    self.activeTF.text = [NSString stringWithFormat:@"%@",model.sellPrice];
    [twoView addSubview:self.activeTF];
    
    UILabel *lineLableThree = [[UILabel alloc]initWithFrame:CGRectMake(10, 100, kScreenWidth - 40, 1)];
    lineLableThree.backgroundColor = kColor(240, 240, 240);
    [twoView addSubview:lineLableThree];
    
    UILabel *categoryLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 110, 100, 30)];
    categoryLable.text = @"分类";
    [twoView addSubview:categoryLable];
    
    
    
    [self setupCategoryTF:twoView];
    
    for (int i = 0; i < self.cateDataArr.count; i ++) {
        LeftDataModel *leftModel = self.cateDataArr[i];
        if (model.tb_category_categoryId == leftModel.id) {
            self.cateGoryTF.text = leftModel.name;
        }
    }
    [twoView addSubview:self.cateGoryTF];
    
    UILabel *lineLableFour = [[UILabel alloc]initWithFrame:CGRectMake(10, 150, kScreenWidth - 40, 1)];
    lineLableFour.backgroundColor = kColor(240, 240, 240);
    [twoView addSubview:lineLableFour];
    
    UILabel *packLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 160, 100, 30)];
    packLable.text = @"餐盒费";
    [twoView addSubview:packLable];
    
    self.packTF = [[UITextField alloc]initWithFrame:CGRectMake(kScreenWidth * 0.5, 160, kScreenWidth * 0.4, 30)];
    self.packTF.text = [NSString stringWithFormat:@"%@",model.packFee];
    self.packTF.textAlignment = NSTextAlignmentRight;
    [twoView addSubview:self.packTF];
    
    self.keepButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.keepButton.frame = CGRectMake(10, 430, kScreenWidth - 20, 40);
    [self.keepButton setTitle:@"删除" forState:UIControlStateNormal];
    [self.keepButton setTintColor:[UIColor redColor]];
    [self.keepButton addTarget:self action:@selector(deleateButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.keepButton setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.keepButton];
    
    [self requestData];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
    
    // Do any additional setup after loading the view.
}
-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer{
    [self.view endEditing:YES];
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
  //      NSLog(@"%@",self.uploadImageUrl);
        
        if (!self.uploadImageUrl) {
            [MBProgressHUD showError:@"上传图片失败"];
            return ;
        }
        
        [self.foodImage setImage:portrait];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [hud hideAnimated:YES];
    }];
    
}



- (BRTextField *)getTextField:(UIView *)view{
    
    BRTextField *textField = [[BRTextField alloc]initWithFrame:CGRectMake(kScreenWidth * 0.6, 110, kScreenWidth * 0.3, 30)];
    textField.backgroundColor = [UIColor clearColor];
    textField.font = [UIFont systemFontOfSize:15];
    textField.textColor = [UIColor lightGrayColor];
    textField.textAlignment = NSTextAlignmentRight;
    textField.delegate = self;
    [view addSubview:textField];
    return textField;
}
- (void)setupCategoryTF:(UIView *)view{
    if (!_cateGoryTF) {
        _cateGoryTF = [self getTextField:view];
        __weak typeof(self) weakSelf = self;
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0; i < _cateDataArr.count; i ++) {
            LeftDataModel *model = _cateDataArr[i];
            [arr addObject:model.name];
            [self.dic setValue:model.id forKey:model.name];
        }
        _cateGoryTF.tapAcitonBlock = ^{
            [BRStringPickerView showStringPickerWithTitle:@"商品分类" dataSource:arr defaultSelValue:nil isAutoSelect:YES resultBlock:^(id selectValue) {
                weakSelf.cateGoryTF.text = selectValue;
            }];
        };
    }
}


- (void)requestData{
    
    NSDictionary *partner = @{
                              @"token":KUSERID
                              };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    
    [manager POST:[NSString stringWithFormat:@"%@/appproduct/category/findall",HXECOMMEN] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
     //   NSLog(@"%@",responseObject);
        if ([responseObject[@"status"] integerValue] == 200) {
            NSArray *dataArr = responseObject[@"data"];
            for (NSDictionary *dic in dataArr) {
                LeftDataModel *model = [[LeftDataModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:model];
            }
        }else{
            [MBProgressHUD showError:@"请求数据失败"];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

- (void)KeepButton:(UIButton *)sender{

    RightDataModel *model = self.model;
  //  NSLog(@"%@",model.tb_category_categoryId);
    NSString *cateID= [self.dic objectForKey:self.cateGoryTF.text];
  //  NSLog(@"%@",cateID);
    if (kStringIsEmpty(self.nameTF.text) || kStringIsEmpty(model.imageUrl) || kStringIsEmpty(self.priceTF.text) || kStringIsEmpty(self.cateGoryTF.text) || kStringIsEmpty(self.activeTF.text)) {
        [MBProgressHUD showError:@"图片或者数据不能为空"];
    }else if (kStringIsEmpty(self.uploadImageUrl)) {
        
        [self requsetDataUploadImageUrl:model.imageUrl Name:self.nameTF.text Price:self.priceTF.text activePrice:self.activeTF.text CateGoryID:cateID FoodID:model.id packFee:self.packTF.text];
        
    }else{
       
        [self requsetDataUploadImageUrl:self.uploadImageUrl Name:self.nameTF.text Price:self.priceTF.text activePrice:self.activeTF.text CateGoryID:cateID FoodID:model.id packFee:self.packTF.text];
        
    }
}

/** 商品编辑请求 */
- (void)requsetDataUploadImageUrl:(NSString *)imageUrl
                             Name:(NSString *)name
                            Price:(NSString *)price
                      activePrice:(NSString *)activePrice
                    CateGoryID:(NSString *)categoryID
                           FoodID:(NSInteger)foodId
                          packFee:(NSString *)packfee
{
    NSDictionary *partner = @{
                              @"id": @(foodId),
                              @"des": @"无",
                              @"packFee": packfee,
                              @"imageUrl": imageUrl,
                              @"name": name,
                              @"productCount": @"-1",
                              @"sellPrice": activePrice,
                              @"activityPrice": price,
                              @"tb_category_categoryId":categoryID,
                              @"token": KUSERID
                              };
   // NSLog(@"%@",partner);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    
    [manager POST:[NSString stringWithFormat:@"%@/appproduct/update",HXECOMMEN] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      //    NSLog(@"%@",responseObject);
        if ([responseObject[@"status"] integerValue] == 200) {
            [MBProgressHUD showSuccess:@"修改成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"notiEdit" object:nil];
        }else{
            [MBProgressHUD showError:@"修改失败"];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
        self.nameTF.text = @"";
        self.priceTF.text = @"";
        self.cateGoryTF.text = @"";
        self.activeTF.text = @"";
        self.packTF.text = @"";
        [self.foodImage setImage:[UIImage imageNamed:@"addBackImage"]];
}

- (void)deleateButton:(UIButton *)sender{
    
    RightDataModel *model = self.dataSource[self.index];
    [self delegateDataWithID:model.id];
    
}

- (void)delegateDataWithID:(NSInteger)Id{
    NSDictionary *partner = @{
                              @"id":@(Id),
                              @"token": KUSERID
                              };
    NSLog(@"%@",partner);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    
    [manager POST:[NSString stringWithFormat:@"%@/appproduct/delete",HXECOMMEN] parameters:partner progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"status"] integerValue] == 200) {
            [MBProgressHUD showSuccess:@"删除成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"notiEdit" object:nil];
        }else{
            [MBProgressHUD showError:@"删除失败"];
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

