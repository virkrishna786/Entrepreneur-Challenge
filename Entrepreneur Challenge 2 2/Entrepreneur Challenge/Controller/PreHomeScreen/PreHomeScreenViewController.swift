//
//  PreHomeScreenViewController.swift
//  Entrepreneur Challenge
//
//  Created by Admin media on 4/25/17.
//  Copyright © 2017 Media Mosaic service private limited. All rights reserved.
//

import UIKit

class PreHomeScreenViewController: UIViewController {

    @IBAction func startButtonAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "homeView", sender: self)

    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
