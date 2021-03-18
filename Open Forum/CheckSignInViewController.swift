//
//  CheckSignInViewController.swift
//  Open Forum
//
//  Created by Rohit Pratapa Bernard on 15/03/21.
//

import UIKit
import GoogleSignIn

class CheckSignInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (GIDSignIn.sharedInstance()?.currentUser) != nil{
            print("signed in")
            let forum = self.storyboard?.instantiateViewController(withIdentifier: "ForumTableViewController") as! ForumTableViewController
            self.navigationController?.pushViewController(forum, animated: true)
        }
        else{
            print("gotta sign in ")
            let signIn = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
            self.navigationController?.pushViewController(signIn, animated: true)
            //navigationController?.pushViewController(SignInViewController(), animated: false)
            //performSegue(withIdentifier:"SignInViewController", sender:self)
        }

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
