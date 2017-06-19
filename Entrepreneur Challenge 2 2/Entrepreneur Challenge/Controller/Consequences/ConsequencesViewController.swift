//
//  ConsequencesViewController.swift
//  Entrepreneur Challenge
//
//  Created by Admin media on 4/3/17.
//  Copyright © 2017 Media Mosaic service private limited. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ConsequencesViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource {
    
    @IBAction func consultButtonAction(_ sender: UIButton) {
        let urlString = URL(string: "https://www.innsightconsulting.com/contact/")
        UIApplication.shared.openURL(urlString! as URL)
    }
    @IBAction func doneButtonAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "homeView", sender: self)
    }
    @IBAction func backButtonAction(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated:true)
    }
    var consequnceArray = [ConsequencesArrayClass]()
    var  interestIdString: String!
    var userIdString: Int!
    var surveyId: Int!
    let cellIdentifier = "staticCell"
    var tramIdString: String?
    @IBOutlet weak var QuestionAndanswerTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.QuestionAndanswerTableView.backgroundColor = UIColor.clear
       // self.submitButton.layer.cornerRadius = 20
        self.QuestionAndanswerTableView.register(UINib(nibName : "ConsequencesTableViewCell" ,bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.QuestionAndanswerTableView.tableFooterView = UIView()
        self.QuestionAndanswerTableView.layer.cornerRadius = 5.0
        self.QuestionAndanswerTableView.backgroundColor = UIColor.clear
        self.QuestionAndanswerTableView.separatorColor = UIColor.clear
//        self.QuestionAndanswerTableView.setNeedsLayout()
//        self.QuestionAndanswerTableView.layoutIfNeeded()
        
        let userId = defaults.value(forKey: "userId") as? Int
        self.userIdString = userId
        print("user %@" ,userId!)
        let interestIdString = defaults.string(forKey: "interest")
        self.interestIdString = interestIdString
        print("dkfkd %@",interestIdString!)
        self.apiCallForGettingQuestions()

        // Do any additional setup after loading the view.
    }
    
    func apiCallForGettingQuestions(){
        
        if currentReachabilityStatus != .notReachable {
            
            hudClass.showInView(view: self.view)
            
            let urlString = "\(baseUrl)viewConsequences"
            print("url string %@",urlString)
            
            let parameters = ["tram_id" : self.tramIdString!,
                              ]
            print("dfdfs %@",parameters)
            
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
                            
                            let industryTypeArray  = result["Consequences"].array
                            print("industry type array %@", industryTypeArray!)
                            
                            for industryArray in industryTypeArray! {
                                let industryDataArray = ConsequencesArrayClass()
                                industryDataArray.questionID =  industryArray["id"].int
                                print("fdsgds %@",industryDataArray.questionID)
                                industryDataArray.QuestionString = industryArray["q_name"].string
                                industryDataArray.answerString = industryArray["q_Answer"].string
                               // industryDataArray.optionNo = industryArray["option_no"].string
                              //  industryDataArray.optionNa = industryArray["option_na"].string
                                industryDataArray.consequenceString = industryArray["conse_text"].string
                                self.consequnceArray.append(industryDataArray)
                            }
                            
                            DispatchQueue.main.async {
                                self.QuestionAndanswerTableView.reloadData()
                            }
                            
                        }else {
                            hudClass.hide()
                            
                            let alertVC = UIAlertController(title: "Alert", message: "Not any consequences found.", preferredStyle: .alert)
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
        return self.consequnceArray.count

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        let data1 = self.consequnceArray[indexPath.row].QuestionString!
        let data2 = self.consequnceArray[indexPath.row].answerString!
        let data3 = self.consequnceArray[indexPath.row].consequenceString!
        let data4 = data1 + data2 + data3
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: data4).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
        
        return  estimatedFrame.height + 50
    }
    
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let customVIew = UIView()
//        customVIew.frame = CGRect(x: 0, y: 0, width: 320
//            , height: 20)
//        customVIew.backgroundColor = UIColor.red
//        return customVIew
//    }
//    
//    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let customVIew = UIView()
//        customVIew.frame = CGRect(x: 0, y: 0, width: 320
//            , height: 20)
//        customVIew.backgroundColor = UIColor.green
//        return customVIew
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! ConsequencesCell
        
        cell.backgroundColor = UIColor.clear
        let sepataror =  UIView()
        sepataror.frame = CGRect(x: 0, y: cell.contentView.frame.size.height - 1.0, width: cell.contentView.frame.size.width, height: 25)
        sepataror.backgroundColor = UIColor.clear
        cell.contentView.addSubview(sepataror)
        
        let questionData = consequnceArray[indexPath.row]
        cell.questionLabel.text = "Question:-" + " " + "\(questionData.QuestionString!)"
        
       // let responseString = questionData.answerString!
        cell.answerLable.text = "Answer:-" + " " + "\(questionData.answerString!)"
        cell.consequencesLabel.text = "Consequences:-" + " " + "\(questionData.consequenceString!)"
       // cell.backgroundColor = UIColor
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
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
