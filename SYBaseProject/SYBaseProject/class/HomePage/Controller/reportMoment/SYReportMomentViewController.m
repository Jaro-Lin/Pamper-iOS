//
//  SYReportMomentViewController.m
//  SYBaseProject
//
//  Created by sy on 2020/3/30.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "SYReportMomentViewController.h"
#import "SYTopicListViewController.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import "SYCustomCollectionViewCell.h"

#import <CoreLocation/CoreLocation.h>//引入Corelocation框架
#import "SYHomeThemeModel.h"
#import "UITextView+YLTextView.h"
#import "SYLocationModel.h"

#import "YBImageBrowser.h"
#import "YBIBVideoData.h"

#define KImageWidth (KScreenWidth-KAdaptW(20)*4)

typedef NS_ENUM(NSInteger,imageVideoChoose) {
    imageVideoChoose_images,
    imageVideoChoose_video
};

@interface SYReportMomentViewController ()<TZImagePickerControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,CLLocationManagerDelegate,SYTopicListViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *momentContentTF;
@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;
@property(nonatomic, strong) UICollectionViewFlowLayout *layout;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoCollectionViewHeight;

@property (weak, nonatomic) IBOutlet UIButton *topicChooseBtn;
@property (weak, nonatomic) IBOutlet UILabel *topicLB;
@property (weak, nonatomic) IBOutlet UIButton *locationChooseBtn;
@property (weak, nonatomic) IBOutlet UILabel *locationLB;
@property (weak, nonatomic) IBOutlet UIButton *photoChooseBtn;
@property (weak, nonatomic) IBOutlet UIButton *momentSendBtn;
@property(nonatomic, strong)  TZImagePickerController *imagePickController;
@property(nonatomic, strong) NSArray *imagesArr;
@property(nonatomic, strong) NSArray<PHAsset*> *imagesAssetsArr;

@property (nonatomic,assign) imageVideoChoose chooseType;
@property(nonatomic, strong) PHAsset *assetVideo;
@property(nonatomic, strong) UIImage *videoCoverImage;

@property (nonatomic, strong) CLLocationManager *locationManager;//设置manager
@property(nonatomic, strong) SYHomeThemeModel *momentModel;
@property(nonatomic, strong) SYLocationModel *locationModel;
@property(nonatomic, strong) NSMutableArray *upLoadImages;
@end

@implementation SYReportMomentViewController
- (TZImagePickerController *)imagePickController{
    if (!_imagePickController) {
        
        _imagePickController = [[TZImagePickerController alloc]initWithMaxImagesCount:6 delegate:self];//设置多选最多支持的最大数量，设置代理
        _imagePickController.allowTakePicture = YES;//允许出现拍摄相机
        _imagePickController.sortAscendingByModificationDate = NO;
        //           _imagePickController.allowPickingVideo = NO;//不能选择视频
        _imagePickController.showSelectedIndex = YES;
        _imagePickController.modalPresentationStyle = UIModalPresentationFullScreen;
        
    }
    return _imagePickController;
}
- (NSMutableArray *)upLoadImages{
    if (!_upLoadImages) {
        _upLoadImages = [[NSMutableArray alloc]init];
    }
    return _upLoadImages;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"发布动态";
    self.view.backgroundColor = [UIColor whiteColor];
    self.momentModel = [[SYHomeThemeModel alloc]init];
    self.locationModel = [[SYLocationModel alloc]init];
    
    self.layout = [[UICollectionViewFlowLayout alloc]init];
    self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.layout.itemSize = CGSizeMake(KImageWidth/3.0, KImageWidth/3.0);
    
    self.photoCollectionView.collectionViewLayout = self.layout;
    self.photoCollectionView.delegate = self;
    self.photoCollectionView.dataSource = self;
    [self.photoCollectionView registerClass:[SYCustomCollectionViewCell class] forCellWithReuseIdentifier:@"SYCustomCollectionViewCell"];
    
    self.momentContentTF.placeholder = @"说点什么吧";
    
}
#pragma mark -- UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imagesArr.count>0?self.imagesArr.count:1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SYCustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SYCustomCollectionViewCell" forIndexPath:indexPath];
    
    if (self.imagesArr.count >0) {//图片
        cell.img.image =self.imagesArr[indexPath.row];
    }else{//视频
        if (self.assetVideo) {
            cell.img.image =self.videoCoverImage;
            cell.playBtn.hidden = NO;
        }
    }
    return cell;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);//分别为上、左、下、右
}

