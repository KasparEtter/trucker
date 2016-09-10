//
//  LoginViewController.swift
//  
//
//  Created by Nico Hänggi on 10/09/16.
//
//

import UIKit
import SwiftLoader

protocol LoginViewControllerProtocol : NSObjectProtocol {
    func loginSuccessful(user: String) -> Void
}

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    
    // ViewController Delegate
    weak var delegate: LoginViewControllerProtocol?
    
    var truckerAPI = TruckerAPI(baseURL: "https://dry-citadel-48051.herokuapp.com")
    var _token : String?
    var token : String? {
        set{
            _token = newValue
            self.registerUser()
        }
        get {
            return _token
        }
    }
    var buttonClicked = false
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Init SwiftLoader
        var config : SwiftLoader.Config = SwiftLoader.Config()
        config.size = 130
        config.spinnerColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        config.titleTextColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        config.foregroundColor = .blackColor()
        config.backgroundColor = UIColor(red: 28/255, green: 33/255, blue: 40/255, alpha: 1)
        config.foregroundAlpha = 0.5
        SwiftLoader.setConfig(config)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func registerUser() {
        if (self.token != nil && self.buttonClicked != false) {
            print("registering")
            truckerAPI.register("johnny@digitalid.net", token: self.token!) { (res) in
                print(res)
                SwiftLoader.hide()
                self.delegate?.loginSuccessful("johnny@digitalid.net")
            }
        }
        
    }
    
    @IBAction func submitClicked(sender: AnyObject) {
        SwiftLoader.show(title: "Approval Pending...", animated: true)
        self.view.endEditing(true)
        self.buttonClicked = true
        self.registerUser()
    }

}
