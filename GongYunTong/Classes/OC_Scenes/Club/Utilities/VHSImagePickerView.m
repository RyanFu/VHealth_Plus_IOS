//
//  VHSImagePickerView.m
//  GongYunTong
//
//  Created by pingjun lin on 2017/2/6.
//  Copyright © 2017年 vhs_health. All rights reserved.
//

#import "VHSImagePickerView.h"
#import "HUImagePickerViewController.h"

@interface VHSImagePickerView ()<UICollectionViewDelegate, UICollectionViewDataSource, HUImagePickerViewControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UICollectionView *photosView;

@property (nonatomic, strong) NSMutableArray *photos;

@end
const NSInteger PICKER_IMAGE_WIDTH = 150;    // 图片宽度
const NSInteger MAX_ALLOWED_COUNT = 6;      // 最多允许选中的图片数量
const NSInteger H_MAX_COUNT = 4;            // 一行最多显示数量
static NSString *reuseIdentifier = @"VHSImagePickerCollectionCell";

@implementation VHSImagePickerView

#pragma mark - override getter or setter method

- (NSMutableArray *)photos {
    if (!_photos) {
        _photos = [NSMutableArray arrayWithCapacity:MAX_ALLOWED_COUNT];
        
        MomentPhotoModel *model = [[MomentPhotoModel alloc] init];
        model.photoImage = [UIImage imageNamed:@"club_moment_photo_add"];
        model.imageType = VHSImagePickerOfImagePlaceHolderType;
        [_photos addObject:model];
    }
    return _photos;
}

#pragma mark - view lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor greenColor];
    
        CGFloat lineSpacing = 0.0;
        CGFloat interitemSpacing = 0.0;
        
        CGFloat collectionW = frame.size.width;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemLength = (collectionW - (H_MAX_COUNT-1) * interitemSpacing) / H_MAX_COUNT;
        layout.itemSize = CGSizeMake(itemLength, itemLength);
        
        layout.minimumLineSpacing = lineSpacing;
        layout.minimumInteritemSpacing = interitemSpacing;
        
        self.photosView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)
                                             collectionViewLayout:layout];
        self.photosView.backgroundColor = [UIColor whiteColor];
        self.photosView.showsVerticalScrollIndicator = NO;
        [self addSubview:self.photosView];
        
        // 注册collectionViewCell
        [self.photosView registerClass:[VHSImagePickerCollectionCell class] forCellWithReuseIdentifier:reuseIdentifier];
        
        self.photosView.delegate = self;
        self.photosView.dataSource = self;
    }
    return self;
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.photos count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    VHSImagePickerCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier
                                                                                   forIndexPath:indexPath];
    
    MomentPhotoModel *model = self.photos[indexPath.row];
    cell.moment = model;
    
    __weak typeof(self) weakSelf = self;
    cell.removeSelectedImageBlock = ^(){
        [weakSelf.photos removeObjectAtIndex:indexPath.row];
        
        MomentPhotoModel *model = [weakSelf.photos lastObject];
        
        if (model.imageType == VHSImagePickerOfImagePlaceHolderType) {
            [weakSelf.photos removeLastObject];
        }
        // 回调，将数据传父组件
        if (weakSelf.imagePickerCompletionHandler) weakSelf.imagePickerCompletionHandler(weakSelf.photos);
        
        if ([weakSelf.photos count] < MAX_ALLOWED_COUNT) {
            MomentPhotoModel *moment = [[MomentPhotoModel alloc] init];
            moment.photoImage = [UIImage imageNamed:@"club_moment_photo_add"];
            moment.imageType = VHSImagePickerOfImagePlaceHolderType;
            [weakSelf.photos addObject:moment];
        }
        
        [weakSelf.photosView reloadData];
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MomentPhotoModel *model = self.photos[indexPath.row];
    if (model.imageType == VHSImagePickerOfImagePhotoType || model.imageType == VHSImagePickerOfImageAlbumType) return;
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil
                                                                     message:nil
                                                              preferredStyle:UIAlertControllerStyleActionSheet];
    [self.fatherController presentViewController:alertVC animated:YES completion:nil];
    
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"拍照"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * _Nonnull action) {
                                                                CLog(@"拍照");
                                                                [self takePhoto];
                                                            }];
    [alertVC addAction:takePhotoAction];
    
    UIAlertAction *takeAlbumAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        HUImagePickerViewController *picker = [[HUImagePickerViewController alloc] init];
        picker.delegate = self;
        picker.maxAllowedCount = MAX_ALLOWED_COUNT - [self.photos count] + 1;
        picker.originalImageAllowed = YES; //想要获取高清图设置为YES,默认为NO
        
        [self.fatherController presentViewController:picker animated:YES completion:nil];
    }];
    [alertVC addAction:takeAlbumAction];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             CLog(@"取消");
                                                         }];
    [alertVC addAction:cancleAction];
}

