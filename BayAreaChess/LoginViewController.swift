//
//  LoginViewController.swift
//  BayAreaChess
//
//  Created by Carlos Reyes on 4/8/15.
//  Copyright (c) 2015 Carlos Reyes. All rights reserved.
//

import UIKit

let userNameKeyConstant = "carlos"

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if (checkCredentials()) {
//            self.performSegueWithIdentifier(Constants.Segue.Login, sender: self)
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBarHidden = false
    }
    
    @IBAction func login(sender: UIButton) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(Constants.Credentials.Password, forKey: userNameKeyConstant)
        self.performSegueWithIdentifier(Constants.Segue.Login, sender: self)
    }
    
    func checkCredentials() -> Bool {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let name = defaults.stringForKey(userNameKeyConstant) {
            return true
        }
        return false
    }
    
    @IBAction func goBack (sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

