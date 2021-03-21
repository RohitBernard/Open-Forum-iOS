//
//  ViewController.swift
//  Open Forum
//
//  Created by Rohit Pratapa Bernard on 15/03/21.
//

import UIKit
import GoogleSignIn

class SignInViewController: UIViewController {

    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        defaults.removeObject(forKey: "token")
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
        
        if (GIDSignIn.sharedInstance()?.currentUser) != nil{
            print("signed in")
            //let forum = self.storyboard?.instantiateViewController(withIdentifier: "ForumTableViewController") as! ForumTableViewController
            //self.navigationController?.pushViewController(forum, animated: true)
        }
        

      // Automatically sign in the user.
        //GIDSignIn.sharedInstance()?.restorePreviousSignIn()
      // ...
        
        
        
    }
    @IBAction func signIn(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
    
        let forum = self.storyboard?.instantiateViewController(withIdentifier: "ForumTableViewController") as! ForumTableViewController
        self.navigationController?.pushViewController(forum, animated: true)
    }
    
    

}

