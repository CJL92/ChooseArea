//
//  ViewController.m
//  ChooseArea
//
//  Created by 曹进龙 on 2017/8/21.
//  Copyright © 2017年 曹进龙. All rights reserved.
//

#import "ViewController.h"
#import "AreaModel.h"
#import "CityModel.h"
#import "ProvinceModel.h"
@interface ViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIPickerView *_pickerView;
    NSDictionary *_areaDic;
    NSMutableArray *_provinceArr;
    
    
}


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loading];
}
- (void)loading
{
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^{
        [self prepareData];
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            [self uiConfig];
        });
        
    });
}
- (void)prepareData
{
    //area.plist是字典
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
    _areaDic = [[NSDictionary alloc]initWithContentsOfFile:plistPath];
    
    //city.plist是数组
    NSString *plist = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"plist"];
    NSMutableArray *dataCity = [[NSMutableArray alloc] initWithContentsOfFile:plist];
    
    _provinceArr = [[NSMutableArray alloc]init];
    for (NSDictionary *dic in dataCity) {
        ProvinceModel *model  = [[ProvinceModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        model.citiesArr = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in model.cities) {
            CityModel *cityModel = [[CityModel alloc]init];
            [cityModel setValuesForKeysWithDictionary:dic];
            [model.citiesArr addObject:cityModel];
        }
        [_provinceArr addObject:model];
    }
    
}
- (void)uiConfig
{
    //picker view 有默认高度216
    _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height/2, [UIScreen mainScreen].bounds.size.width, 216)];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [_pickerView selectRow:0 inComponent:0 animated:YES];
    [self.view addSubview:_pickerView];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 3;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (0 == component)
    {
        return _provinceArr.count;
    }
    else if(1==component)
    {
        NSInteger rowProvince = [pickerView selectedRowInComponent:0];
        ProvinceModel *model =   _provinceArr[rowProvince];
        return model.citiesArr.count;
    }
    else
    {   NSInteger rowProvince = [pickerView selectedRowInComponent:0];
        NSInteger rowCity = [pickerView selectedRowInComponent:1];
        ProvinceModel *model = _provinceArr[rowProvince];
        CityModel *cityModel = model.citiesArr[rowCity];
        NSString *str = [cityModel.code description];
        NSArray *arr =  _areaDic[str];
        return arr.count;
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (0 == component)
    {
        ProvinceModel *model = _provinceArr[row];
        return model.name;
    }
    else if(1==component)
    {
        NSInteger rowProvince = [pickerView selectedRowInComponent:0];
        ProvinceModel *model = _provinceArr[rowProvince];
        CityModel *cityModel = model.citiesArr[row];
        return cityModel.name;
    }else
    {
        NSInteger rowProvince = [pickerView selectedRowInComponent:0];
        NSInteger rowCity = [pickerView selectedRowInComponent:1];
        ProvinceModel *model = _provinceArr[rowProvince];
        CityModel *cityModel = model.citiesArr[rowCity];
        NSString *str = [cityModel.code description];
        NSArray *arr = _areaDic[str];
        AreaModel *areaModel = [[AreaModel alloc]init];
        [areaModel setValuesForKeysWithDictionary:arr[row]];
        return areaModel.name;
    }
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(0 == component)
    {
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
        
    } if(1 == component)
    {
        [pickerView reloadComponent:2];
    }
    
    NSInteger selectOne = [pickerView selectedRowInComponent:0];
    NSInteger selectTwo = [pickerView selectedRowInComponent:1];
    NSInteger selectThree = [pickerView selectedRowInComponent:2];
    
    ProvinceModel *model = _provinceArr[selectOne];
    CityModel *cityModel = model.citiesArr[selectTwo];
    NSString *str = [cityModel.code description];
    NSArray *arr = _areaDic[str];
    AreaModel *areaModel = [[AreaModel alloc]init];
    [areaModel setValuesForKeysWithDictionary:arr[selectThree]];
    self.navigationItem.title = [NSString stringWithFormat:@"省:%@  市:%@  区:%@",model.name,cityModel.name,areaModel.name];
    NSLog(@"省:%@ 市:%@ 区:%@",model.name,cityModel.name,areaModel.name);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
