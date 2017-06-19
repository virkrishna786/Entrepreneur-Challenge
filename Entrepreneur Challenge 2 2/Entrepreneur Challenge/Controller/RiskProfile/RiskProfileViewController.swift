//
//  RiskProfileViewController.swift
//  Entrepreneur Challenge
//
//  Created by Admin media on 4/20/17.
//  Copyright © 2017 Media Mosaic service private limited. All rights reserved.
//

import UIKit
import PieCharts
import Alamofire
import SwiftyJSON

let highRiskCOlor = UIColor(red: 255.0/255.0, green: 122.0/255.0, blue: 35.0/255.0, alpha: 1)
let lowRiskColor = UIColor(red: 206.0/255.0, green: 253.0/255.0, blue: 209.0/255.0, alpha: 1)
let moderateColor = UIColor(red: 255.0/255.0, green: 251.0/255.0, blue: 68.0/255.0, alpha: 1)

class RiskProfileViewController: UIViewController,PieChartDelegate {
    @IBOutlet weak var chatView: PieChart!

    @IBOutlet weak var threatsLabel: UILabel!
    @IBOutlet weak var strengthLabel: UILabel!
    @IBOutlet weak var emfLabel: UILabel!
    @IBOutlet weak var totalQuestionLabel: UILabel!
    @IBOutlet weak var customView: UIView!
   // @IBOutlet weak var emfLabel: UIView!
    @IBOutlet weak var riskLabel: UILabel!
    var riskZoneString : String?
    var HighScoreString : String?
    var lowScoreString : String?
    var moderateScoreString : String?
    var userIdString: Int?
    var riskArray = [RiskProfileArrayClass]()
    var  staticView = UIView()


    @IBOutlet weak var resultScoredLabel: UILabel!


    @IBAction func consultExpertButtonAction(_ sender: UIButton) {
        let urlString = URL(string: "https://www.innsightconsulting.com/contact/")
        UIApplication.shared.openURL(urlString! as URL)
        
    }
    @IBOutlet weak var cosultExpertButton: UIButton!
    var boolValue = 0
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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addChildViewController(appDelegate.menuTableViewController)
        
