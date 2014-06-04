//
//  MasterViewController.m
//  TP3-ALT-Bustos
//
//  Created by Jordan Bustos on 26/05/2014.
//  Copyright (c) 2014 Jordan Bustos. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

@interface MasterViewController () {
    NSMutableArray *_communes;
    NSMutableArray *_communesAffichees ;
    NSMutableDictionary *_dictionaryOfCommunesByLetter ;
    NSArray *_keysSorted ;
}
@end

@implementation MasterViewController

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _searchBar.delegate = self; // NE PAS OUBLIER
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

// nombre de section dans la table (= nombre de clés dans le dictionnaire)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_keysSorted count];
}

// nombre de lignes par section (=nombre d'item dans la liste de la section)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString * key = [_keysSorted objectAtIndex:section];
    return [[_dictionaryOfCommunesByLetter objectForKey:key] count];
}

// titre de la section (=nom de la clé à la section)
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    return [_keysSorted objectAtIndex:section];
}

// index
-(NSArray*) sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _keysSorted;
}

// for cellule
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSString * key = [_keysSorted objectAtIndex:indexPath.section];
    Ville *ville = [[_dictionaryOfCommunesByLetter objectForKey:key] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [ville nom];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Ville *object = _communesAffichees[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

// information reçue du downloader delegate
-(void) finishWithVilles:(NSMutableArray*) villes
{
    _communesAffichees = [self sortVillesByName:villes];
    _communes = _communesAffichees;
    
    _dictionaryOfCommunesByLetter=[self fixDictionaryOfCommuneByLetterWith: _communes];
    _keysSorted = [self createKeysSorted];
    
    [[self tableView]reloadData]; // rafraichir la liste
    [self setTitle:@"Liste des villes de France"];
}

// Permet de trier les communes par nom
- (NSMutableArray *)sortVillesByName:(NSMutableArray *)villes
{
    NSArray * sortedVilles = [villes sortedArrayUsingComparator:^NSComparisonResult(Ville* villeA, Ville* villeB)
                              {
                                  return [villeA.nom compare:villeB.nom];
                              }];
    NSMutableArray * sortedVillesMutable = [[NSMutableArray alloc]initWithArray:sortedVilles];
    return sortedVillesMutable;
}

// Permet de creer le dictionnaire de communes par lettre (a -> ..., b-> bbb, ...)
-(NSMutableDictionary *) fixDictionaryOfCommuneByLetterWith: (NSMutableArray *)communes
{
    NSMutableDictionary * dictionaryOfCommunesByLetter = [[NSMutableDictionary alloc]init];
    
    NSString * lastFirstLetter = [[NSString alloc]init];
    NSString * firstLetter = [[NSString alloc]init];
    
    // On parcourt les villes
    for (Ville * ville in communes)
    {
        // on récupère la 1ère lettre de la ville en cours
        NSData *data = [ville.nom dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString *nom = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        
        firstLetter = [nom substringToIndex:1];
        
        // si elle est différente de la dernière stockée
        if (![lastFirstLetter isEqualToString: firstLetter])
        {
            // on insert une liste vide dans le dictionnaire avec la clé de cette lettre
            NSMutableArray * liste = [[NSMutableArray alloc]init];
            [dictionaryOfCommunesByLetter setObject:liste forKey:firstLetter];
            
            // on stock la lettre
            lastFirstLetter = firstLetter;
        }
        
        // on insert la ville dans la liste de la clé de cette lettre
        [[dictionaryOfCommunesByLetter objectForKey:firstLetter]addObject:ville];
    }
    
    return dictionaryOfCommunesByLetter;
}

// permet de creer une liste de clés triées du dictionnaire de communes
-(NSArray *) createKeysSorted
{
    return  [[_dictionaryOfCommunesByLetter allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString* keyA, NSString* keyB)
             {
                 return [keyA compare:keyB];
             }];
}

// quand on click sur rechercher
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    _communesAffichees = [[NSMutableArray alloc]init];
    NSString * chaineSearch = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    for (Ville * ville in _communes)
        if ([ville.nom rangeOfString:chaineSearch].location != NSNotFound)
            [_communesAffichees addObject:ville];
    
    _dictionaryOfCommunesByLetter = [self fixDictionaryOfCommuneByLetterWith:_communesAffichees];
    [[self tableView]reloadData]; // rafraichir la liste    
}

// information reçue du downloader delegate
-(void) finishWithError:(NSString*)error
{
    [self setTitle:error];
}

@end
