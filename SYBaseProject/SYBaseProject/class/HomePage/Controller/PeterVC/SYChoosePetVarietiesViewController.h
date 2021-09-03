//
//  SYChoosePetVarietiesViewController.h
//  SYBaseProject
//
//  Created by sy on 2020/7/5.
//  Copyright © 2020 YYB. All rights reserved.
//

#import "BaseVC.h"
#import "SYPetModel.h"

@protocol SYChoosePetVarietiesViewControllerDelegate <NSObject>
@optional
- (void)choosedPetVarieties:(SYPetBreedModel*_Nonnull)petModel;
@end

NS_ASSUME_NONNULL_BEGIN

@interface SYChoosePetVarietiesViewController : BaseVC
@property (nonatomic,weak) id<SYChoosePetVarietiesViewControllerDelegate> delegate;
@property (nonatomic,copy) NSString *type_id;
@end

NS_ASSUME_NONNULL_END
