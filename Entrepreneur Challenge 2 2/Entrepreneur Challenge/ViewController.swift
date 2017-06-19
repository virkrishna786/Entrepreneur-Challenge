//
//  ViewController.swift
//  Entrepreneur Challenge
//
//  Created by Admin media on 3/20/17.
//  Copyright © 2017 Media Mosaic service private limited. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController ,UITextFieldDelegate {
    
    @IBOutlet weak var myScrollView: UIScrollView!
    @IBAction func signUpButtonAction(_ sender: UIButton) {
       self.performSegue(withIdentifier: "signUpView", sender: self)
    }
    @IBAction func forgetPasswordButtonAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "forgotView", sender: self)
    }
    @IBAction func submitButtonAction(_ sender: UIButton) {
        if userNameTextField.text == "" || passwordTextField.text == "" {
            let alertVC = UIAlertController(title: "Alert", message: "Please enter  email and password", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK",style:.default,handler: nil)
            alertVC.addAction(okAction)
            self.present(alertVC, animated: true, completion: nil)
            
        }else{
            self.apiCall()
        }
        
    }
    @IBOutlet weak var submitButton: UIButton!{
        didSet{
            submitButton.layer.cornerRadius = 15
        }
    }
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    
    
    var activeField = UITextField?.self
    var userIdString : String? = ""
    var tokenIdSting : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.userNameTextField.delegate = self
        self.passwordTextField.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.gestureFunction))
        myScrollView.addGestureRecognizer(tapGesture)
        
        self.userNameTextField.attributedPlaceholder = NSAttributedString(string: "UserName",
                                                                          attributes: [NSForegroundColorAttributeName: UIColor.darkGray])
        self.passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                          attributes: [NSForegroundColorAttributeName: UIColor.darkGray])
        self.userNameTextField.textColor = UIColor.black
        self.passwordTextField.textColor = UIColor.black
        
        let leftImageView = UIImageView()
        leftImageView.image = UIImage(named: "username")
        
        let leftView = UIView()
        leftView.addSubview(leftImageView)
        
        leftView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftImageView.frame = CGRect(x: 5, y: 0, width :20, height: 23)
        
        self.userNameTextField.leftView = leftView
        self.userNameTextField.leftViewMode = .always
        
        
        let leftImageView1 = UIImageView()
        leftImageView1.image = UIImage(named: "password")
        
        let leftView1 = UIView()
        leftView1.addSubview(leftImageView1)
        
        leftView1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftImageView1.frame = CGRect(x: 5, y: 0, width :20, height: 23)
        
        self.passwordTextField.leftView = leftView1
        self.passwordTextField.leftViewMode = .always
        
       //MARK: -  Naviagtion to HomeView on already logged in 
        
       // let nameString =  defaults.value(forKey: "user_name") as? String
        let userdskf = defaults.string(forKey: "user_name")
        
        guard let usridsd = userdskf, !usridsd.isEmpty else {
            print("bla bla")
            return
        }
        self.performSegue(withIdentifier: "preHomeView", sender: self)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    func gestureFunction(){
        myScrollView.endEditing(true)
    }
    
    func apiCall(){
        
        if currentReachabilityStatus != .notReachable {
            
            hudClass.showInView(view: self.view)
            let  urlString = "\(baseUrl)userLogin"
            let userString = "\(userNameTextField.text!)"
            let passwordString = "\(passwordTextField.text!)"
            
            
            let  parameter = ["email" : userString,
                              "password" : passwordString
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
                        let JSON = result as! NSDictionary
                        
                        print("result %@",response.result.value! )
                        
                        let responseCode = JSON["SurveyApp"] as! NSDictionary
                        
                        print("response code \(responseCode)")
                        
                        let responseMessage = responseCode["res_msg"] as! String
                        print("response message \(responseMessage)")
                        
                        if responseMessage == "Login successfuly" {
                            hudClass.hide()
                            print("success");
                            
                            let userIdString = responseCode["user_id"] as! NSNumber
                            let userNameSavedString = responseCode["u_name"] as! String
                            let userEmailString = responseCode["email"] as! String
                            let interestType = responseCode["interest"] as! String
                            defaults.set(interestType, forKey: "interest")
                            defaults.set(userIdString, forKey: "userId")
                            defaults.set(userNameSavedString, forKey: "user_name")
                            defaults.set(userEmailString, forKey: "user_email")
                            defaults.synchronize()
                            self.userNameTextField.text = ""
                            self.passwordTextField.text = ""
                            self.performSegue(withIdentifier: "preHomeView", sender: self)
                            
                        }else if responseMessage == "Email id and Password Does Not Match"{
                            
                            hudClass.hide()
                            parentClass.showAlertWithApiMessage(message: responseMessage)
                            
                        }else{
                            hudClass.hide()
                            
                            let alertVC = UIAlertController(title: "Alert", message: "Please enter valid email and password", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK",style:.default,handler: nil)
                            alertVC.addAction(okAction)
                            self.present(alertVC, animated: true, completion: nil)
                        }
                        print("json \(JSON)")
                        
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
    
    //MARK: - HANDLE KEYBOARD
    func handleKeyBoardWillShow(notification: NSNotification) {
        
        let dictionary = notification.userInfo
        let value = dictionary?[UIKeyboardFrameBeginUserInfoKey]
        let keyboardSize = (value as AnyObject).cgRectValue.size
        
        let inset = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.height) + 30, 0.0)
        myScrollView.contentInset = inset
        myScrollView.scrollIndicatorInsets = inset
        
    }
    
    //MARK: HANDLE KEYBOARD
    func handleKeyBoardWillHide(sender: NSNotification) {
        
        let inset1 = UIEdgeInsets.zero
        myScrollView.contentInset = inset1
        myScrollView.scrollIndicatorInsets = inset1
        myScrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //myScrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        userNameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        myScrollView.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        myScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

