//
//  MenuTVC.swift
//  MyRentApp
//
//  Created by Saurabh  on 7/6/15.
//  Copyright (c) 2015 Dogma Systems. All rights reserved.
//

import UIKit
import  Alamofire
import  SwiftyJSON
import Kingfisher
let mySpecialNotificationKey = "com.andrewcbancroft.specialNotificationKey"


class MenuTVC: UITableViewController {
 
    let LeftMenuWidth = 120.0
    var headerView:UIView?
    var  imageIcon=UIImageView()
    var SA_Choice = ["Home","Profile","Risk Profile and EMF","Rate App","Change Password","Logout","","",""]
    var SA_Icons = ["home","profile","riskProfile","rateImage","changePassword","logout","","",""]
   var  nameLabel=UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view .backgroundColor=UIColor.black.withAlphaComponent(0.8)
        tableView.dataSource = self
        tableView.delegate = self
        //MenuTVC .frame.size.height=800
        tableView.isScrollEnabled=true
        headerView=UIView()
        setTableviewHeader()
        setSideMenuOutSide()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
        NotificationCenter.default.addObserver(self, selector: #selector(MenuTVC.actOnSpecialNotification), name: NSNotification.Name(rawValue: mySpecialNotificationKey), object: nil)

    }
    
    func actOnSpecialNotification() {
        let value: String = defaults.value(forKey: "user_name") as! String
        self.nameLabel.text = value
        
    
    }
    
    
    func setSideMenuOutSide() {
        
        let customView = UIView()
        customView.frame = CGRect(x:200, y: self.tableView.frame.origin.y-20, width: self.view.frame.size.width, height: self.tableView.frame.size.height)
        customView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        self.view.addSubview(customView)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        DispatchQueue.main.async(){
            //code
            self.tableView.reloadData()
        }
    }
    
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(true)
//        tableView.reloadData()
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setTableviewHeader(){
        //let headerView=UIView()
        headerView!.frame=CGRect(x: 0, y: 0, width: 100, height: 80)//CGRect(0, 0, 220, 200)
        
        
        imageIcon.frame=CGRect(x: 30, y: 5, width: 80, height: 80)//CGRect(53,9,150,145)
        imageIcon.layer.borderWidth = 1
        imageIcon.layer.masksToBounds = false
        imageIcon.layer.borderColor = UIColor.white.cgColor
        imageIcon.layer.cornerRadius = imageIcon.frame.height/2
        imageIcon.clipsToBounds = true

        
        let imageString = defaults.value(forKey: "profile_image") as? String
        print("imageString : \(imageString)")
        
        if imageString == nil {
            self.imageIcon.image = UIImage(named: "aboutUs")
        }else {
            self.downloadImage(string: imageString!)
        }
        imageIcon.contentMode = .scaleAspectFit
       
        nameLabel.frame=CGRect(x: 15, y: 25 , width:150, height:30)//CGRectMake(60,150, 85, 30)
        let username = defaults.value(forKey:"user_name") as? String
        print("userNamde : \(username)")
        nameLabel.text = username!
        nameLabel.textColor = UIColor.white
        nameLabel.textAlignment = NSTextAlignment.left
        headerView!.backgroundColor=UIColor(red: 32/255, green: 28/255, blue: 81/255, alpha: 1.0)
        
        let emailLabel = UILabel()
        emailLabel.frame = CGRect(x: 15, y: 50, width: 180, height: 30)
        let email =  defaults.value(forKey: "user_email") as? String
        emailLabel.text = email!
        emailLabel.textColor = UIColor(red: 169/255, green: 230/255, blue: 254.0/255, alpha: 1.0)
        emailLabel.textAlignment = NSTextAlignment.left
        emailLabel.font = emailLabel.font.withSize(12)
        emailLabel.lineBreakMode = .byTruncatingTail
        headerView?.addSubview(emailLabel)
        
      //headerView!.addSubview(imageIcon)
        headerView?.addSubview(nameLabel)
        headerView!.clipsToBounds=true
        self.tableView.tableHeaderView=headerView
        
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("asjkhask \(SA_Choice.count)")
        return SA_Choice.count

    }
    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete method implementation.
//        // Return the number of rows in the section.
//        
//        print("hjgjhg \(SA_Choice.count)")
//        return SA_Choice.count
//    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("sadjksdshsd")

        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier")!
        print("sadjkhsd")
        // Configure the cell...
        tableView.separatorStyle=UITableViewCellSeparatorStyle.singleLine
        cell.backgroundColor=UIColor.white
        cell.textLabel?.textColor=UIColor.darkGray
        cell.textLabel?.font=UIFont (name: "Helvetica Neue", size: 12)
        cell.textLabel!.text=SA_Choice[indexPath.row]
        
