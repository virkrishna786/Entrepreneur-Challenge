//
//  SignUpViewController.swift
//  Entrepreneur Challenge
//
//  Created by Admin media on 3/20/17.
//  Copyright © 2017 Media Mosaic service private limited. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class SignUpViewController: UIViewController ,UITextFieldDelegate ,UIScrollViewDelegate {
    @IBOutlet weak var nameTextField: UITextField!

    @IBOutlet weak var customView: UIView!
    //@IBOutlet weak var industryTableView: UITableView!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var contactTextField: UITextField!
    @IBAction func signInButtonAction(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    @IBAction func signUpButtonAction(_ sender: UIButton) {
        
        if nameTextField.text == "" {
            parentClass.showAlertWithApiMessage(message: "Please enter your Name.")
        }else if  emailTextField.text == "" {
            parentClass.showAlertWithApiMessage(message: "Please enter your Email.")

        }else if contactTextField.text == "" {
            parentClass.showAlertWithApiMessage(message: "Please enter your Number.")

        }else if passwordTextField.text == ""  {
            parentClass.showAlertWithApiMessage(message: "Please enter your Password.")
        }else if (passwordTextField.text?.characters.count)! < 6 {
            
          parentClass.showAlertWithApiMessage(message: "This password is too short")
            
        }else if passwordTextField.text != confirmPasswordTextField.text {
            parentClass.showAlertWithApiMessage(message: "Please enter same Password.")
        }else if confirmPasswordTextField.text == "" {
                parentClass.showAlertWithApiMessage(message: "Please enter Your Confirm Password.")
            }else  {
                let emailString = parentClass.validateEmailAddress(yourEmail: emailTextField.text!)
                if emailString == false{
                parentClass.showAlertWithApiMessage(message: "Please enter valid email Address.")
                }else {
                self.signUpHit()
                }
        }
    }
//    
    
    @IBOutlet weak var myScroolView: UIScrollView!
    @IBOutlet weak var signUpButton: UIButton!{
        didSet{
            self.signUpButton.layer.cornerRadius = 15
        }
    }
    @IBAction func backButtonAction(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
  var indsutryArrayClass = [IndsutryTypeArrayClass]()
    var  selectedInterestArray = [String]()
    var boolValue = [Bool]()
    var boolForDropDown : Bool = false
    var selectedindsutryIdArray = [String]()
    var selectedIDstring : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myScroolView.delegate = self
        self.nameTextField.delegate = self
        self.emailTextField.delegate = self
        self.contactTextField.delegate = self
        self.passwordTextField.delegate = self
       // self.industryTypeTextField.delegate = self
        self.confirmPasswordTextField.delegate = self
        
//        self.industryTableView.delegate = self
//        self.industryTableView.dataSource = self
        self.myScroolView.contentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height + 2000)
        self.myScroolView.isScrollEnabled = true
        
        let leftImageView = UIImageView()
        leftImageView.image = UIImage(named: "mesage")
        
        let leftView = UIView()
        leftView.addSubview(leftImageView)
        
        leftView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftImageView.frame = CGRect(x: 5, y: 0, width :20, height: 23)
        
        self.emailTextField.leftView = leftView
        self.emailTextField.leftViewMode = .always
        
        
        let leftImageView1 = UIImageView()
        leftImageView1.image = UIImage(named: "username")
        
        let leftView1 = UIView()
        leftView1.addSubview(leftImageView1)
        
        leftView1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftImageView1.frame = CGRect(x: 5, y: 0, width :20, height: 23)
        
        self.nameTextField.leftView = leftView1
        self.nameTextField.leftViewMode = .always
        
        
        let leftImageView2 = UIImageView()
        leftImageView2.image = UIImage(named: "phone")
        
        let leftView2 = UIView()
        leftView2.addSubview(leftImageView2)
        
        leftView2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftImageView2.frame = CGRect(x: 5, y: 0, width :20, height: 23)
        
        self.contactTextField.leftView = leftView2
        self.contactTextField.leftViewMode = .always
        
//        let leftView7 = UIView()
//        leftView7.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        self.industryTypeTextField.leftView = leftView7
//        self.industryTypeTextField.leftViewMode = .always
//        
//        let leftImageView9 = UIImageView()
//        leftImageView9.image = UIImage(named: "interest")
//        
//        let leftView9 = UIView()
//        leftView9.addSubview(leftImageView9)
//        
//        leftView9.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        leftImageView9.frame = CGRect(x: 5, y: 0, width :20, height: 23)
//        
//        self.industryTypeTextField.leftView = leftView9
//        self.industryTypeTextField.leftViewMode = .always
//        
//        
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
        
        let leftImageView5 = UIImageView()
        leftImageView5.image = UIImage(named: "password")
        
        let leftView5 = UIView()
        leftView5.addSubview(leftImageView5)
        
        leftView5.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftImageView5.frame = CGRect(x: 5, y: 0, width :20, height: 23)
        
        self.passwordTextField.leftView = leftView5
        self.passwordTextField.leftViewMode = .always
        
        let leftImageView6 = UIImageView()
        leftImageView6.image = UIImage(named: "password")
        
        let leftView6 = UIView()
        leftView6.addSubview(leftImageView6)
        
        leftView6.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftImageView6.frame = CGRect(x: 5, y: 0, width :20, height: 23)
        
        self.confirmPasswordTextField.leftView = leftView6
        self.confirmPasswordTextField.leftViewMode = .always
        
       
        self.emailTextField.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                       attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        self.passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                          attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        self.nameTextField.attributedPlaceholder = NSAttributedString(string: "Name",
                                                                      attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        self.confirmPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Confirm  Password",
                                                                                 attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        self.contactTextField.attributedPlaceholder = NSAttributedString(string: "Contact number",
                                                                       attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
//        self.industryTypeTextField.attributedPlaceholder = NSAttributedString(string: "Indsutry/Company", attributes: [NSForegroundColorAttributeName: UIColor.darkGray])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.gestureFunction))
       // self.customView.canCancelContentTouches = false
        self.customView.addGestureRecognizer(tapGesture)
        
       // self.apiCallForGettingIndustryType()
//        self.industryTableView.isHidden = true

        // Do any additional setup after loading the view.
    }
    
    func gestureFunction(){
        self.nameTextField.resignFirstResponder()
        self.contactTextField.resignFirstResponder()
        self.emailTextField.resignFirstResponder()
//        self.industryTableView.isHidden = true
//        boolForDropDown = false
//        
//        if selectedInterestArray.isEmpty {
//            
//        }else {
//            let stringArray = selectedInterestArray
//            let string = stringArray.joined(separator: ",")
//            print("stringd \(string)")
//        }

        myScroolView.endEditing(true)
    }

    //MARK: - Add indsutry method 
    
    func  addIndustryMethod() {
        
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
        passwordTextField.resignFirstResponder()
        nameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()
       // industryTypeTextField.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if (textField == nameTextField){
            
        }else if (textField == contactTextField || textField == emailTextField ) {
            
            myScroolView.setContentOffset(CGPoint(x: 0, y: 200), animated: true)
 
        }else {
        
        myScroolView.setContentOffset(CGPoint(x: 0, y: 300), animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        myScroolView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()
        contactTextField.resignFirstResponder()
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        if textField == self.industryTypeTextField {
////            if boolForDropDown ==  false {
////                self.industryTableView.isHidden = false
////                 self.emailTextField.resignFirstResponder()
////                self.nameTextField.resignFirstResponder()
////                self.contactTextField.resignFirstResponder()
////                self.passwordTextField.resignFirstResponder()
////                self.confirmPasswordTextField.resignFirstResponder()
////                boolForDropDown = true
////            }else {
////                self.industryTableView.isHidden = true
////                boolForDropDown = false
////                
////                if selectedInterestArray.isEmpty {
////                    parentClass.showAlertWithApiMessage(message: "Please Select Category")
////                    
////                }else {
////                    let stringArray = selectedInterestArray
////                    let string = stringArray.joined(separator: ",")
////                    print("stringd \(string)")
////                    self.industryTypeTextField.text = string
////                    
////                }
////            }
//            print("sfs")
//
//            return false
//        }else {
            return true
//        }
    }
    
    /*
    
    func apiCallForGettingIndustryType(){
        
        if currentReachabilityStatus != .notReachable {
            
            hudClass.showInView(view: self.view)
            
            let urlString = "\(baseUrl)interestList"
            print("url string %@",urlString)
            
            Alamofire.request(urlString, method: .post)
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
                            
                            let industryTypeArray  = result["SurveyApp"].array
                            print("industry type array %@", industryTypeArray!)
                            
                            for industryArray in industryTypeArray! {
                               let industryDataArray = IndsutryTypeArrayClass()
                                industryDataArray.industryIdString = industryArray["interest_id"].number
                                print("fdsgds %@",industryDataArray.industryIdString)
                                industryDataArray.industryName = industryArray["interest_name"].string
                               self.indsutryArrayClass.append(industryDataArray)
                            }
                            
                            DispatchQueue.main.async {
                               // self.industryTableView.reloadData()
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

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return indsutryArrayClass.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let data = indsutryArrayClass[indexPath.row]
        cell.textLabel?.text = data.industryName
        print(data.industryIdString!)
        cell.detailTextLabel?.text = "\(data.industryIdString!)"//String (data.industryIdString)
      //  let dataa = IndsutryTypeArrayClass()
       // data.idString = dataa.industryIdString

//        if selectedInterestArray.isEmpty {
//            
//        }else {
//            
//            print("dskfjgk %@",selectedInterestArray[indexPath.row])
//            
//        if (selectedInterestArray[indexPath.row]).isEmpty {
//           boolValue.append(false)
//        }else {
//            boolValue.append(true)
//        }
//        
//        if (boolValue[indexPath.row]){
//            cell.accessoryType = .checkmark
//        }else {
//            cell.accessoryType = .none
//        }
//            
//        }
        
//               print("dfsgsd",sdfkasd)
//            cell.accessoryType = .none
//        
//        if cell.accessoryType == .checkmark {
//            cell.accessoryType = .checkmark
//        }else {
//            cell.accessoryType = .none
//        }
//        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
                self.selectedInterestArray.remove(at: indexPath.row)
                self.selectedindsutryIdArray.remove(at: indexPath.row)
                
            }else {
            
            let datas = indsutryArrayClass[indexPath.row]
            cell.accessoryType = .checkmark
            self.selectedInterestArray.append((cell.textLabel?.text)!)
            print(datas.industryIdString)
                let datasString =  datas.industryIdString!.stringValue
            self.selectedindsutryIdArray.append(datasString)
            print("selecgted \(self.selectedInterestArray)")
            print("dsfk ,\(self.selectedindsutryIdArray)")
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            
            if cell.accessoryType == .checkmark {
                
                
            }else {
            cell.accessoryType = .none
            //self.selectedInterestArray.remove(at: indexPath.row)
            }
        }
    }
    
  */
    func signUpHit() {
        if currentReachabilityStatus != .notReachable {
            
            hudClass.showInView(view: self.view)
            let urlString = "\(baseUrl)userRegistration"
            let emailString = "\(emailTextField.text!)"
            let passwordString = "\(passwordTextField.text!)"
            let nameString = "\(nameTextField.text!)"
            let phoneString = "\(contactTextField.text!)"
            let confirmPasswordString = "\(confirmPasswordTextField.text!)"
         
//            let stringArray = self.selectedindsutryIdArray
//            let string = stringArray.joined(separator: ",") + ","
//            print("stringd \(string)")

            let  parameter = ["email" : emailString ,
                              "password" : passwordString ,
                              "name" : nameString,
                              "contact_no" : phoneString,
                              "cpassword" : confirmPasswordString,
                              "interest" : "0"
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
                        
                        let responseCode = resultData["SurveyApp"] as! NSDictionary
                        
                        print("response code \(responseCode)")
                        
                        let responseMessage = responseCode["res_msg"] as! String
                        print("response message \(responseMessage)")
                        
                        if responseMessage == "you have successfully registered" {
                            hudClass.hide()
                            
                            let userIdString = responseCode["user_id"] as! NSNumber
                            let userNameSavedString = responseCode["u_name"] as! String
                            let emailString = responseCode["email"] as! String
                            let industryType = responseCode["interest"] as! String
                            defaults.set(industryType, forKey: "interest")
                            defaults.set(userIdString, forKey: "userId")
                            defaults.set(userNameSavedString, forKey: "user_name")
                            defaults.set(emailString, forKey: "user_email")
                            defaults.set(industryType, forKey: "interest")
                            defaults.synchronize()
                            self.performSegue(withIdentifier: "preHomeView", sender: self)
                            
                        }else if responseMessage == "Email Id Already Exists"{
                         parentClass.showAlertWithApiMessage(message: "Email Already Exists")
                        }else   {
                            hudClass.hide()
                            
                            let alertVC = UIAlertController(title: "Alert", message: "Some thing went wrong", preferredStyle: .alert)
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
