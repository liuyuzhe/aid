//
//  AidAddThemeViewController.m
//  
//
//  Created by 刘育哲 on 15/11/9.
//
//

#import "AidAddThemeViewController.h"
#import "AidTaskViewController.h"

#import "Masonry.h"

#import "LYZCustomNavView.h"
#import "LYZPlaceholderTextView.h"
#import "LYZWeatherBasicInfoView.h"

#import "LYZLocationHelper.h"
#import "LYZImagePickerHelper.h"
#import "LYZNetworkManager.h"

#import "AidThemeRecord.h"

static const CGFloat AidThemeViewHeight = 190;
static const CGFloat AidThemeDescTextViewHeight = 190;
static const CGFloat AidViewDefaultOffset = 20;
static const CGFloat AidViewDefaultInset = 5;
static NSString * const AidThemeImageTableName = @"themeImageTable";
static NSString * const AidImageDefaultName = @"backImage8.jpg";

@interface AidAddThemeViewController () <UITextFieldDelegate, UITextViewDelegate, LYZLocationHelperDelegate>

@property (nonatomic, strong) LYZCustomNavView *customNavView; /**< 自定义导航视图 */
@property (nonatomic, strong) UIView *themeView; /**< 主题主视图 */
@property (nonatomic, strong) UIImageView *themeImageView; /**< 主题图片视图 */
@property (nonatomic, strong) UITextField *themeNameTextField; /**< 主题名称文本框 */
@property (nonatomic, strong) UITextField *themeDescribeTextField; /**< 主题描述文本框 */
@property (nonatomic, strong) UILabel *chooseThemeLabel; /**< 选择主题标签 */
@property (nonatomic, strong) LYZPlaceholderTextView *themeDescribeTextView; /**< 主题描述文本视图 */

@property (nonatomic, strong) LYZWeatherBasicInfoView *weatherView;
@property (nonatomic, strong) LYZLocationHelper *weatherLocation;
@property (nonatomic, strong) LYZImagePickerHelper *imagePicker;

@property (nonatomic, strong) NSDateFormatter *formatter;
@property (nonatomic, strong) YTKKeyValueStore *themeImageStore;
@property (nonatomic, strong) NSString *themeImageName;

@end

                       
@implementation AidAddThemeViewController

#pragma mark - life cycle

- (void)loadView
{
    UIView *contentView = [[UIView alloc] initWithFrame:LYZScreenBounds];
    self.view = contentView;
    
    self.view.backgroundColor = [UIColor darkGrayColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupPageNavigation];
    
    [self.view addSubview:self.customNavView];
    [self.view addSubview:self.themeView];
    [self.themeView addSubview:self.themeImageView];
    [self.themeView addSubview:self.chooseThemeLabel];
    [self.themeView addSubview:self.themeNameTextField];
    [self.view addSubview:self.themeDescribeTextView];
    [self.view addSubview:self.weatherView];
    
    [self layoutPageSubviews];
    
    [self reloadWeatherData];
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - life cycle helper

- (void)setupPageNavigation
{
}

- (void)layoutPageSubviews
{
    __weak UIView *weakSelf = self.view;
    
    [self.customNavView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf);
        make.top.equalTo(weakSelf).mas_offset(AidStatusBarHeight);
        make.height.mas_equalTo(AidNavigationBarHeight);
    }];
    
    [self.themeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).mas_offset(AidViewDefaultOffset);
        make.right.equalTo(weakSelf).mas_offset(-AidViewDefaultOffset);
        make.top.equalTo(self.customNavView.mas_bottom);
        make.height.mas_equalTo(AidThemeViewHeight);
    }];
    
    [self.themeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.themeView).mas_offset(AidViewDefaultInset);
        make.right.equalTo(self.themeView).mas_offset(-AidViewDefaultInset);
        make.bottom.equalTo(self.chooseThemeLabel.mas_top).mas_offset(-AidViewDefaultInset);
    }];
    
    [self.chooseThemeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.themeView);
        make.bottom.equalTo(self.themeView).mas_offset(-AidViewDefaultInset);
    }];
    
    [self.themeNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.themeView).mas_offset(AidViewDefaultOffset);
        make.right.equalTo(self.themeView).mas_offset(-AidViewDefaultOffset);
        make.centerY.equalTo(self.themeImageView);
    }];
 
    [self.themeDescribeTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.themeView.mas_bottom).mas_offset(AidViewDefaultOffset);
        make.left.equalTo(weakSelf).mas_offset(AidViewDefaultOffset);
        make.right.equalTo(weakSelf).mas_offset(-AidViewDefaultOffset);
        make.height.mas_equalTo(AidThemeDescTextViewHeight);
    }];
    
    [self.weatherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.themeDescribeTextView.mas_bottom).mas_offset(AidViewDefaultOffset);
        make.left.right.equalTo(weakSelf);
        make.height.mas_equalTo(AidTabBarHeight);
    }];
}

