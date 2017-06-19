//
//  ResultViewController.swift
//  Entrepreneur Challenge
//
//  Created by Admin media on 3/30/17.
//  Copyright © 2017 Media Mosaic service private limited. All rights reserved.
//

import UIKit
import PieCharts

class ResultViewController: UIViewController , PieChartDelegate ,ratingViewControllerDelegate {

    @IBOutlet weak var mainCategoryLabel: UILabel!
    @IBAction func nextsurveyButtonAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "nextSurvey", sender: self)
    }
    @IBAction func homeButtonAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "homeView", sender: self)
    }
    @IBOutlet weak var riskTextLabel: UILabel!
    @IBAction func consequenceButtonAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "consequence", sender: self)
    }
    @IBOutlet weak var consequenceButton: UIButton!{
        didSet{
            self.consequenceButton.layer.cornerRadius = 0
        }
    }
    @IBOutlet weak var riskLabel: UILabel!
    @IBOutlet weak var emfLabel: UILabel!
    @IBAction func backButtonAction(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var correctQuestionLabel: UILabel!
    @IBOutlet weak var inCorrectLabel: UILabel!
    @IBOutlet weak var totalQuestionLabel: UILabel!
    @IBOutlet weak var chatView: PieChart!
    @IBOutlet weak var categoryLabel: UILabel!
//    @IBOutlet weak var postReviewButton: UIButton!{
//        didSet{
//            self.postReviewButton.layer.cornerRadius = 20
//        }
//    }
    @IBOutlet weak var consultExpertButton: UIButton!{
        didSet{
            self.consultExpertButton.layer.cornerRadius = 20
        }
    }
    @IBAction func consultButtonAction(_ sender: UIButton) {
        let urlString = URL(string: "https://www.innsightconsulting.com/contact/")
        UIApplication.shared.openURL(urlString! as URL)
    }
    
    var surveyIdString: Int!
    
    var HighScoreString : Int?
    var lowScoreString : Int?
    var moderateScoreString : Int?
    
    var totalQuestions: Int?
    var leftQuestions : Int?
    var correctQuestion : Int?
    var incorrectQuestion : Int?
    var catName : String?
    var emfString: String?
    var riskZoneString : String?
    var tramIdString : String?
    let highRiskCOlor = UIColor(red: 255.0/255.0, green: 122.0/255.0, blue: 35.0/255.0, alpha: 1)
    let  lowRiskColor = UIColor(red: 206.0/255.0, green: 253.0/255.0, blue: 209.0/255.0, alpha: 1)
    let  moderateColor = UIColor(red: 255.0/255.0, green: 251.0/255.0, blue: 68.0/255.0, alpha: 1)
    
    @IBAction func postReviewButtonAction(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ratingView") as! RatingAndReviewController
        vc.delegate = self
        vc.view.backgroundColor = color_app_backgroundView_trasnparent
        vc.eventIDString = self.surveyIdString!
        print("ekdsfs \(vc.eventIDString)")
        vc.modalPresentationStyle = UIModalPresentationStyle.custom
        present(vc, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // print("hjgjkg ",self.catName!)
        
        self.totalQuestionLabel.text = "Total:" + " " + "\(self.totalQuestions!)"
        self.correctQuestionLabel.text = "Strengths:" + " " + "\(self.correctQuestion!)"
        self.inCorrectLabel.text = "Threats:" + " " + "\(self.incorrectQuestion!)"
        self.categoryLabel.text = self.catName!
        self.mainCategoryLabel.text = self.catName! + " " +  "Profile"
        self.emfLabel.text = self.emfString!
        
        if (self.riskZoneString! == "High"){
            self.riskTextLabel.backgroundColor = highRiskCOlor
        }else if self.riskZoneString! == "Low"{
            self.riskTextLabel.backgroundColor = lowRiskColor
        }else if self.riskZoneString! == "Moderate"{
            self.riskTextLabel.backgroundColor = moderateColor
        }
        self.riskTextLabel.text = "\(self.riskZoneString!)"
        self.riskTextLabel.sizeToFit()
        // For making pie chart like tube
        
//        chatView.models = [
//            PieSliceModel(value: 2.1, color: UIColor.yellow),
//            PieSliceModel(value: 3, color: UIColor.blue),
//            PieSliceModel(value: 1, color: UIColor.green)
//        ]

        // Do any additional setup after loading the view.
    }
    
    func backFromRatingController(info: Bool) {
        
        print("krish")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        chatView.layers = [createCustomViewsLayer(), createTextLayer()]
        chatView.delegate = self
        chatView.models = createModels() // order is important - models have to be set at the end
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
            PieSliceModel(value: Double(self.moderateScoreString!), color: self.moderateColor),
            PieSliceModel(value: Double(self.lowScoreString!), color: self.lowRiskColor),
            // PieSliceModel(value: 1, color: UIColor.green.withAlphaComponent(alpha)),
            PieSliceModel(value: Double(self.HighScoreString!), color: self.highRiskCOlor),
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "consequence" {
            let eventDetailView = segue.destination as! ConsequencesViewController
            eventDetailView.tramIdString = self.tramIdString!
        }

        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
