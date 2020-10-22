//
//  BBUploadImageViewController.m
//  Biaobei
//
//  Created by 文亮 on 2019/9/6.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBUploadImageViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "BBOssUploadManager.h"

@interface BBUploadImageViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) UIView * underView;
@property (nonatomic, strong) UIImageView * selectedImageView;
@property (nonatomic, strong) UIImageView * photoImageView;
@property (nonatomic, strong) UILabel * tipSelectImageLabel;
@property (nonatomic, strong) UILabel * tipLabel;
@property (nonatomic, strong) UIButton * sureButton;
@property (nonatomic, strong) UIImagePickerController * imagePickerController;
@property (nonatomic, assign) BOOL isCamera;
@end

@implementation BBUploadImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"上传照片";
    [self prepareUI];
}

-(void)prepareUI {
    self.underView = [UIView new];
    self.underView.backgroundColor = [UIColor whiteColor];
    self.underView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(starttTakePhoto)];
    [self.underView addGestureRecognizer:tap];
    [self.view addSubview:self.underView];

    self.selectedImageView = [UIImageView new];
    self.selectedImageView.backgroundColor = [UIColor clearColor];
    [self.underView addSubview:self.selectedImageView];

    self.photoImageView = [UIImageView new];
    self.photoImageView.backgroundColor = [UIColor clearColor];
    self.photoImageView.image = [UIImage imageNamed:@"MIne_upLoad_photo"];
    [self.underView addSubview:self.photoImageView];

    self.tipSelectImageLabel = [UILabel new];
    self.tipSelectImageLabel.font = kFontRegularSize(16);
    self.tipSelectImageLabel.textColor = rgba(148, 153, 161, 1);
    self.tipSelectImageLabel.text = @"点击选取";
    self.tipSelectImageLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.tipSelectImageLabel];

    self.tipLabel = [UILabel new];
    self.tipLabel.font = kFontRegularSize(14);
    self.tipLabel.textColor = rgba(148, 153, 161, 1);
    self.tipLabel.text = @"备注：请上传营业执照等有效证件(图片支持JPG、PNG格式，大小不得超过5M)";
    self.tipLabel.numberOfLines = 2;
    self.tipLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self.view addSubview:self.tipLabel];

    self.sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.sureButton.backgroundColor = rgba(186, 186, 186, 1);
    self.sureButton.layer.masksToBounds = YES;
    self.sureButton.layer.cornerRadius = 27;
    self.sureButton.userInteractionEnabled = YES;
    [self.sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.sureButton];

    [self.underView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.right.mas_equalTo(-18);
        make.top.mas_equalTo(27);
        make.height.mas_equalTo(190);
    }];

    [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.underView.mas_centerX);
        make.top.mas_equalTo(62);
        make.height.mas_equalTo(38);
        make.width.mas_equalTo(43);
    }];

    [self.tipSelectImageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.photoImageView.mas_bottom).offset(14);
        make.centerX.equalTo(self.underView.mas_centerX);
        make.height.mas_equalTo(16);
    }];

    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.right.mas_equalTo(-24);
        make.top.equalTo(self.underView.mas_bottom).offset(15);
    }];

    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(54);
        make.bottom.mas_equalTo(-32);
    }];
    
    //
    if (self.upLoadImage) {
        if (self.upLoadImage.size.height/self.upLoadImage.size.width > 190.0/339) {
            self.selectedImageView.frame = CGRectMake((339 - (190.0 * (self.upLoadImage.size.width/self.upLoadImage.size.height)))/2.0, 0, 190.0 * (self.upLoadImage.size.width/self.upLoadImage.size.height),190.0);
        } else {
            self.selectedImageView.frame = CGRectMake(0, (190.0 - 339 * (self.upLoadImage.size.height/self.upLoadImage.size.width))/2.0,339,339 * (self.upLoadImage.size.height/self.upLoadImage.size.width));
        }
        self.selectedImageView.image = self.upLoadImage;
        [self checkButton];
    }
    
}

-(void)checkButton {
    self.sureButton.backgroundColor = rgba(37, 194, 155, 1);
    self.sureButton.userInteractionEnabled = YES;
    self.photoImageView.hidden = YES;
    self.tipSelectImageLabel.hidden = YES;
    
}

//上传图片文件到阿里云
-(void)sureButtonClick {
    [BBOssUploadManager sharedInstance].contentUrl = [NSString stringWithFormat:@"%@/%@",@"license",kAppCacheInfo.userId];
    
    [SVProgressHUD showWithStatus:@"正在上传..."];
    [[BBOssUploadManager sharedInstance] uploadImages:@[_selectedImageView.image] isAsync:YES callback:^(BOOL success, NSString * _Nonnull msg, NSArray<NSString *> * _Nonnull keys) {
        [SVProgressHUD dismiss];

        if (success) {
            NSString *imageUrl = keys[0];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showMessage:@"上传成功" block:^{
                    if (self.uploadImgBlock) {
                        self.uploadImgBlock(_selectedImageView.image,imageUrl);  //返回阿里云图片地址
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showMessage:@"上传失败"];
            });
        }
        
    }];

}

-(void)starttTakePhoto {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.imagePickerController) {
            self.imagePickerController = [[UIImagePickerController alloc]init];
            self.imagePickerController.navigationBar.translucent = NO;
            self.imagePickerController.delegate = self;
            self.isCamera = YES;
        }
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *camera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.isCamera = YES;
            [self checkCameraPermission];//检查相机权限
        }];
        UIAlertAction *album = [UIAlertAction actionWithTitle:@"选取照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.isCamera = NO;
            [self checkCameraPermission];//检查相册权限
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alert addAction:camera];
        [alert addAction:album];
        [alert addAction:cancel];
        alert.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:alert animated:YES completion:nil];
    });
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (image.size.height/image.size.width > 190.0/339) {
        self.selectedImageView.frame = CGRectMake((339 - (190.0 * (image.size.width/image.size.height)))/2.0, 0, 190.0 * (image.size.width/image.size.height),190.0);
    } else {
        self.selectedImageView.frame = CGRectMake(0, (190.0 - 339 * (image.size.height/image.size.width))/2.0,339,339 * (image.size.height/image.size.width));
    }
    self.selectedImageView.image = image;
    if (image) {
        [self checkButton];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Camera
- (void)checkCameraPermission {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                if (self.isCamera) {
                    [self alertCamear ];
                } else {
                    [self takePhoto];
                }

            }
        }];
    } else if (status == AVAuthorizationStatusDenied || status == AVAuthorizationStatusRestricted) {
        if (self.isCamera) {
            [self alertCamear ];
        } else {
            [self takePhoto];
        }
    } else {
        if (self.isCamera) {
            [self alertCamear ];
        } else {
            [self takePhoto];
        }
    }
}

- (void)alertCamear {
    //判断相机是否可用，防止模拟器点击【相机】导致崩溃
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
    } else {
        NSLog(@"不能使用模拟器进行拍照");
    }
}

- (void)takePhoto {
    //判断相机是否可用，防止模拟器点击【相机】导致崩溃
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
    } else {
        NSLog(@"不能使用模拟器进行拍照");
    }
}

- (void)selectAlbum {
    //判断相册是否可用
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
    }
}

- (void)alertAlbum {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请在设置中打开相册" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:cancel];
    self.imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alert animated:YES completion:nil];
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
