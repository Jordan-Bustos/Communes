//
//  jbsVille.m
//  TP3-ALT-Bustos
//
//  Created by Jordan Bustos on 26/05/2014.
//  Copyright (c) 2014 Jordan Bustos. All rights reserved.
//

#import "Ville.h"

@implementation Ville

-(id) initWithNom:(NSString*)nom
           andMaj:(NSString*)maj
    andCodePostal:(NSString*)codePostal
     andCodeINSSE:(NSString*)codeINSSE
    andCodeRegion:(NSString*)codeRegion
      andLatitude:(float)latitude
     andLongitude:(float)longitude
   andEloignement:(float)eloignement
{
    self = [super init];
    if (self)
    {
        _nom = nom;
        _maj = maj;
        _codePostal = codePostal;
        _codeINSEE = codeINSSE;
        _codeRegion = codeRegion;
        _latitude = latitude;
        _longitude = longitude;
        _eloignement = eloignement;
    }
    return self;
}

@end
