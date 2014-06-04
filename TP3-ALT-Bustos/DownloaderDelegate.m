//
//  jbsConnectionDelegate.m
//  TP3-ALT-Bustos
//
//  Created by Jordan Bustos on 26/05/2014.
//  Copyright (c) 2014 Jordan Bustos. All rights reserved.
//

#import "DownloaderDelegate.h"

@implementation DownloaderDelegate

const int NOM = 0;
const int MAJ = 1;
const int CODEPOSTAL = 2;
const int CODEINSEE = 3;
const int CODEREGION = 4;
const int LATITUDE = 5;
const int LONGITUDE = 6;
const int ELOIGNEMENT = 7;

-(id) initWithURLString:(NSString*) URLString andDelegate:(MasterViewController *) delegate
{
    self = [super init];
    if (self)
    {
        _URLString = URLString;
        _communes = [[NSMutableArray alloc]init];
        _delegate = delegate;
        
        // On construit le path du fichier à stocker.
        _nsPathOfTmpFile = [NSString stringWithFormat:@"%@/tmp/ville.csv", NSHomeDirectory()];
        _nsPathOfDocumentFile = [NSString stringWithFormat:@"%@/Documents/ville.csv", NSHomeDirectory()];
    }
    return self;
}

-(BOOL) start
{
    // On récupère la date du jour
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/mm/yyyy"];
    _dateOfDay = [formatter stringFromDate:[NSDate date]];
    
    NSString * dateOfSettings = [[NSUserDefaults standardUserDefaults] stringForKey:@"lastDateOfDownload"];
    
    // Si la date des paramètres est différente de la date du jour : on télécharge le fichier villes.csv
    if (![dateOfSettings isEqualToString:_dateOfDay])
    {
        // Create the request.
        NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:_URLString]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        _receivedData = [NSMutableData dataWithCapacity: 0];
    
        // create the connection with the request
        // and start loading the data
        NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
        
    
        if (!theConnection)
        {
            // Release the receivedData object.
            _receivedData = nil;
        
            // Inform the user that the connection failed.
            return false;
        }
    }
    else if([self parseCSVFileOfFileAtPath:_nsPathOfDocumentFile])
            [_delegate finishWithCommunes:_communes];
    
    return true;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [_receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_receivedData appendData:data];
}

// Téléchargement terminé
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if([_receivedData writeToFile:_nsPathOfTmpFile atomically:YES])
    {
        if([self parseCSVFileOfFileAtPath:_nsPathOfTmpFile])
        {
            // Si le parse du csv a réussi, on déplace le fichier et on informe le Master View Controler.
            NSFileManager * fileManager = [[NSFileManager alloc]init];
            [fileManager moveItemAtPath:_nsPathOfTmpFile toPath:_nsPathOfDocumentFile error:nil];
            
            // On stock la date du jour dans les paramètres
            NSDictionary *appDefaults = [NSDictionary dictionaryWithObject:_dateOfDay
                                                                    forKey:@"lastDateOfDownload"];
            [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
            
            // Set up the preference.
            CFStringRef key = CFSTR("lastDateOfDownload");
            CFStringRef value = (__bridge CFStringRef)(_dateOfDay);
            
            CFPreferencesSetAppValue(key, value,
                                     kCFPreferencesCurrentApplication);
            // Write out the preference data.
            CFPreferencesAppSynchronize(kCFPreferencesCurrentApplication);
        
            // on informe le delegate
            [_delegate finishWithCommunes:_communes];
        }
    }
    
    _receivedData = nil;
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    _receivedData = nil;    
    
    [_delegate finishWithError:@"Erreur de connexion"];
    
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    
}

-(BOOL) parseCSVFileOfFileAtPath:(NSString *) path
{
    // On recupere la totalite du fichier
    NSString * contentOfFile = [[NSString alloc]initWithContentsOfFile:path
                                                              encoding:NSUTF8StringEncoding
                                                                 error:NULL];
    // On separe le contenu du fichier par ligne
    NSArray * lignes = [[NSArray alloc]init];
    lignes = [contentOfFile componentsSeparatedByString:@"\n"];
    
    // On parcourt chaque ligne
    for (int i=1;i<[lignes count];i++)
    {
        // On separe la ligne courante par une "," pour recuperer une liste de proprietes
        NSArray * communeProperties = [[NSArray alloc]init];
        communeProperties = [lignes[i] componentsSeparatedByString:@";"];
        
        Commune * commune = [self extractCommuneFromCommuneProperties:communeProperties];
        if (commune != nil)
            [_communes addObject:commune];
    }
    
    return true;
}

-(Commune *) extractCommuneFromCommuneProperties:(NSArray *)communeProperties
{
    if ([communeProperties count] == 8)
    {
        // On recupere les proprietes proprietes
        NSString * nom = [communeProperties objectAtIndex:NOM];
        nom = [nom stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if ([nom isEqualToString: @""])
            return nil;
        
        NSString * maj = [communeProperties objectAtIndex:MAJ];
        NSString * codePostal = [communeProperties objectAtIndex:CODEPOSTAL];
        NSString * codeINSEE = [communeProperties objectAtIndex:CODEINSEE];
        NSString * codeRegion = [communeProperties objectAtIndex:CODEREGION];
        double latitude = [[communeProperties objectAtIndex:LATITUDE] doubleValue];
        double longitude = [[communeProperties objectAtIndex:LONGITUDE] doubleValue];
        double eloignement = [[communeProperties objectAtIndex:ELOIGNEMENT] doubleValue];
        
        // On cree la commune associee
        Commune * commune = [[Commune alloc]initWithNom:nom
                                           andMaj:maj
                                    andCodePostal:codePostal
                                     andCodeINSSE:codeINSEE
                                    andCodeRegion:codeRegion
                                      andLatitude:latitude
                                     andLongitude:longitude
                                   andEloignement:eloignement];        
        return commune;
    }
    else
        return nil;
}

@end
