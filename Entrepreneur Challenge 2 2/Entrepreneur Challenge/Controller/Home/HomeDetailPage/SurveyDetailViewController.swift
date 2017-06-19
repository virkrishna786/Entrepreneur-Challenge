//
//  SurveyDetailViewController.swift
//  Entrepreneur Challenge
//
//  Created by Admin media on 3/27/17.
//  Copyright © 2017 Media Mosaic service private limited. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class SurveyDetailViewController: UIViewController , UITableViewDelegate ,UITableViewDataSource {
    
    @IBOutlet weak var SurveyNameMainLabel: UILabel!
    @IBOutlet weak var s_TypeMainLabel: UILabel!
    @IBAction func backButtonAction(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
        
    }
    @IBOutlet weak var eventDetailTableView: UITableView!
    
    let cellIdentifier = "eventDetail"
    let reviewCellIdentifier = "reviewCell"
    var numberofEvents :Int!
    var surveyIdString : Int! {
        didSet {
            print("eventdetial eventIdString \(surveyIdString!)")
        }
    }
    
    var eventDetailArray = [SurveyDetailClass]()
    var reviewDetailArray = [ReviewClass]()
    var surveyname : String!
    var s_cat_IDString : Int!
    var userIdString : Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.eventDetailTableView.delegate = self
        self.eventDetailTableView.dataSource = self
        self.eventDetailTableView.backgroundColor = UIColor.clear
        self.eventDetailTableView.tableFooterView = UIView()
        let userId = defaults.value(forKey: "userId") as? Int
        self.userIdString = userId
        print("user %@" ,userId!)
        
        defaults.set(self.surveyIdString!, forKey: "eventId")
        defaults.synchronize()
        
        self.navigationController?.navigationBar.isHidden = true
        self.eventDetailTableView.register(UINib(nibName : "SurveyDetaiLCell" ,bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.eventDetailTableView.register(UINib(nibName : "ReviewCell" ,bundle: nil), forCellReuseIdentifier: reviewCellIdentifier)
        self.eventDetailApiHit()
        self.eventDetailTableView.separatorColor = UIColor.clear
        // Do any additional setup after loading the view.
    }
    
    func eventDetailApiHit() {
        
        if currentReachabilityStatus != .notReachable {
            let url = "\(baseUrl)surveyDetail"
            let parameter = ["s_id" : "\(self.surveyIdString!)",
                              "user_id": "\(self.userIdString!)"]
            print("parameter \(parameter)")
            hudClass.showInView(view: self.view)
            
            Alamofire.request( url, method : .post, parameters: parameter).responseJSON { (responseObject) -> Void in
                
                print(responseObject)
                
                print("rsposneIbekjds \(responseObject)")
                if responseObject.result.isSuccess {
                    hudClass.hide()
                    let resJson = JSON(responseObject.result.value!)
                    
                    print("resJsonf \(resJson)")
                    let  res_message  = (resJson["res_msg"].string)!
                    let res_review_message = (resJson["res_review_msg"].string)!
                    print("res_messafe \(res_message)")
                    
                    if res_message == "Record Found" {
                        let dataResponse = resJson["SurveyDetail"].array
                        self.numberofEvents = dataResponse?.count
                        print("numberofEventsdetail \(self.numberofEvents)")
                        
                        for eventArray in dataResponse! {
                            let eventArrayClass = SurveyDetailClass()
                            
                            eventArrayClass.eventImage = eventArray["s_image"].string
                            eventArrayClass.eventIdString = eventArray["s_id"].string
                            eventArrayClass.numberOfReviewString = eventArray["s_review"].string
                            eventArrayClass.ratingString = eventArray["s_rating"].string
                            eventArrayClass.eventName = eventArray["s_name"].string
                            let eventNameLabel = eventArray["s_name"].string
                            let s_typeValue = eventArray["s_type"].string
                            eventArrayClass.eventDetailString = eventArray["s_description"].string
                            eventArrayClass.eventEndTime = eventArray["event_end_time"].string
                            eventArrayClass.s_cat_idString = eventArray["s_cat_id"].int
                            eventArrayClass.s_typeString = eventArray["s_type"].string
                            //  eventArrayClass.reviewerNameString = eventArray
                            self.eventDetailArray.append(eventArrayClass)
                             self.setValues(name: eventNameLabel!, S_type: s_typeValue!)
                        }
                        print("EventdetailArray : \(self.eventDetailArray)")
                        print("dataArrayList \(dataResponse)")
                        
                        DispatchQueue.main.async {
                            
                            self.eventDetailTableView.reloadData()
                        }
                        print("dsfs \(resJson)")
                    }else {
                        print("sdkgdksbhgks")
                    }
                    
                    if (res_review_message == "Record Found"){
                        
                        guard   let reviewData = resJson["Review"].array else {
                            print("soemthing withds")
                            DispatchQueue.main.async {
                                self.eventDetailTableView.reloadData()
                            }
                            return
                        }
                        print("reviewDataArray  \(reviewData)")
                        for reviewArray in reviewData  {
                            let reviewClassArray = ReviewClass()
                            reviewClassArray.reviewIdString = reviewArray["r_id"].string
                            reviewClassArray.reviewerNameString = reviewArray["user_name"].string
                            reviewClassArray.reviewDetail = reviewArray["r_review_msg"].string
                            reviewClassArray.numberOfRating = reviewArray["r_rating"].string
                            self.reviewDetailArray.append(reviewClassArray)
                            print("self.reviewDetailArray \(self.reviewDetailArray)")
                        }
                        
                        DispatchQueue.main.async {
                            self.eventDetailTableView.reloadData()
                        }

                        
                    }else {
                        DispatchQueue.main.async {
                            self.eventDetailTableView.reloadData()
                        }
                        
                    }
                }
                if responseObject.result.isFailure {
                    hudClass.hide()
                    parentClass.showAlertWithApiFailure()
                    let error  = responseObject.result.error!  as NSError
                    print("\(error)")
                }
            }
            
        }else{
            parentClass.showAlert()
        }
    }
    
    
    func setValues (name: String ,S_type: String) {
     self.SurveyNameMainLabel.text = name
        
        if S_type == "1" {
            self.s_TypeMainLabel.isHidden = true
            print("\(self.SurveyNameMainLabel.frame)")
            self.s_TypeMainLabel.frame.origin.y = 100
            self.SurveyNameMainLabel.frame.origin.y = -90
           //self.setNeedsFocusUpdate()
            
        }else {
            self.s_TypeMainLabel.isHidden = false
            print("\(self.SurveyNameMainLabel.frame)")

        }
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if reviewDetailArray.count <= 0 {
            
            return 1
        }else {
            
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //   return eventDetailArray.count
        
        if   reviewDetailArray.count <= 0 {
            return eventDetailArray.count
        }else {
            switch section {
            case 0:
                print("eventdetailArray.count \(eventDetailArray.count)")
                return eventDetailArray.count
            case 1 :
                print("reviewDetailArray \(reviewDetailArray.count)")
                return 0
            default:
                return   1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            return 450
        case 1:
            return 100
        default:
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if reviewDetailArray.count <= 0 {
            
        }else {
            if section == 1 {
                return "Reviews"
                
            }else {
              
                
            }
        }
        
        return ""
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let views = UIView()
        views.backgroundColor = UIColor.clear
        return views
    }
    
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        let header = view as! UITableViewHeaderFooterView
//        header.textLabel?.font = UIFont(name: "Helvetica_neue", size: 14)
//        header.textLabel?.textColor = UIColor.white
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        if reviewDetailArray.count <= 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)! as! SurveyDetailCellTypeCell
            let eventList = eventDetailArray[indexPath.row]
            print("eventLsit\(eventList)")
            
            print("event imageString = \(eventList.eventImage!)")
            let uRL = URL(string: "\(eventList.eventImage!)")
            cell.eventImageView.kf.setImage(with: uRL , placeholder : UIImage(named: "dummy"))
            
            
            let eventnameString =  eventList.eventName!
//            if eventnameString == "" {
//               cell.eventNameLabel.text = ""
//            }else {
//                cell.eventNameLabel.text = eventnameString
//            }
//            
//            print("dskfg %@",eventnameString)

           // let eventdetailData = eventList.eventDetailString!
//            if eventdetailData == "" {
//                cell.eventDetailLabel.text = ""
//            }else {
//                cell.eventDetailLabel.text = eventdetailData
//            }
//            let numberOFratingString = eventList.ratingString!
            
//            if numberOFratingString == "" {
//                
//                cell.ratingButton.titleLabel?.text = ""
//            }else {
//                // cell.ratingButton.setTitle(numberOFratingString + "/5", for: UIControlState.normal)
//            }
            
//            let numberoOfReviewString = eventList.numberOfReviewString!
//            if numberoOfReviewString == "" {
//                cell.reviewButton.titleLabel?.text = ""
//                
//            }else {
//               // cell.reviewButton.setTitle(numberoOfReviewString + "" + "Reviews", for: UIControlState.normal)
//            }
            cell.startSurveyButton.addTarget(self, action: #selector(SurveyDetailViewController.surveyStartMethod), for: UIControlEvents.touchUpInside)
            cell.startSurveyButton.layer.cornerRadius = 15.0
            cell.backgroundColor = UIColor.clear
            let s_type = eventList.s_typeString!
            print("s_type ",s_type)
            if s_type == "1"{
             //cell.s_typeTextLabel.isHidden = true
                cell.startSurveyButton.setTitle("START SURVEY", for: UIControlState.normal)
             cell.simpleTextLabel.text =  "To complete the survey questions for your nominated enterprise hit the start button below."
            }else {
             // cell.s_typeTextLabel.isHidden = false
              cell.startSurveyButton.setTitle("UPDATE SURVEY", for: UIControlState.normal)
              cell.simpleTextLabel.text = "To update the survey questions for your nominated enterprise hit the UPDATE SURVEY button below."
            }
            
            return cell
        }else {
            
            switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)! as! SurveyDetailCellTypeCell
                let eventList = eventDetailArray[indexPath.row]
                print("eventLsit\(eventList)")
                
                print("event imageString = \(eventList.eventImage!)")
                let uRL = URL(string: "\(eventList.eventImage!)")
                cell.eventImageView.kf.setImage(with: uRL , placeholder : UIImage(named: "dummy"))
                
                let eventnameString =  eventList.eventName!
//                if eventnameString == "" {
//                    cell.eventNameLabel.text = ""
//                }else {
//                    cell.eventNameLabel.text = eventnameString
//                }
                
               // let eventdetailData = eventList.eventDetailString!
                
//                if eventdetailData == "" {
//                    cell.eventDetailLabel.text = ""
//                }else {
//                    cell.eventDetailLabel.text = eventdetailData
//                }
//                let numberOFratingString = eventList.ratingString!
//                
//                if numberOFratingString == "" {
//                    
//                    cell.ratingButton.titleLabel?.text = ""
//                }else {
//                   // cell.ratingButton.setTitle(numberOFratingString + "/5", for: UIControlState.normal)
//                }
//                
//                let numberoOfReviewString = eventList.numberOfReviewString!
//                if numberoOfReviewString == "" {
//                    cell.reviewButton.titleLabel?.text = ""
//                    
//                }else {
//                    print("dfsgs %@",numberoOfReviewString)
//                  //  cell.reviewButton.setTitle(numberoOfReviewString + "" + "Reviews", for: UIControlState.normal)
//                }
                 cell.startSurveyButton.addTarget(self, action: #selector(SurveyDetailViewController.surveyStartMethod), for: UIControlEvents.touchUpInside)
                cell.startSurveyButton.layer.cornerRadius = 15.0
                cell.backgroundColor = UIColor.clear
                let s_type = eventList.s_typeString!
                print("s_type ",s_type)
                if s_type == "1"{
                   // cell.s_typeTextLabel.isHidden = true
                    cell.startSurveyButton.setTitle("START SURVEY", for: UIControlState.normal)
                    cell.simpleTextLabel.text =  "To complete the survey questions for your nominated enterprise hit the START button below."
                }else {
                   // cell.s_typeTextLabel.isHidden = false
                     cell.startSurveyButton.setTitle("UPDATE SURVEY", for: UIControlState.normal)
                    cell.simpleTextLabel.text =  "To update the survey questions for your nominated enterprise hit the UPDATE SURVEY button below."
                }

                return cell
            case 1 :
               /*
                let cell = tableView.dequeueReusableCell(withIdentifier: reviewCellIdentifier)! as! ReviewTableViewCell
                let reviewList = reviewDetailArray[indexPath.row]
                print("eventLsit\(reviewList)")
                
                cell.nameLabel.text = reviewList.reviewerNameString!
                cell.reviewDetailLabel.text = reviewList.reviewDetail!
                cell.ratingLabel.text = reviewList.numberOfRating! + "/5"
                print("krish")
                
                return cell
                 
 */
                break;
            default:
                print("sadfas")
            }
            
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func surveyStartMethod(sender: UIButton){
        var indexPath: NSIndexPath!
        
        if let button = sender as? UIButton {
            if let superview = button.superview {
                print("superview %@",superview)
                
                print("dksfg %@",superview.superview!)
                
                if let cell = superview.superview?.superview as? SurveyDetailCellTypeCell {
                    indexPath = eventDetailTableView.indexPath(for: cell) as NSIndexPath!
                    let data = eventDetailArray[indexPath.row]
                    let s_catIdString = data.s_cat_idString!
                    self.s_cat_IDString = s_catIdString
                    print("indesdf %@",self.s_cat_IDString)
                    self.surveyname = "\(self.SurveyNameMainLabel.text!)"
                    print("surname %@ ",surveyname!)
                }
            }
        }
        self.performSegue(withIdentifier: "questionView", sender: self)
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "questionView" {
            let eventDetailView = segue.destination as! SurveyQuestionsViewController
            eventDetailView.surveyName = self.surveyname!
            eventDetailView.surveyId = self.surveyIdString!
            eventDetailView.s_cat_id = self.s_cat_IDString!
        }
        
        
            // eventDetailView.friendIdString = self.peopleIdString!
            // print("homepage eventIDString \(eventDetailView.friendIdString)")
            
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
