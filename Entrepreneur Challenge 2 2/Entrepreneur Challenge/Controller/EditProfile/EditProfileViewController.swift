//
//  EditProfileViewController.swift
//  Entrepreneur Challenge
//
//  Created by Admin media on 3/30/17.
//  Copyright © 2017 Media Mosaic service private limited. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class EditProfileViewController: UIViewController ,UITextFieldDelegate ,UIScrollViewDelegate  {
    @IBOutlet weak var nameTextField: UITextField!
    
  //  @IBOutlet weak var industryTableView: UITableView!
  //  @IBOutlet weak var industryTypeTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var contactTextField: UITextField!
   // let notificationName = Notification.Name("NotificationIdentifier")
    let mySpecialNotificationKey = "com.andrewcbancroft.specialNotificationKey"
    var userNameString : String?
    var IntrestIdString : String?

    
    var boolValue = 0
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
    
    @IBAction func submitButtonAction(_ sender: UIButton) {
        
        if self.nameTextField.text == "" || self.contactTextField.text == "" {
            parentClass.showAlertWithApiMessage(message: "Please enter all fields")
        }else {
            self.signUpHit()
        }
    }
    @IBOutlet weak var myScroolView: UIScrollView!
    @IBOutlet weak var signUpButton: UIButton!{
        didSet{
            
            self.signUpButton.layer.cornerRadius = 20
        }
    }
   
    var indsutryArrayClass = [IndsutryTypeArrayClass]()
    var dataArray = [DataArrayClass]()
    var latestProfileDataArray = [ProfileArrayClass]()
    var  selectedInterestArray = [String]()
    var boolForDropDown : Bool = false
    var selectedindsutryIdArray = [String]()
    var selectedIndustryCheckedArray = [String]()
    var selectedIDstring : String!
    var userIdString : Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addChildViewController(appDelegate.menuTableViewController)

        self.myScroolView.delegate = self
        self.nameTextField.delegate = self
        self.emailTextField.delegate = self
        self.contactTextField.delegate = self
       // self.industryTypeTextField.delegate = self
        
//        self.industryTableView.delegate = self
//        self.industryTableView.dataSource = self
        
        self.emailTextField.isUserInteractionEnabled = false
        let userId = defaults.value(forKey: "userId") as? Int
        self.userIdString = userId
        print("user %@" ,userId!)
        
        self.myScroolView.contentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height + 2000)
        self.myScroolView.isScrollEnabled = true
        
        let leftImageView = UIImageView()
        leftImageView.image = UIImage(named: "mesage")
        
        let leftView = UIView()
        leftView.addSubview(leftImageView)
        
        leftView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftImageView.frame = CGRect(x: 5, y: 2, width :20, height: 23)
        
        self.emailTextField.leftView = leftView
        self.emailTextField.leftViewMode = .always
        
        
        let leftImageView1 = UIImageView()
        leftImageView1.image = UIImage(named: "username")
        
        let leftView1 = UIView()
        leftView1.addSubview(leftImageView1)
        
        leftView1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftImageView1.frame = CGRect(x: 5, y: 2, width :20, height: 23)
        
        self.nameTextField.leftView = leftView1
        self.nameTextField.leftViewMode = .always
        
//        let leftImageView5 = UIImageView()
//        leftImageView5.image = UIImage(named: "interest")
//        
//        let leftView5 = UIView()
//        leftView5.addSubview(leftImageView5)
//        
//        leftView5.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        leftImageView5.frame = CGRect(x: 5, y: 0, width :20, height: 23)
//        
//        self.industryTypeTextField.leftView = leftView5
//        self.industryTypeTextField.leftViewMode = .always
        
        
        let leftImageView2 = UIImageView()
        leftImageView2.image = UIImage(named: "phone")
        
        let leftView2 = UIView()
        leftView2.addSubview(leftImageView2)
        
        leftView2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftImageView2.frame = CGRect(x: 5, y: 2, width :20, height: 23)
        
        self.contactTextField.leftView = leftView2
        self.contactTextField.leftViewMode = .always
        
