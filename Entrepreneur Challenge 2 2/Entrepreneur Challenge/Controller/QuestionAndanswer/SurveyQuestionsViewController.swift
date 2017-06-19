//
//  SurveyQuestionsViewController.swift
//  Entrepreneur Challenge
//
//  Created by Admin media on 3/28/17.
//  Copyright © 2017 Media Mosaic service private limited. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SurveyQuestionsViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource{

    @IBAction func backButtonAction(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    @IBAction func submitButtonAction(_ sender: UIButton) {
        
        var flagData = false
        for var i in (0..<self.selectedArray.count){
            let data = String(describing: self.selectedArray[i])
            print("daau" ,data)
            if data.contains("-0"){
                flagData = true
                i += 1
                print("hulalla")
            }else {
                flagData = false
  
            }
//            if self.selectedArray.contains("-0") {
//               
//            }else {
//  
//            }
            
//            if  data  == "0" {
//                               print("yerty",i)
//            }else {
//            }
          }
            
            if flagData == true {
                parentClass.showAlertWithApiMessage(message: "Please answer all the questions.")
            }else {
                self.submitQuestionAndAnswer()
            }
    }
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var QuestionAndanswerTableView: UITableView!
    @IBOutlet weak var surveyNameLabel: UILabel!
    let cellIdentifier = "questionCellIdentifier"
    
    var surveyQuestionArray = [SurveyQuestionArrayClass]()
    var riskArray = [SurveyResultArrayClass]()
    var scoreArray = [ScoredArrayClass]()
    var  interestIdString: String!
    var surveyName : String!
    var surveyId: Int!
    var s_cat_id : Int!
    var userIdString: Int!
    var boolValueForYesButton : Bool! = false
    var boolValueForNoButton : Bool! = false
    var boolValueForOtherButton : Bool! = false
    var selectedArray : NSMutableArray!
    var p_key_Array : NSMutableArray!
    var term_id_string : String?
    
    var HighScoreString : Int?
    var lowScoreString : Int?
    var moderateScoreString : Int?
    
    var totalQuestions: Int!
    var leftQuestions : Int!
    var correctQuestion : Int!
    var incorrectQuestion : Int!
    var catName : String!
    var emfStringa : String!
    var riskLabel : String!
    var tramIdString : String?
    var  p_String: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedArray = []
        self.p_key_Array = []
        self.QuestionAndanswerTableView.backgroundColor = UIColor.clear
        self.surveyNameLabel.text = self.surveyName!
        self.submitButton.layer.cornerRadius = 20
        self.QuestionAndanswerTableView.register(UINib(nibName : "QuestionCell" ,bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.QuestionAndanswerTableView.tableFooterView = UIView()
        self.QuestionAndanswerTableView.layer.cornerRadius = 5.0
        
        
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
            let urlString = "\(baseUrl)Questionnaire"
            print("url string %@",urlString)
            
            let parameters = ["cat_id" : "\(self.s_cat_id!)",
                              "s_id" : "\(self.surveyId!)",
                               "user_id" : "\(self.userIdString!)"]
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
                            
                            let industryTypeArray  = result["Questionnaire"].array
                            print("industry type array %@", industryTypeArray!)
                            
                            for industryArray in industryTypeArray! {
                                let industryDataArray = SurveyQuestionArrayClass()
                                //self.p_key_Array.add("")
                                let term_id = industryArray["term_id"].string
                                if term_id == "0"{
                                   self.term_id_string = "0"
                                }else {
                                    self.term_id_string = term_id
                                }
                                industryDataArray.questionId =  industryArray["id"].int
                                print("fdsgds %@",industryDataArray.questionId)
                                industryDataArray.questionTextString = industryArray["q_name"].string
                                industryDataArray.yesOptionString = industryArray["option_yes"].string
                                industryDataArray.noOptionString = industryArray["option_no"].string
                                industryDataArray.OtherOtpionString = industryArray["option_na"].string
                                industryDataArray.myAnswer = industryArray["my_answer"].string
                                let datasting = industryArray["my_answer"].string
                                let questionIdInt = industryArray["id"].int
                                industryDataArray.p_key_id = industryArray["p_key_id"].string
                                industryDataArray.term_id = industryArray["term_id"].string
                                let p_keu_id  =  industryArray["p_key_id"].string

                                self.selectedArray.add("\(questionIdInt!)" + "-" + datasting!)
                                self.p_key_Array.add(p_keu_id!)
                                self.surveyQuestionArray.append(industryDataArray)
                            }
                            
                            DispatchQueue.main.async {
                                print("self,termiof ",self.term_id_string!)
                                self.QuestionAndanswerTableView.reloadData()
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

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.surveyQuestionArray.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
              let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! QuestionCellType
        cell.noButton.setImage(UIImage(named: "radioBlankButton"), for: UIControlState.normal)
        cell.otherOptionButton.setImage(UIImage(named: "radioBlankButton"), for: UIControlState.normal)
        cell.yesButton.setImage(UIImage(named: "radioBlankButton"), for: UIControlState.normal)
        
        let questionData = surveyQuestionArray[indexPath.row]
        cell.surveyQuestionLabel.text = "\(questionData.questionTextString!)"
        cell.yesButton.setTitle("\(questionData.yesOptionString!)", for: UIControlState.normal)
        cell.noButton.setTitle("\(questionData.noOptionString!)", for: UIControlState.normal)
        cell.otherOptionButton.setTitle("\(questionData.OtherOtpionString!)", for: UIControlState.normal)
        cell.backgroundColor = UIColor.clear
        
//        let myAnswer = questionData.myAnswer!
//        print("myAnswer ",myAnswer)
//        print("question id ",questionData.questionId)
//        
       print("self.selectedArray",self.selectedArray[indexPath.row])

        
        print("dfjkdfks ",(self.selectedArray[indexPath.row]))
        let P_keyData = questionData.p_key_id!
        self.p_key_Array.replaceObject(at: indexPath.row, with: P_keyData)
        print("kdfkd ",self.p_key_Array)
        
        if  ((self.selectedArray[indexPath.row]) as! String).isEmpty {
                 }else if ((self.selectedArray[indexPath.row]) as! String) ==  "\(questionData.questionId!)" + "-Yes" {
            cell.noButton.setImage(UIImage(named: "radioBlankButton"), for: UIControlState.normal)
            cell.otherOptionButton.setImage(UIImage(named: "radioBlankButton"), for: UIControlState.normal)
            cell.yesButton.setImage(UIImage(named: "radioFilledButton"), for: UIControlState.normal)
        }else if ((self.selectedArray[indexPath.row]) as! String) ==  "\(questionData.questionId!)" + "-No" {
            cell.noButton.setImage(UIImage(named: "radioFilledButton"), for: UIControlState.normal)
            cell.otherOptionButton.setImage(UIImage(named: "radioBlankButton"), for: UIControlState.normal)
            cell.yesButton.setImage(UIImage(named: "radioBlankButton"), for: UIControlState.normal)
        }else if ((self.selectedArray[indexPath.row]) as! String) ==  "\(questionData.questionId!)" + "-Na" || ((self.selectedArray[indexPath.row]) as! String) ==  "\(questionData.questionId!)" + "-NA" || ((self.selectedArray[indexPath.row]) as! String) ==  "\(questionData.questionId!)" + "-nA"{
            cell.noButton.setImage(UIImage(named: "radioBlankButton"), for: UIControlState.normal)
            cell.otherOptionButton.setImage(UIImage(named: "radioFilledButton"), for: UIControlState.normal)
            cell.yesButton.setImage(UIImage(named: "radioBlankButton"), for: UIControlState.normal)
        }else {
            
            
        }
        
        
        
        cell.yesButton.addTarget(self, action: #selector(SurveyQuestionsViewController.yesButtonAction), for: UIControlEvents.touchUpInside)
        cell.noButton.addTarget(self, action: #selector(SurveyQuestionsViewController.noButtonAction), for: UIControlEvents.touchUpInside)
        cell.otherOptionButton.addTarget(self, action: #selector(SurveyQuestionsViewController.otherButtonAction), for: UIControlEvents.touchUpInside)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func yesButtonAction(sender: UIButton){
        
        if self.boolValueForYesButton == false {
           // self.boolValueForYesButton = true
            self.boolValueForNoButton = false
            self.boolValueForOtherButton = false
            var indexPath: NSIndexPath!
            
            if let button = sender as? UIButton {
                if let superview = button.superview {
                    print("superview %@",superview)
                    
                    print("dksfg %@",superview.superview!)
                    if let cell = superview.superview as? QuestionCellType {
                        indexPath = QuestionAndanswerTableView.indexPath(for: cell) as NSIndexPath!
                        print("dfgs",indexPath)
                          let answerData = surveyQuestionArray[indexPath.row]
                        print("adfasfaksfg ",answerData.questionId!)
                        cell.yesButton.setImage(UIImage(named: "radioFilledButton"), for: UIControlState.normal)
                        cell.noButton.setImage(UIImage(named: "radioBlankButton"), for: UIControlState.normal)
                        cell.otherOptionButton.setImage(UIImage(named: "radioBlankButton"), for: UIControlState.normal)
                        let dataSrifgn = "\(answerData.questionId!)" + "-" + "Yes"
                        self.selectedArray.replaceObject(at: indexPath.row, with: dataSrifgn)
                        print("selected Array ",self.selectedArray)
                    }
                }
            }
            
        }else {
            
            var indexPath: NSIndexPath!
            
            if let button = sender as? UIButton {
                if let superview = button.superview {
                    print("superview %@",superview)
                    
                    print("dksfg %@",superview.superview!)
                    if let cell = superview.superview as? QuestionCellType {
                        indexPath = QuestionAndanswerTableView.indexPath(for: cell) as NSIndexPath!
                        print("dfsd %@",indexPath)
                        cell.noButton.setImage(UIImage(named: "radioBlankButton"), for: UIControlState.normal)
                        cell.otherOptionButton.setImage(UIImage(named: "radioBlankButton"), for: UIControlState.normal)
                                            }
                }
            }
        }
    }
    
    func noButtonAction(sender: UIButton){
        
        if self.boolValueForNoButton == false {
           // self.boolValueForNoButton = true
            self.boolValueForYesButton = false
            self.boolValueForOtherButton = false
            var indexPath: NSIndexPath!
            
            if let button = sender as? UIButton {
                if let superview = button.superview {
                    print("superview %@",superview)
                    
                    print("dksfg %@",superview.superview!)
                    if let cell = superview.superview as? QuestionCellType {
                        indexPath = QuestionAndanswerTableView.indexPath(for: cell) as NSIndexPath!
                        print("dfsd %@",indexPath)
                        let answerData = surveyQuestionArray[indexPath.row]
                        cell.yesButton.setImage(UIImage(named: "radioBlankButton"), for: UIControlState.normal)
                        cell.noButton.setImage(UIImage(named: "radioFilledButton"), for: UIControlState.normal)
                        cell.otherOptionButton.setImage(UIImage(named: "radioBlankButton"), for: UIControlState.normal)
                        let dataSrifgn = "\(answerData.questionId!)" + "-" + "No"
                        self.selectedArray.replaceObject(at: indexPath.row, with: dataSrifgn)
                        print("selected Array NO ",self.selectedArray)

                    }
                }
            }
            
        }else {
            
            var indexPath: NSIndexPath!

            if let button = sender as? UIButton {
                if let superview = button.superview {
                    print("superview %@",superview)
                    
                    print("dksfg %@",superview.superview!)
                    if let cell = superview.superview as? QuestionCellType {
                       // let answerData = surveyQuestionArray[indexPath.row]
                        indexPath = QuestionAndanswerTableView.indexPath(for: cell) as NSIndexPath!
                        print("dfsd %@",indexPath)
                        cell.yesButton.setImage(UIImage(named: "radioBlankButton"), for: UIControlState.normal)
                        cell.otherOptionButton.setImage(UIImage(named: "radioBlankButton"), for: UIControlState.normal)
                    }
                }
            }
        }
    }
    
    func otherButtonAction(sender: UIButton){
        
        if self.boolValueForOtherButton == false {
           // self.boolValueForOtherButton = true
            var indexPath: NSIndexPath!

            if let button = sender as? UIButton {
                if let superview = button.superview {
                    print("superview %@",superview)
                    
                    print("dksfg %@",superview.superview!)
                    if let cell = superview.superview as? QuestionCellType {
                        indexPath = QuestionAndanswerTableView.indexPath(for: cell) as NSIndexPath!
                        print("dfsd %@",indexPath)
                        let answerData = surveyQuestionArray[indexPath.row]
                        cell.yesButton.setImage(UIImage(named: "radioBlankButton"), for: UIControlState.normal)
                        cell.noButton.setImage(UIImage(named: "radioBlankButton"), for: UIControlState.normal)
                        cell.otherOptionButton.setImage(UIImage(named: "radioFilledButton"), for: UIControlState.normal)
                        let dataSrifgn = "\(answerData.questionId!)" + "-" + "NA"
                        self.selectedArray.replaceObject(at: indexPath.row, with: dataSrifgn)
                        print("selected Array NA ",self.selectedArray)

                        
                    }
                }
            }
            
        }else {
            
            var indexPath: NSIndexPath!

            if let button = sender as? UIButton {
                if let superview = button.superview {
                    print("superview %@",superview)
                   //  let answerData = surveyQuestionArray[indexPath.row]
                    print("dksfg %@",superview.superview!)
                    if let cell = superview.superview as? QuestionCellType {
                        indexPath = QuestionAndanswerTableView.indexPath(for: cell) as NSIndexPath!
                        print("dfsd %@",indexPath)
                        cell.yesButton.setImage(UIImage(named: "radioBlankButton"), for: UIControlState.normal)
                        cell.noButton.setImage(UIImage(named: "radioBlankButton"), for: UIControlState.normal)

                    }
                }
            }
            
        }
    }
    
    func submitQuestionAndAnswer(){
        
        if currentReachabilityStatus != .notReachable {
            
            hudClass.showInView(view: self.view)
            
            let urlString = "\(baseUrl)saveAnswer"
            print("url string %@",urlString)
            
            let stringArray = self.selectedArray!
            let string =  stringArray.componentsJoined(by: ",")
            print("stringd \(string)")
            
            // First time it contains only zeros value for p_key id
            //            if self.p_key_Array!.contains(0) {
            //                print("kris")
            //              self.p_String = "0"
            //            }else {
            let p_keyssd = self.p_key_Array!
            
            let p_Strings = p_keyssd.componentsJoined(by: ",")
            print("p_s",p_Strings)
            
            
            print("fullArray ",self.p_key_Array!)
            
            for i in 0 ..< self.p_key_Array!.count  {
                
                let item = self.p_key_Array[i] as! String
                
                print("item " , item)
                
                if item ==  "0" {
                    self.p_String = "0"
                }else {
                    self.p_String = p_keyssd.componentsJoined(by: ",")
                    
                }
                
            }

            
            let parameters = [ "cat_id" : "\(self.s_cat_id!)",
                               "s_id" : "\(self.surveyId!)",
                               "user_id": "\(self.userIdString!)",
                                "term_id": self.term_id_string!,
                                "p_key_id":  self.p_String!,
                                "answer": string]
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
                        
                        if responseCode == "Updated Successfully" {
                            hudClass.hide()
                            print("dfgdksjksddskfksk")
                                let HighString = result["risk_h"].int
                                let lowString = result["risk_l"].int
                                let moderateString = result["risk_m"].int
                            
                                let totalQuestionsAnswered  = result["total_q"].int
                                let leftQuestionAnswered  = result["left_q"].int
                                let correctQuestionAnswered = result["correct"].int
                                let incorrectQuestionAnswereds = result["incorrect"].int
                                let catNameString = result["cat_name"].string
                                let emfString = result["EMF"].string
                                let rislLabelString = result["risk_zone"].string
                                let tramId = result["tram_id"].string
                            
                            DispatchQueue.main.async {
                                self.setValues(categoryName: catNameString!, totalQuestions: totalQuestionsAnswered!, leftQuestions: leftQuestionAnswered!, correctQuestions: correctQuestionAnswered!, moderateVlaues: moderateString!, highValues: HighString!, lowValues: lowString!, incorrctQuestions: incorrectQuestionAnswereds!,emfString : emfString!,risk_zone: rislLabelString!,tram_id:tramId!)
                            }
                        
                        }else if responseCode == "Submitted Successfully" {
                            hudClass.hide()
                            print("dfgdksjksddskfksk")
                            let HighString = result["risk_h"].int
                            let lowString = result["risk_l"].int
                            let moderateString = result["risk_m"].int
                            
                            let totalQuestionsAnswered  = result["total_q"].int
                            let leftQuestionAnswered  = result["left_q"].int
                            let correctQuestionAnswered = result["correct"].int
                            let incorrectQuestionAnswereds = result["incorrect"].int
                            let catNameString = result["cat_name"].string
                            let emfString = result["EMF"].string
                            let rislLabelString = result["risk_zone"].string
                            let tramId = result["tram_id"].string
                            
                            DispatchQueue.main.async {
                                self.setValues(categoryName: catNameString!, totalQuestions: totalQuestionsAnswered!, leftQuestions: leftQuestionAnswered!, correctQuestions: correctQuestionAnswered!, moderateVlaues: moderateString!, highValues: HighString!, lowValues: lowString!, incorrctQuestions: incorrectQuestionAnswereds!,emfString : emfString!,risk_zone: rislLabelString!,tram_id:tramId!)
                            }
                            
                        }else if responseCode == "You did not attended any questions"{
                            
                            parentClass.showAlertWithApiMessage(message: "Please give your valuable time for survey")
                            
                        }else if responseCode == "All Questions are compulsory, Please attempt all."{
                         parentClass.showAlertWithApiMessage(message: "All Questions are compulsory, Please attempt all.")
                        }else {
                            hudClass.hide()
                            
                            let alertVC = UIAlertController(title: "Alert", message: "Some thing went wrong ", preferredStyle: .alert)
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    func setValues(categoryName: String,totalQuestions: Int, leftQuestions: Int, correctQuestions: Int, moderateVlaues: Int,highValues: Int,lowValues: Int, incorrctQuestions: Int,emfString: String,risk_zone: String,tram_id: String)
    {
        
        self.HighScoreString = highValues
        self.lowScoreString = lowValues
        self.moderateScoreString = moderateVlaues
        self.totalQuestions = totalQuestions
        self.leftQuestions = leftQuestions
        self.correctQuestion = correctQuestions
        self.incorrectQuestion = incorrctQuestions
        self.catName = categoryName
        self.emfStringa = emfString
        self.riskLabel = risk_zone
        self.tramIdString = tram_id
        print("dfskds ",self.HighScoreString!, self.lowScoreString!,self.moderateScoreString!,self.totalQuestions,self.leftQuestions,self.correctQuestion,self.incorrectQuestion)
        print("vava ",self.catName)
        self.performSegue(withIdentifier: "piView", sender: self)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "piView" {
            let eventDetailView = segue.destination as! ResultViewController
            eventDetailView.surveyIdString = self.surveyId!
            eventDetailView.catName = self.catName!
            eventDetailView.HighScoreString = self.HighScoreString!
           eventDetailView.moderateScoreString = self.moderateScoreString!
        eventDetailView.lowScoreString = self.lowScoreString!
           eventDetailView.totalQuestions = self.totalQuestions!
            eventDetailView.leftQuestions = self.leftQuestions!
            eventDetailView.correctQuestion = self.correctQuestion!
            eventDetailView.incorrectQuestion = self.incorrectQuestion!
            eventDetailView.emfString = self.emfStringa!
            eventDetailView.riskZoneString = self.riskLabel!
            eventDetailView.tramIdString = self.tramIdString!
        }

        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