//这个是两行cell之间的最小间距（上下行cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return KAdaptW(20);
}
//两个cell之间的最小间距间距（同一行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return KAdaptW(10);
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *datas = [NSMutableArray array];
    if (self.chooseType == imageVideoChoose_images) {
        
        for (int i = 0; i <self.momentModel.images.count; i ++) {
            
            YBIBImageData *data = [YBIBImageData new];
            data.imagePHAsset = self.imagesAssetsArr[i];
            [datas addObject:data];
        }
    }else{
        YBIBVideoData *data = [YBIBVideoData new];
        data.videoPHAsset =self.assetVideo;
        [datas addObject:data];
    }
    
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = datas;
    browser.currentPage = indexPath.row;
    // 只有一个保存操作的时候，可以直接右上角显示保存按钮
    browser.defaultToolViewHandler.topView.operationType = YBIBTopViewOperationTypeSave;
    [browser show];
    
    
}

- (IBAction)photoChooseAction:(UIButton *)sender {
    
    //设置选择图片还是视频
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.layout.itemSize = CGSizeMake(KImageWidth, (KImageWidth/3.0)*2);
        self.photoCollectionView.collectionViewLayout = self.layout;
        self.chooseType = imageVideoChoose_video;
        self.imagePickController.allowPickingImage = NO;
        self.imagePickController.allowPickingVideo = YES;
        [self presentViewController:self.imagePickController animated:YES completion:nil];//跳转
    }];
    
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.chooseType = imageVideoChoose_images;
        self.layout.itemSize = CGSizeMake(KImageWidth/3.0, KImageWidth/3.0);
        self.photoCollectionView.collectionViewLayout = self.layout;

        self.imagePickController.allowPickingVideo = NO;
        self.imagePickController.allowPickingImage = YES;
        self.imagePickController.maxImagesCount = 9;
        [self presentViewController:self.imagePickController animated:YES completion:nil];//跳转
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了取消");
    }];
    [actionSheet addAction:cameraAction];
    [actionSheet addAction:photoAction];
    [actionSheet addAction:cancelAction];
    
    [self presentViewController:actionSheet animated:YES completion:nil];

}

