//
//  MessageListViewControlelr.swift
//  Entrepreneur Challenge
//
//  Created by Admin media on 3/29/17.
//  Copyright © 2017 Media Mosaic service private limited. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MessageListViewControlelr: UIViewController , UITableViewDelegate ,UITableViewDataSource {
    
    var boolValue = 0
    
    @IBAction func menuButtonAction(_ sender: UIButton) {
        if boolValue == 0 {
            appDelegate.menuTableViewController.showMenu()
            self.view .addSubview(appDelegate.menuTableViewController.view)
            boolValue = 1
            
        } else {
            appDelegate.menuTableViewController.hideMenu()
            self.view .addSubview(appDelegate.menuTableViewController.view)
            boolValue = 0
        }
        
    }
    @IBOutlet weak var eventDetailTableView: UITableView!
    let cellIdentifier = "messageCellIdentifier"
    var numberofEvents :Int!
    var  exploreDetailArray = [MessageListArrayClass]()
    var peopleIdString : String!
    var eventIdString : String!
    var userIdString : Int!
    var  interestIdString: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.eventDetailTableView.delegate = self
        self.eventDetailTableView.dataSource = self
        
        
        
        //   let useriDstring = defaults.string(forKey: "userId")
        //        self.userIdString = useriDstring!
        //        print("userid \(useriDstring!)")
        
        self.eventDetailTableView.register(UINib(nibName : "MessageCell" ,bundle: nil), forCellReuseIdentifier: cellIdentifier)
       // self.eventDetailTableView.separatorColor = UIColor.red
        self.eventDetailTableView.backgroundColor = UIColor.clear
        self.eventDetailTableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        self.addChildViewController(appDelegate.menuTableViewController)
        self.eventDetailTableView.tableFooterView = UIView()
        
        
        let userId = defaults.value(forKey: "userId") as? Int
        self.userIdString = userId
        print("user %@" ,userId!)
        let interestIdString = defaults.string(forKey: "interest")
        self.interestIdString = interestIdString
        print("dkfkd %@",interestIdString!)
        self.eventDetailTableView.isHidden = true
       
       // self.whoseAroundApiHit()
        
        
        // Do any additional setup after loading the view.
    }
    
    
    func whoseAroundApiHit() {
        
        if currentReachabilityStatus != .notReachable {
            
            let parameter = ["user_id" : "\(self.userIdString!)",
                             "interest_id" : self.interestIdString!
            ]
            
            let url = "\(baseUrl)getMessage"
            
            hudClass.showInView(view: self.view)
            
            Alamofire.request( url, method : .post , parameters : parameter).responseJSON { (responseObject) -> Void in
                
                print(responseObject)
                
                print("rsposneIbekjds \(responseObject)")
                if responseObject.result.isSuccess {
                    hudClass.hide()
                    let resJson = JSON(responseObject.result.value!)
                    
                    print("resJsonf \(resJson)")
                    let  res_message  = (resJson["res_msg"].string)!
                    print("res_messafe \(res_message)")
                    
                    if res_message == "Record Found" {
                        let dataResponse = resJson["Message"].array
                        
                        self.numberofEvents = dataResponse?.count
                        print("numberofEventsdetail \(self.numberofEvents)")
                        
                        for eventArray in dataResponse! {
                            let eventArrayClass = MessageListArrayClass()
                            
                            eventArrayClass.messageId = eventArray["msg_id"].int
                            eventArrayClass.messageName = eventArray["msg_text"].string
                          
                            self.exploreDetailArray.append(eventArrayClass)
                        }
                        print("dataArrayList \(dataResponse)")
                        
                        DispatchQueue.main.async {
                            self.eventDetailTableView.reloadData()
                        }
                        print("dsfs \(resJson)")
                    }else {
                        print("sdkgdksbhgks")
                        self.eventDetailTableView.isHidden = true
                        let label = UILabel()
                        self.view.addSubview(parentClass.setBlankView(label: label))
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
        return exploreDetailArray.count    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let views = UIView()
        views.backgroundColor = UIColor.clear
        return views
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let eventdata = exploreDetailArray[indexPath.section]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)! as! MessageCellType
        cell.messageNameLabel.text = eventdata.messageName!
       // cell.messageNameLabel.sizeToFit()
        
        let cellView = UIView()
        cellView.frame = CGRect(x: 0, y: cell.contentView.frame.size.height - 1 , width: cell.contentView.frame.size.width , height: 10)
        cellView.backgroundColor = UIColor.clear
        cell.contentView.addSubview(cellView)
        
        cell.layer.shadowOffset = CGSize(width: 1, height: 0)
        cell.layer.shadowColor = UIColor.clear.cgColor
        cell.layer.shadowRadius = 5.0
        cell.layer.shadowOpacity = 25
        cell.clipsToBounds = false
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let eventdata = exploreDetailArray[indexPath.row]
//        let eventCategoryString = eventdata.cateogoryString!
//        
//        print("eventCategoryString : \(eventCategoryString)")
//        
//        if eventCategoryString == "People" {
//            self.peopleIdString = eventdata.eventIdString!
//            self.performSegue(withIdentifier: "friendDetail", sender: self)
//            
//        }else  if eventCategoryString == "Event" {
//            self.eventIdString = eventdata.eventIdString!
//            self.performSegue(withIdentifier: "eventDetail", sender: self)
//        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
