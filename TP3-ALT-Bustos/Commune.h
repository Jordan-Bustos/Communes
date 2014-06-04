//
//  jbsCommune.h
//  TP3-ALT-Bustos
//
//  Created by Jordan Bustos on 26/05/2014.
//  Copyright (c) 2014 Jordan Bustos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Commune : NSObject

@property (strong) NSString * nom;
@property (strong) NSString * maj;
@property (strong) NSString * codePostal;
@property (strong) NSString * codeINSEE;
@property (strong) NSString * codeRegion;
@property float latitude;
@property float longitude;
@property float eloignement;

-(id) initWithNom:(NSString*)nom
           andMaj:(NSString*)maj
    andCodePostal:(NSString*)codePostal
     andCodeINSSE:(NSString*)codeINSSE
    andCodeRegion:(NSString*)codeRegion
      andLatitude:(double)latitude
     andLongitude:(double)longitude
   andEloignement:(double)eloignement;

@end