- (IBAction)topicChooseAction:(UIButton *)sender {
    
    SYTopicListViewController *topicList = [[SYTopicListViewController alloc]init];
    topicList.delegate = self;
    topicList.isTopicChoosed = YES;
    [self.navigationController pushViewController:topicList animated:YES];
    
}
- (IBAction)locationChooseAction:(id)sender {
    [self locate];//获取位置信息
}
//发布操作
- (IBAction)sendMomentAction:(UIButton *)sender {
    /**HTTP
     
     序号    参数名    说明    必填    类型    示例    详情
     1    token        是    [string]
     2    content    文本内容 (单发招聘视频-可为空)    是    [string]
     3    theme_id    话题ID 无附属话题上传 (必须) 无话题为0    是    [string]
     4    post_city    发布城市 (必须-可为空)    是    [string]
     5    longitude    经度 (必须)    是    [string]
     6    latitude    纬度 (必须)    是    [string]
     7    subsidiary_type    附件类型：null - image - video (必须)    是    [string]
     8    address    图片地址-数组 字符串英问逗号（123.png,321.png） (必须-可为空)    是    [string]
     */
    
    if (kStringIsEmpty(self.momentContentTF.text)) {
        [self.view makeToast:@"请说点什么..." duration:1.5f position:CSToastPositionCenter];
        return;
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:self.momentContentTF.text forKey:@"content"];
    
    if (!kStringIsEmpty(self.momentModel.theme_id)) {
        [params setObject:self.momentModel.theme_id forKey:@"theme_id"];
    }else{
        [params setObject:@"0" forKey:@"theme_id"];
    }
    
    //    if (!kStringIsEmpty(self.locationModel.placeMark.locality) && self.locationModel.currentLocation) {
    [params setObject:self.locationModel.placeMark.subLocality ?:@"" forKey:@"post_city"];
    [params setObject:[NSString stringWithFormat:@"%lf",self.locationModel.currentLocation.coordinate.longitude] forKey:@"longitude"];
    [params setObject:[NSString stringWithFormat:@"%lf",self.locationModel.currentLocation.coordinate.latitude] forKey:@"latitude"];
    //    }
    [params setObject:(self.chooseType == imageVideoChoose_images ?@"image":@"video") forKey:@"subsidiary_type"];
    
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hub.label.text = (self.chooseType == imageVideoChoose_images?@"图片上传中...":@"视频上传中...");
    
    dispatch_group_t group = dispatch_group_create();
    if (self.chooseType == imageVideoChoose_images) {
        
        for (int i = 0 ; i <self.imagesArr.count; i ++) {
            
            dispatch_group_enter(group);
            
            if (self.upLoadImages.count >0) {
                dispatch_group_leave(group);
                break;
            }
            hub.label.text = @"图片上传中...";
            dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [ShareRequest uploadImg:self.imagesArr[i] appendURL:@"/user/about_user/avatar" IsShowHud:NO IsInteract:NO Complete:^(NSDictionary *dic) {
                    
                    if([dic[@"code"]integerValue] ==1) {
                        [self.view makeToast:dic[@"message"]];
                        NSString *imageUrl =dic[@"data"][@"img"];
                        //[NSString stringWithFormat:@"%@%@",dic[@"data"][@"server"],dic[@"data"][@"img"]];
                        [self.upLoadImages addObject:imageUrl];
                        dispatch_group_leave(group);
                    }
                    
                } Fail:^(NSError *error) {
                    dispatch_group_leave(group);
                }];
            });
        }
        
    }else if (self.chooseType == imageVideoChoose_video && self.momentModel.video){
        //        2020/04/52574202004211436485137.mp4
        hub.label.text = @"视频上传中...";
        
        dispatch_group_enter(group);
        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [ShareRequest shareRequestUploadFileappendURL:@"/post/send/upload" parameters:@{@"token":[MSUserInformation sharedManager].user.token,@"type":@"video"} filePath:self.momentModel.video[0] fileName:@"file" IsShowHud:NO IsInteract:NO progress:^(NSProgress *progress) {
                //                hub.progressObject = progress;
            } Complete:^(NSDictionary *dic) {
                
                if([dic[@"code"]integerValue] ==1) {
                    NSString *imageUrl =dic[@"data"][@"img"];
                    //[NSString stringWithFormat:@"%@%@",dic[@"data"][@"server"],dic[@"data"][@"img"]];
                    [self.upLoadImages addObject:imageUrl];
                    dispatch_group_leave(group);
                }
                
            } Fail:^(NSError *error) {
                
                dispatch_group_leave(group);
            }];
            
        });
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hub.mode = MBProgressHUDModeDeterminate;
        hub.label.text = @"动态发布中...";
        
        [params setObject:[self.upLoadImages componentsJoinedByString:@","] forKey:@"address"];
        [ShareRequest shareRequestDataWithAppendURL:@"/post/send/send" Params:params IsShowHud:YES IsInteract:NO Complete:^(NSDictionary *dic) {
            [hub hideAnimated:YES];
            [self.view makeToast:@"发布成功" duration:1.5f position:CSToastPositionCenter];
            [self.navigationController popViewControllerAnimated:YES];
            
        } Fail:^(NSError *error) {
            [hub hideAnimated:YES];
            [self.view makeToast:@"发布失败" duration:1.5f position:CSToastPositionCenter];
        }];
        
    });
    
}

