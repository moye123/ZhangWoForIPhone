//
//  ChooseToolbar.m
//  LADZhangWo
//
//  Created by Apple on 16/1/29.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ChooseToolbar.h"

@implementation ChooseToolbarCatCell
@synthesize textLabel = _textLabel;
@synthesize text = _text;

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, frame.size.width-20, frame.size.height)];
        _textLabel.font = [UIFont systemFontOfSize:14.0];
        self.selectedBackgroundView = [[UIView alloc] init];
        self.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1];
        [self addSubview:_textLabel];
    }
    return self;
}

- (void)setText:(NSString *)text{
    if (_text != text) {
        _text = text;
        _textLabel.text = text;
    }
}

@end

@implementation ChooseToolbar
@synthesize fid = _fid;
@synthesize button1 = _button1;
@synthesize button2 = _button2;
@synthesize button3 = _button3;
@synthesize filterDelegate = _filterDelegate;
@synthesize collectionView = _collectionView;

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _buttonWidth = frame.size.width/3;
        _originHeight = frame.size.height;
        _button1 = [[UIButton alloc] init];
        _button1.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_button1 setTitle:@"分类" forState:UIControlStateNormal];
        [_button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_button1 addTarget:self action:@selector(toggleCategoryPannel:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button1];
        
        _arrow1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
        _arrow1.image = [UIImage imageNamed:@"choose-arrow1.png"];
        [_button1 addSubview:_arrow1];
        
        _button2 = [[UIButton alloc] init];
        _button2.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_button2 setTitle:@"销量优先" forState:UIControlStateNormal];
        [_button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_button2 addTarget:self action:@selector(sortBySold:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button2];
        
        _button3 = [[UIButton alloc] init];
        _button3.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_button3 setTitle:@"价格" forState:UIControlStateNormal];
        [_button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_button3 addTarget:self action:@selector(sortByPrice:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button3];
        
        _arrow2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
        _arrow2.image = [UIImage imageNamed:@"choose-arrow2.png"];
        [_button3 addSubview:_arrow2];
        
        _line1 = [[UIView alloc] init];
        _line1.backgroundColor = [UIColor grayColor];
        [self addSubview:_line1];
        
        _line2 = [[UIView alloc] init];
        _line2.backgroundColor = [UIColor grayColor];
        [self addSubview:_line2];
        [self setBackgroundColor:[UIColor whiteColor]];
        
        self.clipsToBounds = NO;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, (self.originY+self.height), self.width, 0) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[ChooseToolbarCatCell class] forCellWithReuseIdentifier:@"catCell"];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame fid:(NSInteger)fid{
    self = [self initWithFrame:frame];
    self.fid = fid;
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    [newSuperview insertSubview:_collectionView atIndex:[newSuperview.subviews count]];
}

- (void)setFid:(NSInteger)fid{
    if (_fid != fid) {
        _fid = fid;
        [[DSXHttpManager sharedManager] GET:@"&c=goods&a=category" parameters:@{@"fid":@(fid)} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if ([[responseObject objectForKey:@"errno"] intValue] == 0) {
                    _categoryList = [@[@{@"cname":@"全部",@"catid":@(fid)}] arrayByAddingObjectsFromArray:[responseObject objectForKey:@"data"]];
                    //_categoryList = @[@{@"cname":@"全部",@"catid":@(fid)}];
                    [_collectionView reloadData];
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
    }
}

- (void)toggleCategoryPannel:(UIButton *)button{
    CGFloat contentHeight;
    if (_collectionView.height == 0) {
        contentHeight = 200;
        _arrow1.transform = CGAffineTransformMakeRotation(M_PI);
    }else {
        contentHeight = 0;
        _arrow1.transform = CGAffineTransformMakeRotation(0);
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        _collectionView.height = contentHeight;
    }];
}

- (void)sortBySold:(UIButton *)button{
    //_asc = !_asc;
    if (_filterDelegate && [_filterDelegate respondsToSelector:@selector(chooseBar:sortBySold:)]) {
        [_filterDelegate chooseBar:self sortBySold:_asc];
    }
}

- (void)sortByPrice:(UIButton *)button{
    _asc = !_asc;
    if (_asc) {
        _arrow2.transform = CGAffineTransformMakeRotation(0);
    }else {
        _arrow2.transform = CGAffineTransformMakeRotation(M_PI);
    }
    if (_filterDelegate && [_filterDelegate respondsToSelector:@selector(chooseBar:sortByPrice:)]) {
        [_filterDelegate chooseBar:self sortByPrice:_asc];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _button1.frame = CGRectMake(0, 0, _buttonWidth, self.height);
    _button2.frame = CGRectMake(_buttonWidth, 0, _buttonWidth, self.height);
    _button3.frame = CGRectMake(_buttonWidth*2, 0, _buttonWidth, self.height);
    _line1.frame = CGRectMake(_buttonWidth, (self.height-20)/2, 0.4, 20);
    _line2.frame = CGRectMake(_buttonWidth*2, (self.height-20)/2, 0.8, 20);
    
    _arrow1.position = CGPointMake(_button1.width/2+18, (_button1.height-16)/2);
    _arrow2.position = CGPointMake(_button3.width/2+18, (_button3.height-16)/2);
}

#pragma mark - collectionview delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_categoryList count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.width/3-0.1, 50);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.00001;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0.00001;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ChooseToolbarCatCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"catCell" forIndexPath:indexPath];
    cell.text = [[_categoryList objectAtIndex:indexPath.row] objectForKey:@"cname"];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *data = [_categoryList objectAtIndex:indexPath.row];
    [self toggleCategoryPannel:nil];
    if (_filterDelegate && [_filterDelegate respondsToSelector:@selector(chooseBar:filterByCatID:)]) {
        [_filterDelegate chooseBar:self filterByCatID:[[data objectForKey:@"catid"] integerValue]];
    }
}

@end