- (void)reloadWeatherData
{
    [self.weatherLocation startLocation];
}

#pragma mark - override super

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.themeNameTextField resignFirstResponder];
    
    return YES;
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

#pragma mark - LYZLocationHelper

- (void)locationHelper:(LYZLocationHelper *)location didSuccess:(NSArray<CLPlacemark *> *)placemarks
{
    CLPlacemark *placemark = [placemarks objectAtIndex:0];
    NSString *cityName = placemark.locality; // 区名
    cityName = [cityName stringByReplacingOccurrencesOfString:@"市" withString:@""];
    if (cityName.length > 0) {
        [self setupWeatherDataWithCityName:cityName];
    }
}

- (void)setupWeatherDataWithCityName:(NSString *)cityName
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[LYZNetworkManager sharedInstance] getWeatherDataByCityName:cityName success:^(LYZWeatherDataModel *dataModel) {
            self.weatherView.weatherModel = dataModel;
        }];
    });
}

- (void)locationHelper:(LYZLocationHelper *)location didFailed:(NSError *)error
{
    LYZERROR(@"位置信息获取失败");
}

- (void)locationHelperDidClose:(LYZLocationHelper *)location
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您已经关闭定位服务，请在设置－隐私－定位服务中打开" preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alert animated:YES completion:^{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissViewControllerAnimated:YES completion:nil];
        });
        
    }];
}

#pragma mark - event response

- (void)cancelButtonAction:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)completeButtonAction:(UIButton *)button
{
    if ([self.themeNameTextField.text trimBothWhitespace].length <= 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"主题名称不能为空" preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alert animated:YES completion:^{
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alert dismissViewControllerAnimated:YES completion:nil];
            });
            
        }];
        
        return;
    }
    
    AidThemeRecord *record = [[AidThemeRecord alloc] init];
    record.name = self.themeNameTextField.text;
    record.describe = self.themeDescribeTextView.text;
    record.imageName = AidImageDefaultName;
    record.createTime = [NSNumber numberWithDouble:[NSDate timeIntervalSinceReferenceDate]];
    record.praiseState = [NSNumber numberWithBool:NO];
    record.watchCount = [NSNumber numberWithInteger:1];
    record.praiseCount = [NSNumber numberWithInteger:1];
    record.storeCount = [NSNumber numberWithInteger:1];

    if ([self.delegate respondsToSelector:@selector(addThemeRecord:)]) {
        [self.delegate addThemeRecord:record];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)chooseTheme
{
    [self.imagePicker showOnViewController:self completed:^(UIImage *image, NSDictionary *info) {
        self.themeImageView.image = image;
        
//        _themeImageName = [NSString stringWithFormat:@"themeImageKey_%@", [self.formatter stringFromDate:[NSDate date]]];
//        NSData *imageData = UIImagePNGRepresentation(image);
//        
//        [self.themeImageStore putObject:imageData withId:_themeImageName intoTable:AidThemeImageTableName];
        
//        NSDictionary *queryUser = [store getObjectById:key fromTable:tableName];
//        NSLog(@"query data result: %@", queryUser);
    }];
}

#pragma mark - notification response

#pragma mark - private methods

#pragma mark - getters and setters

- (LYZCustomNavView *)customNavView
{
    if (! _customNavView) {
        _customNavView = [[LYZCustomNavView alloc] init];
        __weak typeof(self) weakSelf = self;
        _customNavView.cancelButtonTouched = ^(UIButton *button) {
            [weakSelf cancelButtonAction:button];
        };
        _customNavView.completeButtonTouched = ^(UIButton *button) {
            [weakSelf completeButtonAction:button];
        };
    }
    return _customNavView;
}

- (UIView *)themeView
{
    if (! _themeView) {
        _themeView = [[UIView alloc] init];
        _themeView.backgroundColor = [UIColor grayColor];
    }
    return _themeView;
}

- (UIImageView *)themeImageView
{
    if (! _themeImageView) {
        _themeImageView = [[UIImageView alloc] init];
        _themeImageView.contentMode = UIViewContentModeScaleToFill;
        UIImage *image = [UIImage imageNamed:AidImageDefaultName];
        _themeImageView.image = image;
//        
//        _themeImageName = AidImageDefaultName;
//        NSData *imageData = UIImagePNGRepresentation(image);
//        [self.themeImageStore putObject:imageData withId:AidImageDefaultName intoTable:AidThemeImageTableName];
    }
    return _themeImageView;
}

