//
//  UpdatePasswordViewController.swift
//  Entrepreneur Challenge
//
//  Created by Admin media on 3/22/17.
//  Copyright © 2017 Media Mosaic service private limited. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class UpdatePasswordViewController: UIViewController ,UITextFieldDelegate {
    @IBOutlet weak var otpTextField: UITextField!

    @IBOutlet weak var myScrollView: UIScrollView!
 
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func backButtonAction(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitButtonAction(_ sender: UIButton) {
        
        if otpTextField.text == "" || passwordTextField.text == "" || confirmPasswordTextField.text == "" {
            parentClass.showAlertWithApiMessage(message: "Please enter all fields")
        }else {
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
        
        self.passwordTextField.attributedPlaceholder = NSAttributedString(string: "password",
                                                                          attributes: [NSForegroundColorAttributeName: UIColor.darkGray])
        self.confirmPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Confirm Password",
                                                                          attributes: [NSForegroundColorAttributeName: UIColor.darkGray])
        self.otpTextField.attributedPlaceholder = NSAttributedString(string: "OTP", attributes: [NSForegroundColorAttributeName: UIColor.darkGray])
        
        
        
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
    
    
    func gestureFunction(){
        myScrollView.endEditing(true)
    }
    
    
    func apiCall(){
        
        if currentReachabilityStatus != .notReachable {
            
            hudClass.showInView(view: self.view)
            
            let urlString = "\(baseUrl)passwordRecovery"
            
            let otpString = "\(otpTextField.text!)"
            let passwordString = "\(passwordTextField.text!)"
            let confirmPasswordString = "\(confirmPasswordTextField.text!)"
           
            let parameter = ["otp" : "\(otpString)",
                             "newpassword" :"\(passwordString)",
                             "cpassword" : "\(confirmPasswordString)"
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
                        
                        if responseCode == "Your Password Update Successfully" {
                            hudClass.hide()
                            
                            let alertVC = UIAlertController(title: "Alert", message: "Your Password Update Successfully ", preferredStyle: .alert)
                            alertVC.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction!) in self.myFunc()}))
                            self.present(alertVC, animated: true, completion: nil)
                            
                            
                        }else {
                            hudClass.hide()
                          parentClass.showAlertWithApiMessage(message: "Some thing went wrong")
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
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
        for aViewController in viewControllers {
            if aViewController is ViewController {
                self.navigationController!.popToViewController(aViewController, animated: true)
            }
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
