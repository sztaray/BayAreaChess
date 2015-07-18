//
//  SignUpViewController.swift
//  BayAreaChess
//
//  Created by Carlos Reyes on 4/16/15.
//  Copyright (c) 2015 Carlos Reyes. All rights reserved.
//

import UIKit

class SignUpViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBarHidden = false
    }
    
    @IBAction func goBack(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