//        let leftView7 = UIView()
//        leftView7.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        self.industryTypeTextField.leftView = leftView7
//        self.industryTypeTextField.leftViewMode = .always
        
        
//        let images  = UIImage(named: "dropDown")
//        let rightDropDownButton = UIButton(type: UIButtonType.custom)
//        rightDropDownButton.setImage(images, for: UIControlState.normal)
//        
//        let leftView4 = UIView()
//        leftView4.addSubview(rightDropDownButton)
//        
//        leftView4.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        rightDropDownButton.frame = CGRect(x: 5, y: 0, width :20, height: 23)
//        rightDropDownButton.addTarget(self, action: #selector(SignUpViewController.addIndustryMethod), for: UIControlEvents.touchUpInside)
//        self.industryTypeTextField.rightView = leftView4
//        self.industryTypeTextField.rightViewMode = .always
        
        self.emailTextField.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                       attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
      
        self.nameTextField.attributedPlaceholder = NSAttributedString(string: "Name",
                                                                      attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
      
        self.contactTextField.attributedPlaceholder = NSAttributedString(string: "Contact number",
                                                                         attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
//        self.industryTypeTextField.attributedPlaceholder = NSAttributedString(string: "Indsutry/Company", attributes: [NSForegroundColorAttributeName: UIColor.darkGray])
        
        
        //   let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.gestureFunction))
        //   myScroolView.canCancelContentTouches = false
        //   myScroolView.addGestureRecognizer(tapGesture)
        
        self.apiCallForGettingMyProfile()
       // self.industryTableView.isHidden = true
      //  NotificationCenter.default.addObserver(self, selector: #selector(EditProfileViewController.updateNotificationSentLabel), name: NSNotification.Name(rawValue: mySpecialNotificationKey), object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    //    func gestureFunction(){
    //       // self.industryTableView.isHidden = true
    //       // self.industryTableView.endEditing(false)
    //        myScroolView.endEditing(true)
    //    }
    
    //MARK: - Add indsutry method
    
    func  addIndustryMethod() {
       
    }
    
    func gestureFunction(){
        appDelegate.menuTableViewController.hideMenu()
        self.view .addSubview(appDelegate.menuTableViewController.view)
        boolValue = 0
        self.staticView.removeFromSuperview()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         NotificationCenter.default.addObserver(self, selector: #selector(EditProfileViewController.gestureFunction), name: NSNotification.Name(rawValue: "resetStaticView"), object: nil)
    }
    
    
    
    //MARK: - HANDLE KEYBOARD
    func handleKeyBoardWillShow(notification: NSNotification) {
        
        let dictionary = notification.userInfo
        let value = dictionary?[UIKeyboardFrameBeginUserInfoKey]
        let keyboardSize = (value as AnyObject).cgRectValue.size
        
        let inset = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.height) + 30, 0.0)
        myScroolView.contentInset = inset
        myScroolView.scrollIndicatorInsets = inset
        
    }
    
    //MARK: HANDLE KEYBOARD
    func handleKeyBoardWillHide(sender: NSNotification) {
        
        let inset1 = UIEdgeInsets.zero
        myScroolView.contentInset = inset1
        myScroolView.scrollIndicatorInsets = inset1
        myScroolView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //myScrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        emailTextField.resignFirstResponder()
        nameTextField.resignFirstResponder()
       // industryTypeTextField.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if (textField == nameTextField){
            
        }else if (textField == contactTextField || textField == emailTextField){
            
            myScroolView.setContentOffset(CGPoint(x: 0, y: 200), animated: true)
            
        }else {
            
            myScroolView.setContentOffset(CGPoint(x: 0, y: 300), animated: true)
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        if textField == industryTypeTextField {
//            
//            if boolForDropDown ==  false {
//                self.industryTableView.isHidden = false
//                boolForDropDown = true
//            }else {
//                self.industryTableView.isHidden = true
//                boolForDropDown = false
//                
//                if selectedInterestArray.isEmpty {
//                    
//                }else {
//                    let stringArray = selectedInterestArray
//                    let string = stringArray.joined(separator: ",")
//                    print("stringd \(string)")
//                    self.industryTypeTextField.text = string
//                    
//                }
//            }
//            print("sfs")
//            return false
//        }else {
        return true
//        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        myScroolView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        contactTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        return true
    }
    
    func apiCallForGettingMyProfile(){
        
        if currentReachabilityStatus != .notReachable {
            
            hudClass.showInView(view: self.view)
            
            let urlString = "\(baseUrl)myProfile"
            print("url string %@",urlString)
            
            let parameters = ["user_id": "\(self.userIdString!)"]
            
            Alamofire.request(urlString, method: .post, parameters: parameters)
                .responseJSON { response in
                    print("Success: \(response.result.isSuccess)")
                    print("Response String: \(response.result.value)")
                    
                    //to get JSON return value
                    
                    if  response.result.isSuccess {
                        hudClass.hide()
                        let result = JSON(response.result.value!)
                        //  let JSON = result as! NSDictionary
                        let responseCode = result["res_msg"].string
                        if responseCode == "Record Found" {
                            hudClass.hide()
                            let profileArray = result["Profile"].dictionary
                            let contactNumberData = profileArray?["contact_no"]?.string
                            let emailString = profileArray?["email"]?.string
                            let userNameString = profileArray?["u_name"]?.string
                           DispatchQueue.main.async {
                               self.contactTextField.text = contactNumberData!
                               self.emailTextField.text = emailString!
                               self.nameTextField.text = userNameString!
                            }
                            
                            let industryTypeArray  = result["My_Interest"].array
                            print("industry type array %@", industryTypeArray!)
                            
                            for industryArray in industryTypeArray! {
                                let industryDataArray = IndsutryTypeArrayClass()
                                industryDataArray.industryIdString =  industryArray["interest_id"].number
                                print("sdfgdsf", industryDataArray.industryIdString)
                                industryDataArray.industryName = industryArray["interest_name"].string
                                industryDataArray.interestStatus = industryArray["status"].string
                                self.indsutryArrayClass.append(industryDataArray)
                            }
                            
                            DispatchQueue.main.async {
                              //  self.industryTableView.reloadData()
                            }
                            
                        }else {
                            hudClass.hide()
                            
                            let alertVC = UIAlertController(title: "Alert", message: "Please enter valid email ", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK",style:.default,handler: nil)
                            alertVC.addAction(okAction)
                            self.present(alertVC, animated: true, completion: nil)
                        }
                        
                    }else {
                        hudClass.hide()
                        parentClass.showAlertWithApiFailure()
                    }
            }
            
        }else {
            hudClass.hide()
            parentClass.showAlert()
        }
    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return indsutryArrayClass.count
//    }
//    
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell()
//        
//        let data = indsutryArrayClass[indexPath.row]
//        cell.textLabel?.text = data.industryName
//       // print(data.industryIdString!)
//        cell.detailTextLabel?.text = "\(data.industryIdString!)"//String (data.industryIdString)
//        let dataa = DataArrayClass()
//        dataa.idString = (data.industryIdString!).stringValue
//        print("dfgs",dataa.idString)
//        
//        if data.interestStatus == "1"{
//        cell.accessoryType = .checkmark
//            self.selectedIndustryCheckedArray.append(dataa.idString)
//            self.selectedInterestArray.append(data.industryName)
//          //  self.selectedindsutryIdArray.append(data.industryIdString)
//            
//        }else {
//            cell.accessoryType = .none
//        }
//      
//        
//        return cell
//    }
//    
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        if let cell = tableView.cellForRow(at: indexPath) {
//            
//            if cell.accessoryType == .checkmark {
//                cell.accessoryType = .none
//                self.selectedInterestArray.remove(at: indexPath.row)
//               // self.selectedindsutryIdArray.remove(at: indexPath.row)
//                self.selectedIndustryCheckedArray.remove(at: indexPath.row)
//            }else {
//                
//                let datas = indsutryArrayClass[indexPath.row]
//                cell.accessoryType = .checkmark
//                self.selectedInterestArray.append((cell.textLabel?.text)!)
//                print(datas.industryIdString)
//                let idData = (datas.industryIdString!).stringValue
//                self.selectedIndustryCheckedArray.append(idData)
//                print("selecgted \(self.selectedInterestArray)")
//            }
//        }
//        
//    }
//    
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        if let cell = tableView.cellForRow(at: indexPath) {
//            
//            if cell.accessoryType == .checkmark {
//                
//                
//            }else {
//                cell.accessoryType = .none
//                self.selectedInterestArray.remove(at: indexPath.row)
//            }
//        }
//    }
    
    
    func signUpHit() {
        if currentReachabilityStatus != .notReachable {
            
            hudClass.showInView(view: self.view)
            let urlString = "\(baseUrl)profileUpdate"
            let nameString = "\(nameTextField.text!)"
            let phoneString = "\(contactTextField.text!)"
            
//            let strinCheckdArray = self.selectedIndustryCheckedArray
//            let stridfgsd = strinCheckdArray.joined(separator: ",")
//            let intrestString = stridfgsd
//            print("stringd \(intrestString)")
            
            let  parameter = ["user_id" : "\(self.userIdString!)",
                              "name" : nameString,
                              "contact_no" : phoneString,
                              "interest_id"  : "0"
            ]
            
            print("dfd \(parameter)")
            
            Alamofire.request(urlString, method: .post, parameters: parameter)
                .responseJSON { response in
                    print("Success: \(response.result.isSuccess)")
                    print("Response String: \(response.result.value)")
                    
                    //to get JSON return value
                    
                    if  response.result.isSuccess {
                        hudClass.hide()
                        let result = response.result.value
                        let resultData = result as! NSDictionary
                        
                        let responseMessage = resultData["res_msg"] as! String
                        print("response message \(responseMessage)")
                        
                        if responseMessage == "Updated successfully" {
                            hudClass.hide()
                            
                            let responseCode = resultData["profileUpdate"] as! NSDictionary
                            print("response code \(responseCode)")
                            let userNameSavedString = responseCode["u_name"] as! String
                            let intesreststring = responseCode["interest"] as! String
                            DispatchQueue.main.async {
                                defaults.set(userNameSavedString, forKey: "user_name")
                                defaults.set(intesreststring, forKey: "interest")
                                self.updateNotificationSentLabel(usernames: userNameSavedString)
                                defaults.synchronize()
                                NotificationCenter.default.post(name: Notification.Name(rawValue: self.mySpecialNotificationKey), object: nil)
                                let alertVC = UIAlertController(title: "Alert", message: "Your Profile has been updated", preferredStyle: .alert)
                                alertVC.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction!) in self.myFunc()}))
                                self.present(alertVC, animated: true, completion: nil)
                               // parentClass.showAlertWithApiMessage(message: "Your profile has been updated.")
                            }
                            
                        }else {
                            hudClass.hide()
                            
                            let alertVC = UIAlertController(title: "Alert", message: "Some thing went wrong.", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK",style:.default,handler: nil)
                            alertVC.addAction(okAction)
                            self.present(alertVC, animated: true, completion: nil)
                        }
                        
                    }else {
                        hudClass.hide()
                        parentClass.showAlertWithApiFailure()
                    }
            }
            
        }else {
            hudClass.hide()
            parentClass.showAlert()
        }
    }
    
    func myFunc() {
        
        self.performSegue(withIdentifier: "homview", sender: self)
//        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
//        for aViewController in viewControllers {
//            if aViewController is HomeViewController {
//                self.navigationController!.popToViewController(aViewController, animated: true)
//            }
//        }
    }
    
    func updateNotificationSentLabel(usernames: String) {
        defaults.set(usernames, forKey: "user_name")
        defaults.synchronize()
        
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