#pragma mark - HUImagePickerViewControllerDelegate

- (void)imagePickerController:(HUImagePickerViewController *)picker didFinishPickingImagesWithInfo:(NSDictionary *)info{
    NSArray *thumbnailImages = info[kHUImagePickerOriginalImage];
    // 移除最后一张占位符图片
    [self.photos removeLastObject];
    
    for (UIImage *img in thumbnailImages) {
        MomentPhotoModel *model = [[MomentPhotoModel alloc] init];
        CGSize imgSize = img.size;
        model.photoImage = [VHSUtils image:img scaleToSize:CGSizeMake(PICKER_IMAGE_WIDTH, PICKER_IMAGE_WIDTH * imgSize.height / imgSize.width)];
        model.imageType = VHSImagePickerOfImageAlbumType;
        
        [self.photos addObject:model];
    }
    
    // 回调，将数据传父组件
    if (self.imagePickerCompletionHandler) self.imagePickerCompletionHandler(self.photos);
    
    if ([self.photos count] < MAX_ALLOWED_COUNT) {
        MomentPhotoModel *model = [[MomentPhotoModel alloc] init];
        model.photoImage = [UIImage imageNamed:@"club_moment_photo_add"];
        model.imageType = VHSImagePickerOfImagePlaceHolderType;
        [self.photos addObject:model];
    }
    [self.photosView reloadData];
    //    _images = info[kHUImagePickerThumbnailImage];
    //    _originalImages = info[kHUImagePickerOriginalImage];
    //    [self.collectionView reloadData];
}

#pragma mark - 通过拍照选取照片

- (void)takePhoto {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagepicker = [[UIImagePickerController alloc] init];
        imagepicker.delegate = self;
        imagepicker.allowsEditing = YES;
        imagepicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self.fatherController presentViewController:imagepicker animated:YES completion:^{}];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        MomentPhotoModel *moment = [[MomentPhotoModel alloc] init];
        moment.photoImage = [VHSUtils image:[info objectForKey:UIImagePickerControllerEditedImage] scaleToSize:CGSizeMake(62, 62)];
        moment.imageType = VHSImagePickerOfImageAlbumType;
        
        [self.photos removeLastObject];
        
        [self.photos addObject:moment];
        
        // 回调，将数据传父组件
        if (self.imagePickerCompletionHandler) self.imagePickerCompletionHandler(self.photos);
        
        if ([self.photos count] < MAX_ALLOWED_COUNT) {
            MomentPhotoModel *model = [[MomentPhotoModel alloc] init];
            model.photoImage = [UIImage imageNamed:@"club_moment_photo_add"];
            model.imageType = VHSImagePickerOfImagePlaceHolderType;
            [self.photos addObject:model];
        }
        
        [self.photosView reloadData];
    }];
}

- (void)dealloc {
    CLog(@"VHSImagePickerView be dealloc");
}

@end



#pragma mark - 自定义CollectionViewCell--VHSImagePickerCollectionCell

@interface VHSImagePickerCollectionCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *removeBtn;

@end

@implementation VHSImagePickerCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat rl = 25;
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(rl / 2.0 - 5,
                                                                       rl / 2.0 - 5,
                                                                       frame.size.width - rl / 2.0,
                                                                       frame.size.height - rl / 2.0)];
        self.imageView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.imageView];
        
        self.removeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.imageView.frame.size.width - rl / 2.0 - 5,
                                                                    -rl / 2.0 + 5,
                                                                    rl,
                                                                    rl)];
        [self.removeBtn setImage:[UIImage imageNamed:@"club_moment_photo_delete"] forState:UIControlStateNormal];
        [self.removeBtn addTarget:self action:@selector(removeSelectedImage:) forControlEvents:UIControlEventTouchUpInside];
        [self.imageView addSubview:self.removeBtn];
    }
    return self;
}

- (void)setMoment:(MomentPhotoModel *)moment {
    self.imageView.image = moment.photoImage;
    
    if (moment.imageType == VHSImagePickerOfImagePlaceHolderType) {
        self.removeBtn.hidden = YES;
    } else {
        self.removeBtn.hidden = NO;
    }
}

- (void)removeSelectedImage:(UIButton *)btn {
    if (self.removeSelectedImageBlock) self.removeSelectedImageBlock();
}

@end
