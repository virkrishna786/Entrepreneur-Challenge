//
//  RatingAndReviewController.swift
//  CruzSortMeApp
//
//  Created by Admin media on 1/13/17.
//  Copyright © 2017 Gopal Gupta. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


protocol ratingViewControllerDelegate {
    func backFromRatingController(info: Bool)
}


class RatingAndReviewController: UIViewController ,FloatRatingViewDelegate ,UITextFieldDelegate {

    var eventIDString : Int!
    var interestIdString: String!
    var userIdString : Int!
    var ratingString : String!
    var delegate: ratingViewControllerDelegate? = nil

    @IBAction func backbuttonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    
    }
    @IBOutlet weak var submitButton: UIButton! {
        didSet {
            self.submitButton.layer.cornerRadius = 25
        }
    }
    @IBAction func submitButtonAction(_ sender: UIButton) {
        DispatchQueue.global(qos: .background).async {
            self.reviewApiHit()
        }
    }
    @IBOutlet weak var reviewTextField: UITextField!
    @IBOutlet weak var starRatingView: FloatRatingView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reviewTextField.delegate = self
        
        let userId = defaults.value(forKey: "userId") as? Int
        self.userIdString = userId
        print("user %@" ,userId!)
        
        let interestIdString = defaults.string(forKey: "interest")
        self.interestIdString = interestIdString
        print("dkfkd %@",interestIdString!)

        self.reviewTextField.layer.cornerRadius = 5
        self.starRatingView.emptyImage = UIImage(named: "starGrayIcon")
        self.starRatingView.fullImage = UIImage(named: "starLightIcon")
        self.starRatingView.delegate = self
        self.starRatingView.contentMode = UIViewContentMode.scaleAspectFit
        self.starRatingView.maxRating = 5
        self.starRatingView.minRating = 1
        self.starRatingView.rating = 5
        self.starRatingView.editable = true
        self.starRatingView.halfRatings = true
        self.starRatingView.floatRatings = false

        self.ratingString = "1"
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        
        self.view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    func dismissKeyboard() {
        self.reviewTextField.resignFirstResponder()
               self.view.endEditing(true)
    }

    
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
        self.ratingString = NSString(format: "%.2f", self.starRatingView.rating) as String
        print("ratingString \(self.ratingString!)")
       
    }
    
        // print("floating value : \(NSString(format: "%.2f", self.floatRatingView.rating) as String)")
        // self.liveLabel.text = NSString(format: "%.2f", self.floatRatingView.rating) as String
 
    
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Float) {
        print("krishdsdgfasd")
    }
    
    func reviewApiHit() {
        
        let url = "\(baseUrl)saveReview"
        let parameter = ["rating" : self.ratingString!,
                         "user_id" : "\(self.userIdString!)",
                         "s_id" : "\(self.eventIDString!)",
                         "review_comment" : reviewTextField.text!,
                         "cat_id" : self.interestIdString!]
        
        print("parameter \(parameter)")
        
        Alamofire.request( url, method : .post , parameters: parameter ).responseJSON { (responseObject) -> Void in
            
            print(responseObject)
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                let  res_message = resJson["res_msg"].string
                if res_message! == "Your review saved successfully" {
                    let alertVC = UIAlertController(title: "Alert", message: "Your review saved successfully", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK",style:.default,handler: self.alertAction)
                    alertVC.addAction(okAction)
                    self.present(alertVC, animated: true, completion: nil)
                    
                }else {
                    let alertVC = UIAlertController(title: "Alert", message: "Some thing went wrong", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK",style:.default,handler: nil)
                    alertVC.addAction(okAction)
                    self.present(alertVC, animated: true, completion: nil)
                }
            }
            if responseObject.result.isFailure {
                let error  = responseObject.result.error!  as NSError
                print("\(error)")
                
            }
        }
    }

    func alertAction(action : UIAlertAction) {
    self.dismiss(animated: true, completion: nil)
        
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