- (UILabel *)chooseThemeLabel
{
    if (! _chooseThemeLabel) {
        _chooseThemeLabel = [[UILabel alloc] init];
        _chooseThemeLabel.text = @"设置封面";
        _chooseThemeLabel.textColor = [UIColor darkGrayColor];
        _chooseThemeLabel.textAlignment = NSTextAlignmentCenter;
        __weak typeof(self) weakSelf = self;
        [_chooseThemeLabel tappedGesture:^{
            [weakSelf chooseTheme];
        }];
    }
    return _chooseThemeLabel;
}

- (UITextField *)themeNameTextField
{
    if (! _themeNameTextField) {
        _themeNameTextField = [[UITextField alloc] init];
        _themeNameTextField.textColor = [UIColor whiteColor]; // 文本颜色
        _themeNameTextField.font = [UIFont systemFontOfSize:18]; // 文本字体
        _themeNameTextField.textAlignment = NSTextAlignmentCenter; // 文本对齐方式
        _themeNameTextField.borderStyle = UITextBorderStyleRoundedRect; // 边框类型
//        _themeNameTextField.placeholder = @"请输入主题名称"; // 水印提示
        _themeNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入主题名称"
                                                                                    attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        _themeNameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone; // 首字母是否大写
        _themeNameTextField.autocorrectionType = UITextAutocorrectionTypeNo; // 自动纠错类型
        _themeNameTextField.keyboardType = UIKeyboardTypeDefault; // 键盘类型
        _themeNameTextField.returnKeyType = UIReturnKeyDone; // return键类型
        _themeNameTextField.backgroundColor = [UIColor clearColor]; // 背景颜色
        _themeNameTextField.delegate = self;
    }
    return _themeNameTextField;
}

- (LYZPlaceholderTextView *)themeDescribeTextView
{
    if (! _themeDescribeTextView) {
        _themeDescribeTextView = [[LYZPlaceholderTextView alloc] init];
        _themeDescribeTextView.placeholder = @"请输入主题描述";
        _themeDescribeTextView.textColor = [UIColor whiteColor]; // 文本颜色
        _themeDescribeTextView.font = [UIFont systemFontOfSize:18]; // 文本字体
        _themeDescribeTextView.textAlignment = NSTextAlignmentLeft; // 文本对齐方式
        _themeDescribeTextView.autocapitalizationType = UITextAutocapitalizationTypeNone; // 首字母是否大写
        _themeDescribeTextView.autocorrectionType = UITextAutocorrectionTypeNo; // 自动纠错类型
        _themeDescribeTextView.keyboardType = UIKeyboardTypeDefault; // 键盘类型
        _themeDescribeTextView.returnKeyType = UIReturnKeyDone; // return键类型
        _themeDescribeTextView.dataDetectorTypes = UIDataDetectorTypeNone; // 显示数据类型的连接模式
        _themeDescribeTextView.scrollEnabled = NO;    // 当文字超过视图的边框时是否允许滑动，默认为“YES”
        _themeDescribeTextView.backgroundColor = [UIColor grayColor]; // 背景颜色
        _themeDescribeTextView.delegate = self;
    }
    return _themeDescribeTextView;
}

- (LYZWeatherBasicInfoView *)weatherView
{
    if (! _weatherView) {
        _weatherView = [[LYZWeatherBasicInfoView alloc] init];
//        _weatherView.backgroundColor = [UIColor grayColor]; // 背景颜色
    }
    return _weatherView;
}

- (LYZLocationHelper *)weatherLocation
{
    if (! _weatherLocation) {
        _weatherLocation = [LYZLocationHelper sharedInstance];
        _weatherLocation.delegate = self;
    }
    return _weatherLocation;
}

- (LYZImagePickerHelper *)imagePicker
{
    if (! _imagePicker) {
        _imagePicker = [[LYZImagePickerHelper alloc] init];
    }
    return _imagePicker;
}

- (YTKKeyValueStore *)themeImageStore
{
    if (! _themeImageStore) {
        _themeImageStore = [[YTKKeyValueStore alloc] initDBWithName:@"themeImage.db"];
        [_themeImageStore createTableWithName:AidThemeImageTableName];
    }
    return _themeImageStore;
}

- (NSDateFormatter *)formatter
{
    if (! _formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        _formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        _formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
    }
    return _formatter;
}

@end