       // tableView.frame.size = tableView.contentSize
        //icons
        cell.imageView?.image=UIImage(named:(SA_Icons[indexPath.row] as String))
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("dkdakshgasjkga")
        
        if (indexPath.row == 0) {
            hideMenu()
           let firstView:HomeViewController
            = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "homeView") as! HomeViewController
            //            let firstView:HomeViewController = HomeViewController(nibName:"HomeViewController",bundle:Bundle.main)
            var fcheck=Bool()
            fcheck=false
            let viewArray=self.navigationController?.viewControllers as NSArray!
            if((viewArray) != nil){
                if !((viewArray?.lastObject! as! UIViewController) .isKind(of: HomeViewController.self)){
                    
                    for views in self.navigationController?.viewControllers as NSArray!
                    {
                        if((views as! UIViewController) .isKind(of: HomeViewController.self))
                        {
                            fcheck=true
                            _ = navigationController?.popToViewController(views as! UIViewController, animated: false)
                           
                        }
                    }
                    if(fcheck==false){
                        
                        self.navigationController?.pushViewController(firstView, animated: true)
                    }
                }
                else{
                    
                    //reset button
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetMenuButton"), object: nil)
                     NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetStaticView"), object: nil)
                }
            }
            else{
                
                appDelegate.navigationController?.pushViewController(firstView, animated: true)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetMenuButton"), object: nil)
            }
        }else if (indexPath.row == 1) {
            
            hideMenu()
            let firstView:EditProfileViewController
                = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "editProfile") as! EditProfileViewController
            //            let firstView:HomeViewController = HomeViewController(nibName:"HomeViewController",bundle:Bundle.main)
            var fcheck=Bool()
            fcheck=false
            let viewArray=self.navigationController?.viewControllers as NSArray!
            if((viewArray) != nil){
                if !((viewArray?.lastObject! as! UIViewController) .isKind(of: EditProfileViewController.self)){
                    
                    for views in self.navigationController?.viewControllers as NSArray!
                    {
                        if((views as! UIViewController) .isKind(of: EditProfileViewController.self))
                        {
                            fcheck=true
                            _ = navigationController?.popToViewController(views as! UIViewController, animated: false)
                        }
                    }
                    if(fcheck==false){
                        
                        self.navigationController?.pushViewController(firstView, animated: true)
                    }
                }
                else{
                    
                    //reset button
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetMenuButton"), object: nil)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetStaticView"), object: nil)

                }
            }
            
        }else if (indexPath.row == 3) {
            hideMenu()
           // let appid = Bundle.main.bundleIdentifier
          //  print("apapd ",appid!)
             let urlString = URL(string: "itms-apps://itunes.apple.com/app/id951334398")
            UIApplication.shared.openURL(urlString!)
//            let firstView:MessageListViewControlelr = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "messageList") as! MessageListViewControlelr
//            var fcheck=Bool()
//            fcheck=false
//            let viewArray=self.navigationController?.viewControllers as NSArray!
//            if((viewArray) != nil){
//                if !((viewArray?.lastObject! as! UIViewController) .isKind(of: MessageListViewControlelr.self)){
//                    
//                    for views in self.navigationController?.viewControllers as NSArray!
//                    {
//                        if((views as! UIViewController) .isKind(of: MessageListViewControlelr.self))
//                        {
//                            fcheck=true
//                            _ = navigationController?.popToViewController(views as! UIViewController, animated: false)
//                            
//                        }
//                    }
//                    if(fcheck==false){
//                        
//                        self.navigationController?.pushViewController(firstView, animated: true)
//                    }
//                }
//                else{
//                    
//                    //reset button
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetMenuButton"), object: nil)
//                }
//            }
//            else{
//                
//                //reset button
//                appDelegate.navigationController?.pushViewController(firstView, animated: true)
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetMenuButton"), object: nil)
//            }
            
            
        }else if (indexPath.row == 20){
            
            hideMenu()
            let firstView:NotificationViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "notificationViewController") as! NotificationViewController
            var fcheck=Bool()
            fcheck=false
            let viewArray=self.navigationController?.viewControllers as NSArray!
            if((viewArray) != nil){
                if !((viewArray?.lastObject! as! UIViewController) .isKind(of: NotificationViewController.self)){
                    
                    for views in self.navigationController?.viewControllers as NSArray!
                    {
                        if((views as! UIViewController) .isKind(of: NotificationViewController.self))
                        {
                            fcheck=true
                            _ = navigationController?.popToViewController(views as! UIViewController, animated: false)
                            
                        }
                    }
                    if(fcheck==false){
                        
                        self.navigationController?.pushViewController(firstView, animated: true)
                    }
                }
                else{
                    //reset button
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetMenuButton"), object: nil)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetStaticView"), object: nil)

                }
            }
            else{
                //reset button
                appDelegate.navigationController?.pushViewController(firstView, animated: true)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetMenuButton"), object: nil)
            }
            
        }else if indexPath.row == 2 {
            
            hideMenu()
            let firstView:RiskProfileViewController
                = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "riskProfileViewController") as! RiskProfileViewController
            //            let firstView:HomeViewController = HomeViewController(nibName:"HomeViewController",bundle:Bundle.main)
            var fcheck=Bool()
            fcheck=false
            let viewArray=self.navigationController?.viewControllers as NSArray!
            if((viewArray) != nil){
                if !((viewArray?.lastObject! as! UIViewController) .isKind(of: RiskProfileViewController.self)){
                    
                    for views in self.navigationController?.viewControllers as NSArray!
                    {
                        if((views as! UIViewController) .isKind(of: RiskProfileViewController.self))
                        {
                            fcheck=true
                            _ = navigationController?.popToViewController(views as! UIViewController, animated: false)
                            
                        }
                    }
                    if(fcheck==false){
                        self.navigationController?.pushViewController(firstView, animated: true)
                    }
                }
                else{
                    
                    //reset button
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetMenuButton"), object: nil)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetStaticView"), object: nil)

                }
            }else{
                appDelegate.navigationController?.pushViewController(firstView, animated: true)
               // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetMenuButton"), object: nil)
            }
            
        }else if indexPath.row == 4 {
            
            hideMenu()
            let firstView:ChangePasswordViewController
                = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "changePassword") as! ChangePasswordViewController
            //            let firstView:HomeViewController = HomeViewController(nibName:"HomeViewController",bundle:Bundle.main)
            var fcheck=Bool()
            fcheck=false
            let viewArray=self.navigationController?.viewControllers as NSArray!
            if((viewArray) != nil){
                if !((viewArray?.lastObject! as! UIViewController) .isKind(of: ChangePasswordViewController.self)){
                    
                    for views in self.navigationController?.viewControllers as NSArray!
                    {
                        if((views as! UIViewController) .isKind(of: ChangePasswordViewController.self))
                        {
                            fcheck=true
                            _ = navigationController?.popToViewController(views as! UIViewController, animated: false)
                            
                        }
                    }
                    if(fcheck==false){
                        
                        self.navigationController?.pushViewController(firstView, animated: true)
                    }
                }
                else{
                    
                    //reset button
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetMenuButton"), object: nil)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetStaticView"), object: nil)

                }
            }
            else{
                
                //reset button
                appDelegate.navigationController?.pushViewController(firstView, animated: true)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetMenuButton"), object: nil)
            }
            
        }else if (indexPath.row == 5) {
            hideMenu()
            let firstView:ViewController
                = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "first") as! ViewController
           // self.navigationController?.pushViewController(firstView, animated: true)

            var fcheck=Bool()
            fcheck=false
            let viewArray=self.navigationController?.viewControllers as NSArray!
            if((viewArray) != nil){
                if !((viewArray?.lastObject! as! UIViewController) .isKind(of: ViewController.self)){
                    
                    for views in self.navigationController?.viewControllers as NSArray!
                    {
                        if((views as! UIViewController) .isKind(of: ViewController.self))
                        {
                            fcheck=true
                            _ = navigationController?.popToViewController(views as! UIViewController, animated: false)
                            
                        }
                    }
                    if(fcheck==false){
                        
                        self.navigationController?.pushViewController(firstView, animated: true)
                    }
                }
                else{
                    
                    //reset button
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetMenuButton"), object: nil)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetStaticView"), object: nil)

                }
            }
            else{
                
                //reset button
                appDelegate.navigationController?.pushViewController(firstView, animated: true)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetMenuButton"), object: nil)
            }
            parentClass.logout()
        }
    }
    
    // Override to support rearranging the table view.

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    
    // MARK: Custom Method
    func showMenu(){
        self.view.isHidden=false
        self.view.frame=CGRect(x:0.0,y:60,width:0.0,height:self.view.frame.height)
        //self.view.backgroundColor=UIColor.blackColor()
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame=CGRect(x:0.0,y:60,width:200.0,height:self.view.frame.size.height)
        })
    }
    func hideMenu(){
        let initialFrame=CGRect(x:-200.0,y:self.view.frame.origin.y,width:200,height:self.view.frame.size.height)
        UIView.animate(withDuration: 0.3, animations:{
            self.view.frame=initialFrame
        })
    }
    
    
    func downloadImage(string: String) {
        let uRL = URL(string: "\(string)")
        self.imageIcon.kf.setImage(with: uRL , placeholder: UIImage(named: "aboutUs"))
    }
    

}