#pragma mark -- TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    //        [[PHImageManager defaultManager] requestImageForAsset:phAsset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
    //
    //                   NSURL * url = [info objectForKey:@"PHImageFileURLKey"];
    //
    //               }];
    self.imagesArr = photos;
    self.momentModel.images = photos;
    self.imagesAssetsArr = assets;
    [self.photoCollectionView reloadData];
    
}
-(void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(PHAsset *)asset{
    
    self.assetVideo = asset;
    self.videoCoverImage = coverImage;
    [self.photoCollectionView reloadData];
    
    [[TZImageManager manager] getVideoOutputPathWithAsset:asset presetName:AVAssetExportPresetHighestQuality success:^(NSString *outputPath) {
        // NSData *data = [NSData dataWithContentsOfFile:outputPath];
        NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
        // Export completed, send video here, send by outputPath or NSData
        // 导出完成，在这里写上传代码，通过路径或者通过NSData上传
        self.momentModel.video = @[outputPath];
        
    } failure:^(NSString *errorMessage, NSError *error) {
        NSLog(@"视频导出失败:%@,error:%@",errorMessage, error);
    }];
    
}



#pragma mark -- 主题 SYTopicListViewControllerDelegate
- (void)topicSelected:(SYTopicModel *)topic{
    self.topicLB.text = topic.theme_title;
    
    self.momentModel.theme_title = topic.theme_title;
    self.momentModel.theme_id = topic.ID;
}
#pragma mark -- 定位操作
- (void)locate {
    if ([CLLocationManager locationServicesEnabled]) {//监测权限设置
        
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.delegate = self;//设置代理
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;//设置精度
        self.locationManager.distanceFilter = 1000.0f;//距离过滤
        [self.locationManager requestAlwaysAuthorization];//位置权限申请
        [self.locationManager startUpdatingLocation];//开始定位
    }
}
#pragma mark location代理
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还未开启定位服务，是否需要开启？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *queren = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *setingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication]openURL:setingsURL];
    }];
    [alert addAction:cancel];
    [alert addAction:queren];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [self.locationManager stopUpdatingLocation];//停止定位
    //地理反编码
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    self.locationModel.currentLocation = currentLocation;
    
    //当系统设置为其他语言时，可利用此方法获得中文地理名称
    NSMutableArray
    *userDefaultLanguages = [[NSUserDefaults standardUserDefaults]objectForKey:@"AppleLanguages"];
    // 强制 成 简体中文
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"zh-hans", nil]forKey:@"AppleLanguages"];
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = placemarks[0];
            self.locationModel.placeMark = placeMark;
            
            NSString *city = placeMark.locality;
            if (!city) {
                self.locationLB.text = @"⟳定位获取失败,点击重试";
                self.momentModel.city = @"";
            } else {
                
                self.locationLB.text =[NSString stringWithFormat:@"定位:%@%@%@%@",placeMark.locality, placeMark.subLocality, placeMark.thoroughfare,placeMark.name];//获取当前城市
                self.momentModel.city = [NSString stringWithFormat:@"定位:%@%@%@%@",placeMark.locality, placeMark.subLocality, placeMark.thoroughfare,placeMark.name];
            }
            
        } else if (error == nil && placemarks.count == 0 ) {
            
        } else if (error) {
            self.locationLB.text = @"⟳定位获取失败,点击重试";
            self.momentModel.city = @"";
        }
        // 还原Device 的语言
        [[NSUserDefaults
          standardUserDefaults] setObject:userDefaultLanguages
         forKey:@"AppleLanguages"];
    }];
}

/*****************上传图片--文件路径**************/
//    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"A24" ofType:@"jpg"];
//    [ShareRequest shareRequestUploadFileappendURL:@"/post/send/upload" parameters:@{@"token":[MSUserInformation sharedManager].user.token,@"type":@"image"} filePath:filePath fileName:@"file" IsShowHud:NO IsInteract:NO progress:^(NSProgress *progress) {
//        hub.progressObject = progress;
//    } Complete:^(NSDictionary *dic) {
//        [hub hideAnimated:YES];
//    } Fail:^(NSError *error) {
//        [hub hideAnimated:YES];
//    }];
@end