        let userId = defaults.value(forKey: "userId") as? Int
        self.userIdString = userId!
        print("user %@" ,userId!)
       self.apiCallForRisk()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.addChildViewController(appDelegate.menuTableViewController)
    }
    
    func gestureFunction(){
        appDelegate.menuTableViewController.hideMenu()
        self.view .addSubview(appDelegate.menuTableViewController.view)
        boolValue = 0
        self.staticView.removeFromSuperview()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(RiskProfileViewController.gestureFunction), name: NSNotification.Name(rawValue: "resetStaticView"), object: nil)
        
        // order is important - models have to be set at the end
    }
    
    // MARK: - PieChartDelegate
    
    func onSelected(slice: PieSlice, selected: Bool) {
        print("Selected: \(selected), slice: \(slice)")
    }
    
    // MARK: - Models
    
    fileprivate func createModels() -> [PieSliceModel] {
        let alpha: CGFloat = 0.5
        print("dsfgsd",alpha)
        
        return [
            //print("high value ")
            PieSliceModel(value: Double(self.moderateScoreString!)!, color: moderateColor),
            PieSliceModel(value: Double(self.lowScoreString!)!, color: lowRiskColor),
            // PieSliceModel(value: 1, color: UIColor.green.withAlphaComponent(alpha)),
            PieSliceModel(value: Double(self.HighScoreString!)!, color: highRiskCOlor),
            // PieSliceModel(value: 2, color: UIColor.red.withAlphaComponent(alpha)),
            // PieSliceModel(value: 1.5, color: UIColor.magenta.withAlphaComponent(alpha)),
            // PieSliceModel(value: 0.5, color: UIColor.orange.withAlphaComponent(alpha))
        ]
    }
    
    // MARK: - Layers
    
    fileprivate func createCustomViewsLayer() -> PieCustomViewsLayer {
        let viewLayer = PieCustomViewsLayer()
        
        let settings = PieCustomViewsLayerSettings()
        settings.viewRadius = 100
        settings.hideOnOverflow = false
        viewLayer.settings = settings
        
        viewLayer.viewGenerator = createViewGenerator()
        
        return viewLayer
    }
    
    fileprivate func createTextLayer() -> PiePlainTextLayer {
        let textLayerSettings = PiePlainTextLayerSettings()
        textLayerSettings.viewRadius = 30
        textLayerSettings.hideOnOverflow = false
        textLayerSettings.label.font = UIFont.systemFont(ofSize: 8)
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        formatter.zeroSymbol = ""
        formatter.numberStyle = .percent
        textLayerSettings.label.textGenerator = {slice in
            return formatter.string(from: slice.data.percentage  as NSNumber).map{"\($0)"} ?? ""
        }
        
        let textLayer = PiePlainTextLayer()
        textLayer.settings = textLayerSettings
        return textLayer
    }
    
    fileprivate func createViewGenerator() -> (PieSlice, CGPoint) -> UIView {
        return {slice, center in
            
            let container = UIView()
            container.frame.size = CGSize(width: 100, height: 40)
            container.center = center
            let view = UIImageView()
            view.frame = CGRect(x: 30, y: 0, width: 40, height: 40)
            container.addSubview(view)
            
            if slice.data.id == 3 || slice.data.id == 0 {
                let specialTextLabel = UILabel()
                specialTextLabel.textAlignment = .center
                if slice.data.id == 0 {
                    // specialTextLabel.text = "views"
                    specialTextLabel.font = UIFont.boldSystemFont(ofSize: 18)
                } else if slice.data.id == 3 {
                    specialTextLabel.textColor = UIColor.blue
                    // specialTextLabel.text = "Custom"
                }
                specialTextLabel.sizeToFit()
                specialTextLabel.frame = CGRect(x: 0, y: 40, width: 100, height: 20)
                container.addSubview(specialTextLabel)
                container.frame.size = CGSize(width: 100, height: 60)
            }
            
            
            // src of images: www.freepik.com, http://www.flaticon.com/authors/madebyoliver
            let imageName: String? = {
                switch slice.data.id {
                case 0: return "fish"
                case 1: return "grapes"
                case 2: return "doughnut"
                case 3: return "water"
                case 4: return "chicken"
                case 5: return "beet"
                case 6: return "cheese"
                default: return nil
                }
            }()
            
            view.image = imageName.flatMap{UIImage(named: $0)}
            
            return container
        }
    }
    
    func apiCallForRisk(){
        
        if currentReachabilityStatus != .notReachable {
            
            hudClass.showInView(view: self.view)
            
            let urlString = "\(baseUrl)riskProfile"
            print("url string %@",urlString)
            
            let parameters = ["user_id" : "\(self.userIdString!)"]
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
                        
                        let responseCode = result["f_emf_status"].string
                      //  let slfgdslf =  result["f_emf_status"].number
                       // let sssfdsgl = result["f_emf_status"].int
                       // print("\(slfgdslf!)")
                       // print("dfsgdsds ",sssfdsgl!)
                        
                        if responseCode == "1" {
                            hudClass.hide()
                                let final_EmfValues = result["final_emf"].string
                                let risk_lows = result["risk_l"].int
                                let risk_highs = result["risk_h"].int
                                let risk_moderates = result["risk_m"].int
                                let risk_zones = result["risk_zone"].string
                                let totalQuestions = result["total_q"].int
                                let  correctAnswers = result["correct"].int
                                let incorrectAnswer = result ["incorrect"].int
                            DispatchQueue.main.async {
                              self.setValues(finalEMF: final_EmfValues!, risk_lows: risk_lows!, risk_highs: risk_highs!, risk_moderate: risk_moderates!, risk_jone: risk_zones!,totalQuestions: totalQuestions!,correctQuestions: correctAnswers!,incorrectAnswers: incorrectAnswer!)
                            }
                            
                        }else {
                            hudClass.hide()
                            self.customView.isHidden = true
                            let alertVC = UIAlertController(title: "Alert", message: "Risk Profile is not Available yet. For Risk Profile please attend all Surveys.", preferredStyle: .alert)
                            alertVC.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction!) in self.myFunc()}))
                            self.present(alertVC, animated: true, completion: nil)
                        }
                        
                    }else {
                        hudClass.hide()
                        self.customView.isHidden = true
                        let alertVC = UIAlertController(title: "Alert", message: "Some thing went wrong", preferredStyle: .alert)
                         alertVC.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction!) in self.myFunc()}))
                        self.present(alertVC, animated: true, completion: nil)
                        parentClass.showAlertWithApiFailure()
                    }
            }
            
        }else {
            hudClass.hide()
            self.customView.isHidden = true
            let alertVC = UIAlertController(title: "Alert", message: "Some thing went wrong", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction!) in self.myFunc()}))
            self.present(alertVC, animated: true, completion: nil)
           // parentClass.showAlert()
        }
    }
    
    func myFunc() {
        
        self.performSegue(withIdentifier: "homeview", sender: self)
       
    }
    
    func setValues(finalEMF: String,risk_lows: Int,risk_highs:Int,risk_moderate: Int,risk_jone: String, totalQuestions:Int, correctQuestions: Int ,incorrectAnswers: Int ){
        self.customView.isHidden = false
        self.HighScoreString = "\(risk_highs)"
        self.lowScoreString = "\(risk_lows)"
        self.moderateScoreString = "\(risk_moderate)"
        self.riskZoneString = risk_jone
        self.emfLabel.text = finalEMF
        self.totalQuestionLabel.text = "Total:" + " " + "\(totalQuestions)"
        self.strengthLabel.text = "Strengths:" + " " + "\(correctQuestions)"
        self.threatsLabel.text = "Threats:" + " " + "\(incorrectAnswers)"
        
        if (self.riskZoneString! == "High"){
            self.riskLabel.backgroundColor = highRiskCOlor
        }else if self.riskZoneString! == "Low"{
            self.riskLabel.backgroundColor = lowRiskColor
        }else if self.riskZoneString! == "Moderate"{
            self.riskLabel.backgroundColor = moderateColor
        }
        self.riskLabel.text = risk_jone
        chatView.layers = [createCustomViewsLayer(), createTextLayer()]
        chatView.delegate = self
        chatView.models = createModels()
        
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
