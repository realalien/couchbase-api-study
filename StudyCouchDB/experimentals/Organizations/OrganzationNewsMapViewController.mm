//
//  OrganzationNewsMapViewController.m
//  StudyCouchDB
//
//  Created by d d on 12-4-9.
//  Copyright (c) 2012年 d. All rights reserved.
//

#import "OrganzationNewsMapViewController.h"
//#import "Foundation-AddsOn.h"
#import "Organization.h"
#import "CouchbaseServerManager.h"

@interface OrganzationNewsMapViewController ()
-(void)createProcessPanel;
@end
    
enum {
    kTagAlertConfirmingAddNewOrgForTableSelection = 200
};

@implementation OrganzationNewsMapViewController

@synthesize map;
@synthesize mapSearchResult;
@synthesize data;

@synthesize poiTableView;

@synthesize organizationAnnotationDataSource;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    UIView *v = [[UIView alloc]initWithFrame: [[UIScreen mainScreen]bounds] ];
    v.backgroundColor = [UIColor clearColor];
    self.view = v;
    [v release];
    


    
    // Register orientation change notification and config orientation
    // REF: http://stackoverflow.com/questions/2738734/get-current-orientation-of-ipad
//    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
}


-(void)createProcessPanel {
    // process panel
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(1024* 0.8, 0, 1024 *0.2, 768)];
    v.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:v];
    
    
    UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 18)];
    l.text = @"请输入组织的名称";
    [v addSubview:l];
    [l release];
    
    UITextField *t = [[UITextField alloc]initWithFrame:CGRectMake(10, 10+18+10, 200, 18)];
    t.placeholder = @"尽量使用全名以便搜索";
    t.tag = 101;
    [v addSubview:t];
    [t release];
    
    // 搜索按钮，确定组织机构的位置
    UIButton *s = [[UIButton alloc]initWithFrame:CGRectMake(10, (10+18)*2+10, 50, 30)];
    [s setTitle: @"搜索" forState:UIControlStateNormal];
    [s setTitle: @"搜索" forState:UIControlStateHighlighted];
    [s setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [s setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [s.titleLabel setFont:[UIFont systemFontOfSize:16]];
    s.backgroundColor = [UIColor whiteColor];
    [s addTarget:self action:@selector(searchOrganizationClicked:) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:s];
    [s release];
    
    // Baidu搜索返回的地址
    l = [[UILabel alloc]initWithFrame:CGRectMake(10, (10+18)*3+10, 200, 18)];
    l.tag = 103;
    l.text = @"";
    [v addSubview:l];
    
    // 确认添加按钮
    s = [[UIButton alloc]initWithFrame:CGRectMake(10, (10+18)*4+10, 70, 30)];
    s.tag = 104;
    s.enabled = NO;
    [s setTitle: @"确定添加" forState:UIControlStateNormal];
    [s setTitle: @"确定添加" forState:UIControlStateHighlighted];
    [s setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [s setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [s.titleLabel setFont:[UIFont systemFontOfSize:16]];
    s.backgroundColor = [UIColor whiteColor];
    [s addTarget:self action:@selector(confirmAddOrganization:) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:s];
    [s release];
    
    
    //table view for select candidate from address search, do we need baidu api for search result?
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(10, (10+18)*5+30, 200, 200)];
    table.tag = 105;
    self.poiTableView = table;
    table.delegate = self;
    table.dataSource = self;
    [v addSubview:table];
    [table release];
    
//    // a small map for confirm the target.
//    BMKMapView *confirmMap = [[BMKMapView alloc]initWithFrame:CGRectMake(10,(10+18)*3+240, 200 , 200)];
//    confirmMap.tag = 102;
//    [v addSubview:confirmMap];
//    [confirmMap release];
    
    [v release];
    
}

-(void) orientationChanged:(id)sender {
    CGRect boundsChangedForOrientation = CGRectZero;
    if ( UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation) ) {
        boundsChangedForOrientation = CGRectMake(0, 0, 1024, 768);
    } else{
        boundsChangedForOrientation = CGRectMake(0, 0, 768, 1024);
    }
    
    BMKMapView *mapV = (BMKMapView*)[self.view viewWithTag:100];
    mapV.frame = boundsChangedForOrientation;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    // map view
    
    // 要使用百度地图，请先启动BaiduMapManager
	_mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定generalDelegate参数
	BOOL ret = [_mapManager start:@"7A7572BABCE98978760E81E265CBC67E59DC543F" generalDelegate:nil];
    _search = [[BMKSearch alloc]init];
    _search.delegate = self;
    
	if (!ret) {
		NSLog(@"manager start failed!");
	}
    
    if (self.map == nil) {
        BMKMapView *mapV = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
        self.map = mapV;
        mapV.tag = 100;
        mapV.delegate = self;
        [mapV setMapType:BMKMapTypeStandard];
        //self.view = mapV;
        [self.view addSubview:mapV];
        [mapV release];
    }

    // data holder for tableview
    if (self.mapSearchResult == nil) {
        NSMutableArray *a = [NSMutableArray array];
        self.mapSearchResult = a;
    }
    
    // temporary data holder
    if (self.data == nil) {
        NSMutableDictionary *a = [NSMutableDictionary dictionary];
        self.data = a;
    }
    
    // dynamic source for annotation.
    CouchUITableSource *d = [[CouchUITableSource alloc]init];
    self.organizationAnnotationDataSource = d;
    [d release];
    
    // load annotation for exsting orgs.
    // Create a CouchDB 'view' containing list items sorted by date,
    // and a validation function requiring parseable dates:
    CouchDesignDocument* design = [[CouchbaseServerManager getDeputyDB] designDocumentWithName: @"organization"];
    design.language = kCouchLanguageJavaScript;
    [design defineViewNamed: @"organization_listing"
                        map: @"function(doc) {if (doc.doc_type == 'organization') emit(doc.title, doc);}"];
    
    //    design.validation = @"function(doc) {if (doc.created_at && !(Date.parse(doc.created_at) > 0))"
    //    "throw({forbidden:'Invalid date'});}";
    
    // Create a query sorted by descending date, i.e. newest items first:
    CouchLiveQuery* query = [[design queryViewNamed: @"organization_listing"] asLiveQuery];
    //query.keys = [NSArray arrayWithObjects:((DeputyNominee*)[self.data valueForKey:@"nominee"]).document.documentID , nil];
    query.descending = YES;

    
    
//    self.organizationAnnotationDataSource.tableView = self.tableView;
    
    [self.organizationAnnotationDataSource setQuery:query];
    
    self.organizationAnnotationDataSource.labelProperty = @"title";
    
    
    
    [self createProcessPanel];
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [mapSearchResult release];
    [map release];
    
    [data release];
    
    [poiTableView release];
    
    [organizationAnnotationDataSource release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}




#pragma mark - UITableDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.mapSearchResult count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    BMKPoiInfo *info = [self.mapSearchResult objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)",info.name, info.address];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"didSelectRowAtIndexPath:  %d", indexPath.row);
    
    [self.data setValue:[ self.mapSearchResult objectAtIndex:indexPath.row ]
                 forKey:@"organization_search_result"];
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"消息"
                                                    message:@"是否添加到关注列表？"
                                                   delegate:self 
                                          cancelButtonTitle:@"取消" 
                                          otherButtonTitles:@"确定", nil]; 
    alert.tag = kTagAlertConfirmingAddNewOrgForTableSelection;
    [alert show];
    [alert release];
}



