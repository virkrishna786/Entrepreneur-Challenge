//
//  ChangePasswordViewController.swift
//  Entrepreneur Challenge
//
//  Created by Admin media on 3/31/17.
//  Copyright © 2017 Media Mosaic service private limited. All rights reserved.
//

import UIKit
import  Alamofire
import SwiftyJSON


class ChangePasswordViewController: UIViewController ,UITextFieldDelegate {
    @IBOutlet weak var otpTextField: UITextField!
    
    @IBOutlet weak var myScrollView: UIScrollView!
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
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ChangePasswordViewController.gestureFunction1))
            self.staticView.addGestureRecognizer(tapGesture)
        } else {
            appDelegate.menuTableViewController.hideMenu()
            self.view .addSubview(appDelegate.menuTableViewController.view)
            boolValue = 0
             self.staticView.removeFromSuperview()
        }
    }
    
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func backButtonAction(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    var userIdString : Int!
    @IBAction func submitButtonAction(_ sender: UIButton) {
        
        if otpTextField.text == "" || passwordTextField.text == "" || confirmPasswordTextField.text == "" {
            parentClass.showAlertWithApiMessage(message: "Please enter all fields")
        }else {
            
            if passwordTextField.text != confirmPasswordTextField.text {
               parentClass.showAlertWithApiMessage(message: "Please enter same password")
            }
            self.apiCall()
        }
    }
    
    
    @IBOutlet weak var submitButton: UIButton!{
        didSet{
            self.submitButton.layer.cornerRadius = 15
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.otpTextField.delegate = self
        self.passwordTextField.delegate = self
        self.confirmPasswordTextField.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(UpdatePasswordViewController.gestureFunction))
        myScrollView.addGestureRecognizer(tapGesture)
        
        self.addChildViewController(appDelegate.menuTableViewController)

        
        self.passwordTextField.attributedPlaceholder = NSAttributedString(string: "password",
                                                                          attributes: [NSForegroundColorAttributeName: UIColor.darkGray])
        self.confirmPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Confirm Password",
                                                                                 attributes: [NSForegroundColorAttributeName: UIColor.darkGray])
        self.otpTextField.attributedPlaceholder = NSAttributedString(string: "Old Password", attributes: [NSForegroundColorAttributeName: UIColor.darkGray])
        
        let userId = defaults.value(forKey: "userId") as? Int
        self.userIdString = userId
        print("user %@" ,userId!)
        
        let leftImageView2 = UIImageView()
        leftImageView2.image = UIImage(named: "otp")
        
        let leftView2 = UIView()
        leftView2.addSubview(leftImageView2)
        
        leftView2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftImageView2.frame = CGRect(x: 5, y: 0, width :20, height: 23)
        
        self.otpTextField.leftView = leftView2
        self.otpTextField.leftViewMode = .always
        
        self.passwordTextField.textColor = UIColor.black
        
        let leftImageView = UIImageView()
        leftImageView.image = UIImage(named: "password")
        
        let leftView = UIView()
        leftView.addSubview(leftImageView)
        
        leftView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftImageView.frame = CGRect(x: 5, y: 0, width :20, height: 23)
        
        self.passwordTextField.leftView = leftView
        self.passwordTextField.leftViewMode = .always
        
        
        let leftImageView1 = UIImageView()
        leftImageView1.image = UIImage(named: "password")
        
        let leftView1 = UIView()
        leftView1.addSubview(leftImageView1)
        
        leftView1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftImageView1.frame = CGRect(x: 5, y: 0, width :20, height: 23)
        
        self.confirmPasswordTextField.leftView = leftView1
        self.confirmPasswordTextField.leftViewMode = .always
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func gestureFunction1(){
        appDelegate.menuTableViewController.hideMenu()
        self.view .addSubview(appDelegate.menuTableViewController.view)
        boolValue = 0
        self.staticView.removeFromSuperview()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(ChangePasswordViewController.gestureFunction1), name: NSNotification.Name(rawValue: "resetStaticView"), object: nil)
        
        // order is important - models have to be set at the end
    }
    
    
    
    func gestureFunction(){
        myScrollView.endEditing(true)
    }
    
    func apiCall(){
        
        if currentReachabilityStatus != .notReachable {
            hudClass.showInView(view: self.view)
            let urlString = "\(baseUrl)changePassword"
            
            let otpString = "\(otpTextField.text!)"
            let passwordString = "\(passwordTextField.text!)"
            let confirmPasswordString = "\(confirmPasswordTextField.text!)"
            
            let parameter = ["oldpassword" : "\(otpString)",
                "newpassword" :"\(passwordString)",
                "cpassword" : "\(confirmPasswordString)",
                "user_id": "\(self.userIdString!)"
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
                        
                        let responseCode = JSON["res_msg"] as! String
                        
                        if responseCode == "Your password has been changed successfully" {
                            hudClass.hide()
                            
                            let alertVC = UIAlertController(title: "Alert", message: "Your password has been changed successfully", preferredStyle: .alert)
                            alertVC.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction!) in self.myFunc()}))
                            self.present(alertVC, animated: true, completion: nil)
                            
                        }else if responseCode == "Old Password is not correct."{
                            
                            parentClass.showAlertWithApiMessage(message: "Old Password is not correct.")
 
                        }else {
                            hudClass.hide()
                            parentClass.showAlertWithApiMessage(message: "Some thing went wrong.")
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
    
    func myFunc() {
        self.performSegue(withIdentifier: "homview", sender: self)
        
//        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
//        for aViewController in viewControllers {
//            if aViewController is HomeViewController {
//                self.navigationController!.popToViewController(aViewController, animated: true)
//            }
//        }
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
        passwordTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()
        otpTextField.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if (textField == otpTextField) {
            
            myScrollView.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
            
        }else {
            myScrollView.setContentOffset(CGPoint(x: 0, y: 200), animated: true)
        }
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
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
