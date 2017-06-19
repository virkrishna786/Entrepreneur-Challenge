//
//  FeaturedAndSuggestedListViewController.swift
//  Entrepreneur Challenge
//
//  Created by Admin media on 3/27/17.
//  Copyright © 2017 Media Mosaic service private limited. All rights reserved.
//

import UIKit
import  Alamofire
import  SwiftyJSON

class FeaturedAndSuggestedListViewController: UIViewController ,UITableViewDataSource ,UITableViewDelegate {
    @IBAction func backButtonAction(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var searchListTableView: UITableView!
    
    var titleString : String!
    let cellIdentifier = "whoseAroundEventCell"
    var numberofEvents :Int!
    var  exploreDetailArray = [FeaturedDataClass]()
    var sugegstedDataArray = [SuggestedDataClass]()
    var eventIdString : String!
    var urlString : String!
    var res_message : String!
    var surveyIdString : Int!
    var userIdString : Int?
    var interestIdString : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if self.titleString == "suggested" {
//            self.titleLabel.text = "Suggested Survey"
//            self.urlString = "suggestedViewAll"
//        }else if self.titleString == "featured"{
//            self.titleLabel.text = "Featured Survey"
//            self.urlString = "featuredViewAll"
//
//        }
        
        // Api call function
        self.urlString = "surveyViewAll"
        
        self.searchListTableView.register(UINib(nibName : "WhoseAroundEventTableViewCell" ,bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.searchListTableView.tableFooterView = UIView()
        self.searchListTableView.layer.cornerRadius = 5.0
        self.searchListTableView.backgroundColor = UIColor.clear
        
        let userId = defaults.value(forKey: "userId") as? Int
        self.userIdString = userId
        print("user %@" ,userId!)
        
        let interestIdString = defaults.string(forKey: "interest")
        self.interestIdString = interestIdString
        print("dkfkd %@",interestIdString!)

        
        self.whoseAroundApiHit(urlStrings: self.urlString)
        
        // Do any additional setup after loading the view.
    }
    
    func whoseAroundApiHit(urlStrings : String) {
        
        if currentReachabilityStatus != .notReachable {
            let url = "\(baseUrl)\(urlStrings)"
            hudClass.showInView(view: self.view)
            
            let parameters = ["user_id": "\(self.userIdString!)",
                "interest" : "\(self.interestIdString!)"]
            print("dnd %@",parameters)

            Alamofire.request( url, method : .post, parameters: parameters).responseJSON { (responseObject) -> Void in
                print(responseObject)
                print("rsposneIbekjds \(responseObject)")
                if responseObject.result.isSuccess {
                    hudClass.hide()
                    let resJson = JSON(responseObject.result.value!)
                    print("resJsonf \(resJson)")
                        self.res_message  = (resJson["res_s_msg"].string)!

                    if self.res_message == "Record Found" {
                        
                            let dataResponse = resJson["surveyViewAll"].array
                            self.numberofEvents = dataResponse?.count
                            print("numberofEventsdetail \(self.numberofEvents)")

                             for eventArray in dataResponse! {
                                
                                let eventArrayClass = SuggestedDataClass()
                                eventArrayClass.suggestSurveyIfd = eventArray["s_id"].int
                                eventArrayClass.suggestSurveyName = eventArray["s_name"].string
                                eventArrayClass.suggestImageArray = eventArray["s_image"].string
                                eventArrayClass.suggestedRatingString = eventArray["s_rating"].string
                                eventArrayClass.suggestedReviewString = eventArray["s_review"].string
                                eventArrayClass.s_type = eventArray["s_type"].string
                                self.sugegstedDataArray.append(eventArrayClass)
                            }
                            print("dataArrayList \(dataResponse)")
                            DispatchQueue.main.async {
                                self.searchListTableView.reloadData()
                                self.searchListTableView.isHidden = false
                            }
                            print("dsfs \(resJson)")
                        
                       
                    }else if self.res_message == "Record is Not Found"{
                        self.searchListTableView.isHidden = true
                        let label = UILabel()
                        self.view.addSubview(parentClass.setBlankView(label: label))
                        print("sdkgdksbhgks")
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
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                   return sugegstedDataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCell(withIdentifier: "whoseAroundEventCell") as! WhoseAroundEventTableViewCell
           cell.backgroundColor = UIColor.clear
            let suggestedData =  sugegstedDataArray[indexPath.row]
            cell.eventNameLabel.text = suggestedData.suggestSurveyName!
            //cell.eventDistanceLabel.text = "Rating:\(suggestedData.suggestedRatingString!)"
           // cell.eventReviewLabel.text =  "Reviews: \(suggestedData.suggestedReviewString!)"
            let uRL = URL (string: "\(suggestedData.suggestImageArray!)")
            cell.eventImageView.kf.setImage(with: uRL , placeholder : UIImage(named: "dummy"))
          let s_typeData = suggestedData.s_type!
        print("s_type : ",s_typeData)
        if s_typeData == "1" {
            
        }else {
            cell.eventImageView.image = UIImage(named: "attempted")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let data = sugegstedDataArray[indexPath.row]
            self.surveyIdString = data.suggestSurveyIfd!
            self.performSegue(withIdentifier: "surveyDetail", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     // MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "surveyDetail" {
           let identifer = segue.destination as! SurveyDetailViewController
            identifer.surveyIdString = self.surveyIdString!
        }
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
    
    
}
