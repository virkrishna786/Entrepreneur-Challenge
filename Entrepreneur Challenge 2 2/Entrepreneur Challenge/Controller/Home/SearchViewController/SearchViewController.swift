//
//  SearchViewController.swift
//  Entrepreneur Challenge
//
//  Created by Admin media on 3/27/17.
//  Copyright © 2017 Media Mosaic service private limited. All rights reserved.
//

import UIKit
import  Alamofire
import  SwiftyJSON

class SearchViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource , UITextFieldDelegate {

    @IBAction func backButtonAction(_ sender: UIButton) {
        _ =  navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var searchTextField: UITextField!
    @IBAction func bakcButonAction(sender: UIButton){
        
        
    }
    @IBOutlet weak var searchListTableView: UITableView!
    let cellIdentifier = "whoseAroundEventCell"
    var numberofEvents :Int!
    var  exploreDetailArray = [WhoseAroundDataClass]()
    var eventIdString : Int!
    var userIdString : Int?
    var interestIdString : String!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchTextField.delegate = self
        self.searchListTableView.isHidden = true
        
        let customView = UIView()
        customView.frame = CGRect(x: 0, y: 0, width: 5, height: 5)
        self.searchTextField.leftView = customView
        self.searchTextField.leftViewMode = .always
        
        let images  = UIImage(named: "search")
        let rightDropDownButton = UIButton(type: UIButtonType.custom)
        rightDropDownButton.setImage(images, for: UIControlState.normal)
        
        let leftView4 = UIView()
        leftView4.addSubview(rightDropDownButton)
        
        leftView4.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        rightDropDownButton.frame = CGRect(x: 5, y: 0, width :20, height: 23)
        rightDropDownButton.addTarget(self, action: #selector(SearchViewController.searchMethod), for: UIControlEvents.touchUpInside)
        self.searchTextField.rightView = leftView4
        self.searchTextField.rightViewMode = .always
        self.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSForegroundColorAttributeName: UIColor.darkGray])
        self.searchListTableView.tableFooterView = UIView()
         self.searchListTableView.register(UINib(nibName : "WhoseAroundEventTableViewCell" ,bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.searchListTableView.tableFooterView = UIView(frame: .zero)
        self.searchListTableView.backgroundColor = UIColor.clear
        self.searchListTableView.layer.cornerRadius = 5.0
        let userId = defaults.value(forKey: "userId") as? Int
        self.userIdString = userId
        print("user %@" ,userId!)
        
        let interestIdString = defaults.string(forKey: "interest")
        self.interestIdString = interestIdString
        print("dkfkd %@",interestIdString!)


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Search Method
    
    func searchMethod(){
        
        if searchTextField.text  == "" {
            parentClass.showAlertWithApiMessage(message: "Please enter search text")
        }else {
            self.exploreDetailArray = [WhoseAroundDataClass]()
            self.whoseAroundApiHit()
        }
    }
    
    func whoseAroundApiHit() {
        
        self.searchTextField.resignFirstResponder()
            if currentReachabilityStatus != .notReachable {
                let url = "\(baseUrl)searchList"
                hudClass.showInView(view: self.view)
                
                let parameters = ["search_key" : "\(searchTextField.text!)",
                                  "user_id": "\(self.userIdString!)",
                                  "interest" : "\(self.interestIdString!)"]
                
                Alamofire.request( url, method : .post, parameters: parameters).responseJSON { (responseObject) -> Void in
                    
                    print(responseObject)
                    
                    print("rsposneIbekjds \(responseObject)")
                    if responseObject.result.isSuccess {
                        hudClass.hide()
                        let resJson = JSON(responseObject.result.value!)
                        
                        print("resJsonf \(resJson)")
                        let  res_message  = (resJson["res_s_msg"].string)!
                        print("res_messafe \(res_message)")
                        
                        if res_message == "Record Found" {
                            let dataResponse = resJson["Search"].array
                            
                            self.numberofEvents = dataResponse?.count
                            print("numberofEventsdetail \(self.numberofEvents)")
                            
                            for eventArray in dataResponse! {
                                let eventArrayClass = WhoseAroundDataClass()
                                
                                eventArrayClass.eventIdString = eventArray["s_id"].int
                                eventArrayClass.eventNmaeString = eventArray["s_name"].string
                                eventArrayClass.eventImageString = eventArray["s_image"].string
                                eventArrayClass.distanceStringForEventString = eventArray["s_rating"].string
                                eventArrayClass.reviewString = eventArray["s_review"].string
                                self.exploreDetailArray.append(eventArrayClass)
                            }
                            print("dataArrayList \(dataResponse)")
                            DispatchQueue.main.async {
                                self.searchListTableView.reloadData()
                                 self.searchListTableView.isHidden = false
                               // self.exploreDetailArray.removeAll()
                            }
                            print("dsfs \(resJson)")
                        }else if res_message == "Record is Not Found"{
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
        print("krishna %@",exploreDetailArray.count)
        return exploreDetailArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let eventdata = exploreDetailArray[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "whoseAroundEventCell") as! WhoseAroundEventTableViewCell
            cell.eventNameLabel.text = eventdata.eventNmaeString!
            cell.backgroundColor = UIColor.clear
           // cell.eventDistanceLabel.text = "Rating: \(eventdata.distanceStringForEventString!)"
           // cell.eventReviewLabel.text =  "Reviews: \(eventdata.reviewString!)"
          //  cell.categoryLabel.text = "Survey"
            let uRL = URL (string: "\(eventdata.eventImageString!)")
            cell.eventImageView.kf.setImage(with: uRL , placeholder : UIImage(named: "dummy"))
            
            return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchTextField.resignFirstResponder()
        
        let eventdata = exploreDetailArray[indexPath.row]
        //let eventCategoryString = eventdata.cateogoryString!
        
       // print("eventCategoryString : \(eventCategoryString)")
        
//        if eventCategoryString == "People" {
//           // self.peopleIdString = eventdata.eventIdString!
//            self.performSegue(withIdentifier: "friendDetail", sender: self)
//            
//        }else  if eventCategoryString == "Event" {
        
            self.eventIdString = eventdata.eventIdString!
            self.performSegue(withIdentifier: "detailView", sender: self)
//        }
    }
    
    

    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detailView" {
            let eventDetailView = segue.destination as! SurveyDetailViewController
            eventDetailView.surveyIdString = self.eventIdString!
           // print("homepage eventIDString \(eventDetailView.friendIdString)")
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
