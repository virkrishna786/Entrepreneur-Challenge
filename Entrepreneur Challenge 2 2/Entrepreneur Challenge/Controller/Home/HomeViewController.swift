//
//  HomeViewController.swift
//  Entrepreneur Challenge
//
//  Created by Admin media on 3/23/17.
//  Copyright © 2017 Media Mosaic service private limited. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class HomeViewController: UIViewController  ,UICollectionViewDelegateFlowLayout ,UICollectionViewDataSource ,UIScrollViewDelegate,UITextFieldDelegate {
    
    
    @IBOutlet weak var heightConstraintForFeaturedCollectionView: NSLayoutConstraint!

    @IBOutlet weak var heightConstraintForSuggestedCollectionView: NSLayoutConstraint!
    @IBOutlet weak var unattemptedLabel: UILabel!
    @IBOutlet weak var attemptedLabel: UILabel!
    @IBOutlet weak var lineLabel: UILabel!
    @IBAction func sadglsghsd(_ sender: UIButton) {
       // self.performSegue(withIdentifier : "piView" , sender: self)
    }
    var boolValue = 0
    var buttonIndexValue : String!
    @IBOutlet weak var suggestedCollectionView: UICollectionView!
    @IBAction func viewAllSuggestedButtonAction(_ sender: UIButton) {
        self.buttonIndexValue = "suggested"
        self.performSegue(withIdentifier: "viewAll", sender: self)
    }
    @IBAction func featuredViewAllButtonAction(_ sender: UIButton) {
        self.buttonIndexValue = "featured"
        self.performSegue(withIdentifier: "viewAll", sender: self)

    }
    @IBOutlet weak var suggestedViewAllButton: UIButton!
    @IBOutlet weak var viewAllButtonForFeatured: UIButton!
    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!{
        
        didSet{
        }
    }
    @IBOutlet weak var featuredCollectionView: UICollectionView!
    var featuredArray = [FeaturedDataClass]()
    var suggestedArray = [SuggestedDataClass]()
    var bannerArray = [BannerDataClass]()
    var imageViewss = [UIImageView]()
     var pageControl : UIPageControl = UIPageControl(frame:CGRect(x: 0, y: 300, width: 100, height: 50))
    var timer = Timer()
    var  staticView = UIView()
    
    @IBAction func menuButtonAction(_ sender: UIButton) {
        if boolValue == 0 {
            appDelegate.menuTableViewController.showMenu()
            self.view .addSubview(appDelegate.menuTableViewController.view)
            boolValue = 1
            let  kdfsgks = UIView()
            self.staticView = parentClass.setSideMenu(customView: kdfsgks)
            print("sdfdsf",staticView)
            self.view.addSubview(self.staticView)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.gestureFunction))
            self.staticView.addGestureRecognizer(tapGesture)
            
        } else {
            appDelegate.menuTableViewController.hideMenu()
            self.view .addSubview(appDelegate.menuTableViewController.view)
            boolValue = 0
            self.staticView.removeFromSuperview()
        }
    }
    
    var featuredCellIdentifier = "featureCellIdentifier"
    var suggestedCellIdentifier = "suggestedCellIdentifier"
    var allAttempCellIdenitfier = "AllAttemnpted"
    var surveyIdString: Int!
    var userIdString : Int?
    var interestIdString : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.featuredCollectionView.delegate = self
        self.featuredCollectionView.dataSource = self
        self.featuredCollectionView.backgroundColor = UIColor.clear
        self.suggestedCollectionView.backgroundColor = UIColor.clear
        self.searchTextField.delegate = self
        let images  = UIImage(named: "search")
        let rightDropDownButton = UIButton(type: UIButtonType.custom)
        rightDropDownButton.setImage(images, for: UIControlState.normal)
        
        let leftView4 = UIView()
        leftView4.addSubview(rightDropDownButton)
        
        leftView4.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        rightDropDownButton.frame = CGRect(x: 5, y: 0, width :20, height: 23)
        rightDropDownButton.addTarget(self, action: #selector(HomeViewController.searchMethod), for: UIControlEvents.touchUpInside)
        self.searchTextField.rightView = leftView4
        self.searchTextField.rightViewMode = .always
        self.searchTextField.attributedPlaceholder = NSAttributedString(string: " Search", attributes: [NSForegroundColorAttributeName: UIColor.darkGray])
        
        // image for 
        
        self.imageView.layer.borderWidth = 1.0
        self.imageView.layer.borderColor = UIColor.white.cgColor
        self.myScrollView.layer.borderWidth = 0.5
        self.myScrollView.layer.borderColor = UIColor.white.cgColor

        self.featuredCollectionView.register(UINib(nibName: "FeaturedCell", bundle: nil), forCellWithReuseIdentifier: featuredCellIdentifier)
         self.featuredCollectionView.register(UINib(nibName: "AllAttemptedCell", bundle: nil), forCellWithReuseIdentifier: allAttempCellIdenitfier)
        self.suggestedCollectionView.register(UINib(nibName: "SuggestedCell", bundle: nil), forCellWithReuseIdentifier: suggestedCellIdentifier)
        
        myScrollView.showsHorizontalScrollIndicator = false
        myScrollView.delegate = self

        let userId = defaults.value(forKey: "userId") as? Int
          self.userIdString = userId
        print("user %@" ,userId!)
        
        let interestIdString = defaults.string(forKey: "interest")
           self.interestIdString = interestIdString
        print("dkfkd %@",interestIdString!)
        
       
        // self.customView.canCancelContentTouches = false
//        var staticView = UIView()
//        staticView = parentClass.setSideMenu(customView: customView)
//        staticView.addGestureRecognizer(tapGesture)
      //  parentClass.setSideMenu(customView: customView).addGestureRecognizer(tapGesture)
            
        self.surveyList()

        // Do any additional setup after loading the view.
    }
    
    func gestureFunction(){
        appDelegate.menuTableViewController.hideMenu()
        self.view .addSubview(appDelegate.menuTableViewController.view)
        boolValue = 0
        self.staticView.removeFromSuperview()
    }
    
  override   func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.gestureFunction), name: NSNotification.Name(rawValue: "resetStaticView"), object: nil)
    }
    
    
    
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        self.pageControl.numberOfPages = bannerArray.count
        if(self.view.frame.size.height==667.0){
            self.pageControl.frame.origin.y=200.0
        }
        else{
            self.pageControl.frame.origin.y=150.0
        }
        
        self.pageControl.frame.origin.x=(self.view.frame.size.width/2-50)
        self.pageControl.currentPage = 0
        self.pageControl.backgroundColor = UIColor.clear
      //  self.view.addSubview(pageControl)
        
    }
    
    func changePage(sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * self.myScrollView.frame.size.width
        self.myScrollView.setContentOffset(CGPoint(x: x,y :0), animated: true)
        self.scrollViewDidEndDecelerating(myScrollView)
       // self.scrollViewWillBeginDragging(myScrollView)
        print("*****")
    }
    
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        
//        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
//        pageControl.currentPage = Int(pageNumber)
//        print("gjkjkg")
//    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width) + 1
        pageControl.currentPage = Int(pageNumber)
        print("gjkjkg")
    }
    

    //MARK: - Search Method
    
    func searchMethod(){
        self.performSegue(withIdentifier: "searchView", sender: self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.addChildViewController(appDelegate.menuTableViewController)
        
        let view=self.navigationController?.viewControllers.first
        
        if !((view! ) .isKind(of: HomeViewController.self)){
            
            //set ralist view as root view controller
            
            let firstView:HomeViewController
                = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "homeView") as! HomeViewController
            self.navigationController?.viewControllers .remove(at: 0)
            self.navigationController?.viewControllers .insert(firstView, at: 0)
        }
        
//        self.eventApiHit(string: "1")
        self.navigationController?.navigationBar.isHidden = true
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func surveyList() {
        
        if currentReachabilityStatus != .notReachable {
            
            hudClass.showInView(view: self.view)
            let url = "\(baseUrl)surveyList"
            
            let parameters = ["user_id": "\(self.userIdString!)"
               ]
            print("dnd %@",parameters)
            
            hudClass.showInView(view: self.view)
            
            Alamofire.request( url, method : .post , parameters: parameters).responseJSON { (responseObject) -> Void in
                
                print(responseObject)
                
                if responseObject.result.isSuccess {
                    hudClass.hide()
                    print("api response ",responseObject.result.value!)
                    let resJson = JSON(responseObject.result.value!)
                    
                    let  res_message = resJson["res_Una_msg"].string
                    let  res_messageBanner = resJson["res_banner_msg"].string
                    let  res_messageSuggest = resJson["res_a_msg"].string
                    
                    if res_messageSuggest == "Record Found" {
                        let suggestData =  resJson["attempt"].array
                        
                        for suggestEVentArray in suggestData! {
                            let suggestDataClassArray = SuggestedDataClass()
                            suggestDataClassArray.suggestSurveyIfd = suggestEVentArray["s_id"].int
                            suggestDataClassArray.suggestSurveyName = suggestEVentArray["s_name"].string
                            suggestDataClassArray.suggestImageArray = suggestEVentArray["s_image"].string
                            self.suggestedArray.append(suggestDataClassArray)
                        }
                          DispatchQueue.main.async {
                            self.attemptedLabel.isHidden = false
                            self.suggestedViewAllButton.isHidden = false
                            //self.lineLabel.isHidden = false
                            self.suggestedCollectionView.reloadData()
                        }
                        
                    }else {
                        
                        DispatchQueue.main.async{
                            
                            self.unattemptedLabel.frame.origin.y = 700
                            self.suggestedViewAllButton.frame.origin.y = 700
                            self.suggestedCollectionView.frame.origin.y = 800
                            self.lineLabel.frame.origin.y = 750
                            self.heightConstraintForFeaturedCollectionView.constant = -200
                            self.featuredCollectionView.frame.size.height = 500
                            print("height ",self.featuredCollectionView.frame.size.height)
                            
                            let  layout = self.featuredCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
                            layout.scrollDirection = UICollectionViewScrollDirection.vertical
                            self.featuredCollectionView.contentSize.height =  200
                            self.attemptedLabel.isHidden = true
                            self.suggestedViewAllButton.isHidden = true
                            self.lineLabel.isHidden = true
                            self.suggestedCollectionView.isHidden = true
                            
                        }
                        
                       // self.featuredCollectionView.reloadData()
                    }
                    
                    if res_messageBanner == "Record Found" {
                        let bannerDataResponse = resJson["bannerList"].array
                        
                        for eventArray in bannerDataResponse! {
                            let eventData = BannerDataClass()
                             eventData.bannerId = eventArray["b_id"].int
                             eventData.bannerImage = eventArray["b_image"].string
                            self.bannerArray.append(eventData)
                        }
                       
                        DispatchQueue.main.async {
                            var frame: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
                            self.configurePageControl()
                            self.myScrollView.delegate=self
                            for index in 0..<self.bannerArray.count {
                                
                                frame.origin.x = self.myScrollView.frame.size.width * CGFloat(index)
                                frame.size = self.myScrollView.frame.size
                                //self.ssScrollView.bounds.size
                                self.myScrollView.isPagingEnabled = true
                                
                                let imageView = UIImageView(frame: frame)
                                let datas = self.bannerArray[index]
                                let url = URL(string : "\(datas.bannerImage!)")
                                print("sbdfk  %@",url!)
                                imageView.kf.setImage(with: url! ,placeholder: UIImage(named: "dummy"))
                                
                                self.myScrollView .addSubview(imageView)
                            }
                            self.myScrollView.contentSize = CGSize(width: self.myScrollView.frame.size.width * CGFloat(self.bannerArray.count), height: self.myScrollView.frame.size.height)
                            
                           // self.pageControl.addTarget(self, action: Selector(("changePage:")), for: UIControlEvents.valueChanged)
                            //self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(HomeViewController.changePage(sender:)), userInfo: nil, repeats: true)
                            self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(HomeViewController.changePage as (HomeViewController) -> () -> ()), userInfo: nil, repeats: true)

                           // self.imageView.kf.setImage(with: ss)
                           
//                            for i in stride(from: 0, to: self.bannerArray.count, by: 1){
//                                
//                               let dataBanner = self.bannerArray[i]
//                                let url = URL(string : "\(dataBanner.bannerImage!)")
//                               // cell.featureImageView.kf.setImage(with: url , placeholder : UIImage(named: "dummy"))
//                                let  imageViewa = UIImageView()
//                                imageViewa.kf.setImage(with: url)
//                                self.myScrollView.addSubview(imageViewa)
//                                self.imageViewss.append(imageViewa)
//                            }
//                            
//                            for (index,imageView) in self.imageViewss.enumerated() {
//                                imageView.frame = CGRect(x: CGFloat(index)*self.myScrollView.frame.size.width, y: 0, width: self.myScrollView.frame.size.width, height: 60)
//                               
//                            }
//                            self.myScrollView.contentSize =  CGSize(width: self.myScrollView.frame.size.width*5, height: self.myScrollView.frame.size.height)
                    }
                        
                    }else {
                            
                        }
                    
                    if res_message == "Record Found" {
                        let dataResponse = resJson["Unattempt"].array
                        for eventArray in dataResponse! {
                            let eventArrayClass = FeaturedDataClass()
                            eventArrayClass.surveyFeaturedId = eventArray["s_id"].int
                            eventArrayClass.surveyFeaturedName = eventArray["s_name"].string
                            eventArrayClass.surveyFeaturedImage = eventArray["s_image"].string
                            eventArrayClass.surveyFeaturedRating = eventArray["s_rating"].string
                            self.featuredArray.append(eventArrayClass)
                        }
                        print("homeEventArray : \(self.featuredArray)")
                        print("dataArray \(dataResponse)")
                        
                        DispatchQueue.main.async {
                            self.featuredCollectionView.reloadData()
                            
                        }
                        print("dsfs \(resJson)")
//                    }else res_message == "Record is Not Found"{
                    }else {
                        hudClass.hide()
                        DispatchQueue.main.async {
                            
                            self.unattemptedLabel.text = "Completed"
                            self.unattemptedLabel.frame.origin.y = 700
                            self.suggestedViewAllButton.frame.origin.y = 700
                            self.suggestedCollectionView.frame.origin.y = 800
                            self.lineLabel.frame.origin.y = 750
                            self.heightConstraintForFeaturedCollectionView.constant = -200
                            self.featuredCollectionView.frame.size.height = 500
                            print("height ",self.featuredCollectionView.frame.size.height)
                            
                            let  layout = self.featuredCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
                            layout.scrollDirection = UICollectionViewScrollDirection.vertical
                            self.featuredCollectionView.contentSize.height =  200
                            self.attemptedLabel.isHidden = true
                            self.suggestedViewAllButton.isHidden = true
                            self.lineLabel.isHidden = true
                            self.suggestedCollectionView.isHidden = true
                            self.featuredCollectionView.reloadData()
                            
                            
                            
                        }
                       
                       // self.viewAllButtonForFeatured.isHidden = true
//                        let label = UILabel()
//                        self.view.addSubview(parentClass.setBlankView(label: label))
                    }
                    
                }
                if responseObject.result.isFailure {
                    hudClass.hide()
                    let indexValue = 0
                    let error  = responseObject.result.error!  as NSError
                    let alertVC = UIAlertController(title: "Alert", message: "Some thing went wrong.", preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction!) in self.myFunc(indexsValue: indexValue)}))
                    self.present(alertVC, animated: true, completion: nil)

                    print("failuredata \(error)")
                }
            }
        }else {
            parentClass.showAlert()
        }
    }
    
    func myFunc(indexsValue : Int){
        
        var statValue = indexsValue
        statValue += 1
        if statValue >= 3 {
            
        }else {
        self.surveyList()
        }
    }
    
    // function for changing slides automatically 
    
    func changePage(){
        let pageWidth:CGFloat = self.myScrollView.frame.width
        let maxWidth:CGFloat = pageWidth * CGFloat(self.bannerArray.count)
        let contentOffset:CGFloat = self.myScrollView.contentOffset.x
        
        var slideToX = contentOffset + pageWidth
        
        if  contentOffset + pageWidth == maxWidth{
            slideToX = 0
        }
        self.myScrollView.scrollRectToVisible(CGRect(x:slideToX, y:0, width:pageWidth, height:self.myScrollView.frame.height), animated: true)
        
    }

     //MARK:- collection view data
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if (collectionView == featuredCollectionView) {
            
            if featuredArray.count <= 0 {
            return suggestedArray.count
            }else {
                return featuredArray.count
            }
        }else if(collectionView == suggestedCollectionView) {
            return suggestedArray.count
        }
      return 1
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let yourWidth = collectionView.bounds.width/3.0
//        let yourHeight = yourWidth
//        
//        return CGSize(width: yourWidth, height: yourHeight)
//    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if suggestedArray.count <= 0 {
            print("dfds")
            let yourWidth = collectionView.bounds.width/3.0
            let yourHeight = yourWidth
            self.featuredCollectionView.frame.size.height = 200
            return CGSize(width: yourWidth, height: yourHeight)
        }else if featuredArray.count <= 0{
            let yourWidth = collectionView.bounds.width/3.0
            let yourHeight = yourWidth
            self.suggestedCollectionView.frame.size.height = 200
            return CGSize(width: yourWidth, height: yourHeight)
        }else {
        return CGSize(width: 100 , height: 100)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0,-10,0,0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = UICollectionViewCell()
        
        if (collectionView == featuredCollectionView) {
            
            if featuredArray.count <= 0 {
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: allAttempCellIdenitfier,
                                                              for: indexPath) as! AllattemptedCellType
                let eventList =  suggestedArray[indexPath.row]
                let url = URL(string : "\(eventList.suggestImageArray!)")
                cell.suggestedImageView.kf.setImage(with: url , placeholder : UIImage(named: "dummy"))
                cell.suggestedLabel.text =  eventList.suggestSurveyName
                return cell
   
            }else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: featuredCellIdentifier,
                                                          for: indexPath) as! FeaturedTypeCell
            let eventList =  featuredArray[indexPath.row]
            let url = URL(string : "\(eventList.surveyFeaturedImage!)")
            cell.featureImageView.kf.setImage(with: url , placeholder : UIImage(named: "dummy"))
            cell.featureLabel.text =  eventList.surveyFeaturedName
            return cell
            }
 
        }else if (collectionView == suggestedCollectionView){
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: suggestedCellIdentifier,
                                                          for: indexPath) as! SuggestedTypeCell
            let eventList =  suggestedArray[indexPath.row]
            let url = URL(string : "\(eventList.suggestImageArray!)")
            cell.suggestedImageView.kf.setImage(with: url , placeholder : UIImage(named: "dummy"))
            cell.suggestedLabel.text =  eventList.suggestSurveyName
            return cell
 
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        if (collectionView == suggestedCollectionView) {
            let eventList =  suggestedArray[indexPath.row]
            self.surveyIdString = eventList.suggestSurveyIfd!
            self.performSegue(withIdentifier: "surveyDetail", sender: self)
            
        }else if (collectionView == featuredCollectionView){
            
            if featuredArray.count <= 0{
                let eventList =  suggestedArray[indexPath.row]
                self.surveyIdString = eventList.suggestSurveyIfd!
                self.performSegue(withIdentifier: "surveyDetail", sender: self)
                
            }else {
            let eventList =  featuredArray[indexPath.row]
              self.surveyIdString = eventList.surveyFeaturedId!
            self.performSegue(withIdentifier: "surveyDetail", sender: self)
            }
        }
        
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField ==  searchTextField {
            self.performSegue(withIdentifier: "searchView", sender: self)
            self.isEditing = false
        }
        textField.resignFirstResponder()
    }
    
    func textFieldShouldBeginEditing(_textField: UITextField){
         self.performSegue(withIdentifier: "searchView", sender: self)
      _textField.resignFirstResponder()
    }
    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "viewAll" {
            let eventDetailView = segue.destination as! FeaturedAndSuggestedListViewController
            eventDetailView.titleString = self.buttonIndexValue!
            
            // eventDetailView.friendIdString = self.peopleIdString!
            // print("homepage eventIDString \(eventDetailView.friendIdString)")
        }else if segue.identifier == "surveyDetail" {
            
            let identifer = segue.destination as! SurveyDetailViewController
            identifer.surveyIdString = self.surveyIdString!
            
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