#pragma mark - callback
-(void)searchOrganizationClicked:(id)sender{
    UITextField *t = (UITextField*)[self.view viewWithTag:101];
    if (t != nil) {
        // NOTE: use poiSearchInCity:withKey:pageIndex: to get real world address for confirmation.
        [_search poiSearchInCity:@"上海" withKey:t.text pageIndex:0];
        // TODO: retrieve more data by pull up.
        
        
        //[_search geocode:t.text withCity:@"上海"];
        
        // TODO: make it a secondary search if geocode has no result. Remember to limit the data set.
        //[_search suggestionSearch:@"曲阳第四小学"];
    }
}


// Deprecated: 
// * use table selection to choose 
// * use BMKPoiInfo instead of BMKAddrInfo
//-(void)confirmAddOrganization:(id)sender{
//    UILabel *l = (UILabel*)[self.view viewWithTag:103];
//    if (l != nil && [self.data valueForKey:@"organization_search_result"] != [NSNull null] ) {
//        BMKAddrInfo *addr =  (BMKAddrInfo*)[self.data valueForKey:@"organization_search_result"];
//        // create a organization
//        Organization *o = [[Organization alloc]initWithNewDocumentInDatabase:[CouchbaseServerManager getDeputyDB]];
//        o.title = addr.strAddr ; // We may just need to request header rather than bulk of html in order to save bandwidth.
//        o.latitude = addr.geoPt.latitude;
//        o.longitude = addr.geoPt.longitude;
//        o.fullAddress = [NSString stringWithFormat:@"%@%@%@",addr.addressComponent.district, addr.addressComponent.streetName, addr.addressComponent.streetNumber ];
//        o.doc_type = @"organization"; // TODO: this setter should be private.
//        
//        RESTOperation* op  = o.save;
//        
//        // blocking style
//        if (![op wait]) {
//            // TODO: report error
//            NSLog(@"Creating news document via organization ..... failed! %@", op.error);
//
//            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"消息"
//                                                            message:@"保存失败！或数据未更新"
//                                                           delegate:self 
//                                                  cancelButtonTitle:@"确定" 
//                                                  otherButtonTitles:nil, nil]; 
//            alert.tag = 110;
//            [alert show];
//            [alert release];
//    
//            
//        }else {
//            NSLog(@"Creating news document via organization ..... ok! o.id is %@",o.document.documentID);
//            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"消息"
//                                                            message:@"保存成功"
//                                                           delegate:self 
//                                                  cancelButtonTitle:@"确定" 
//                                                  otherButtonTitles:nil, nil]; 
//            alert.tag = 111;
//            [alert show];
//            [alert release];
//        }
//    }
//}


#pragma mark - BMKSearchDelegate
- (void)onGetPoiResult:(NSArray*)poiResultList searchType:(int)type errorCode:(int)error {
    if (error) {
        NSLog(@"eRROR IN onGetAddrResult : %d", error);
        [self.data setValue:[NSNull null] forKey:@"organization_search_result"];
    }else{
        NSLog(@"poiResultList COUNT ... %d", [poiResultList count]);
        NSLog(@"type  IS .... %d", type);
        
        // POI检索类型：城市内搜索POI列表
        if (type == BMKTypePoiList && [poiResultList count]>0) {
            // 总是取第一个元素处理， TODO: poiResultList元素大于1的情况是？
            BMKPoiResult *r = (BMKPoiResult*)[poiResultList objectAtIndex:0];
            
            //TODO: temp
            [self.mapSearchResult removeAllObjects];
            
            if (r.poiInfoList && [r.poiInfoList count]>0) {
                // debug
                for (BMKPoiInfo *info in r.poiInfoList) {
                    NSLog(@"%@ : ADDR:%@, TEL:%@, POSTCODE:%@ (%f,%f)",info.name, info.address, info.phone,info.postcode, info.pt.latitude, info.pt.longitude);
                }
                
                //
                [self.mapSearchResult addObjectsFromArray:r.poiInfoList];
                
                // reload table of candidate poi
                [self.poiTableView reloadData];
            }
        }
    }
    
}


- (void)onGetAddrResult:(BMKAddrInfo*)result errorCode:(int)error{
    if (error) {
        NSLog(@"eRROR IN onGetAddrResult : %d", error);
        [self.data setValue:[NSNull null] forKey:@"organization_search_result"];
    }else{
        NSLog(@"%@ : %@-%@-%@ ( %f, %f )",result.strAddr, 
              result.addressComponent.district, result.addressComponent.streetName,  result.addressComponent.streetNumber,
              result.geoPt.latitude, result.geoPt.longitude);
        
        // set data for other ui retrieval
        [self.data setValue:result forKey:@"organization_search_result"];
        
        // enable controls
        UIButton *b = (UIButton*)[self.view viewWithTag:104];
        if (b!=nil) {
            b.enabled = YES;
        }
        
        // make sure the result is what user targets.
        BMKMapView *m = (BMKMapView*)[self.view viewWithTag:102];
        if (m!=nil) {
            [m setRegion:BMKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(result.geoPt.latitude, result.geoPt.longitude), 500, 500)
                animated:YES];
        }
    }
}

- (void)onGetSuggestionResult:(BMKSuggestionResult*)result errorCode:(int)error {
    if (error) {
        NSLog(@"eRROR IN onGetSuggestionResult : %d", error);
    }else{
        NSLog(@"suggestion: %d ",[result.keyList count]);
        
        if (result && [result.keyList count]>0) {
            NSLog(@"First suggestion is %@", [result.keyList objectAtIndex:0]);
        }
    }
    
}

#pragma mark -
#pragma mark UIAlertViewDelegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == 110){
        
       
    }else if(alertView.tag == 111){
        // TODO: temp, rerun the live query to listen for new changes
        // find the target one.
        BMKPoiInfo *addr =  (BMKPoiInfo*)[self.data valueForKey:@"organization_search_result" ];
        self.organizationAnnotationDataSource.query.keys = [NSArray arrayWithObject:addr.name];
        NSLog(@"suppose last search is %@", addr.name);
        
        if (![self.organizationAnnotationDataSource.query wait]) {
            NSLog(@"query...... not ok");
        }else{
            // ESP.TODO: that's not correct way doing things.
            for (CouchQueryRow *r in self.organizationAnnotationDataSource.query.rows) {
                Organization *o = [Organization modelForDocument:r.document];
                NSLog(@"organization changed.  %@", o.title);
                if ([o.title isEqualToString:addr.name]) {
                    // create a new annotation for the new organization.
                    
                    break;
                }
            }
        }
    }else if(alertView.tag == kTagAlertConfirmingAddNewOrgForTableSelection){
        if (buttonIndex == alertView.cancelButtonIndex) {
            //
        } else if (buttonIndex == 1) {
            BMKPoiInfo *addr =  (BMKPoiInfo*)[self.data valueForKey:@"organization_search_result" ];
            // create a organization
            Organization *o = [[Organization alloc]initWithNewDocumentInDatabase:[CouchbaseServerManager getDeputyDB]];
            o.title = addr.name ; // We may just need to request header rather than bulk of html in order to save bandwidth.
            o.latitude = addr.pt.latitude;
            o.longitude = addr.pt.longitude;
            o.fullAddress = [NSString stringWithFormat:@"%@",addr.address];
            o.doc_type = @"organization"; // TODO: this setter should be private.
            
            RESTOperation* op  = o.save;
            
            // blocking style
            if (![op wait]) {
                // TODO: report error
                NSLog(@"Creating news document via organization ..... failed! %@", op.error);
                
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"消息"
                                                                message:@"保存失败！或数据未更新"
                                                               delegate:self 
                                                      cancelButtonTitle:@"确定" 
                                                      otherButtonTitles:nil, nil]; 
                alert.tag = 110;
                [alert show];
                [alert release];
                
                
            }else {
                NSLog(@"Creating news document via organization ..... ok! o.id is %@",o.document.documentID);
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"消息"
                                                                message:@"保存成功"
                                                               delegate:self 
                                                      cancelButtonTitle:@"确定" 
                                                      otherButtonTitles:nil, nil]; 
                alert.tag = 111;
                [alert show];
                [alert release];
            }
        }
    }
}



@end
