//
//  AppDelegate.swift
//  Open Forum
//
//  Created by Rohit Pratapa Bernard on 15/03/21.
//

import UIKit
import GoogleSignIn

//Google auth Client ID
//705295141041-dng53ujebcvmlroqas3pfiv8j2qjbb8j.apps.googleusercontent.com

@main
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    var window: UIWindow?
    let defaults = UserDefaults.standard

    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
      if let error = error {
        if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
          print("The user has not signed in before or they have since signed out.")
            
            
            //let storyboard = UIStoryboard(name: "Main", bundle: nil);
            //let controller = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            //self.window?.rootViewController = controller
        } else {
          print("\(error.localizedDescription)")
        }
        return
      }
      // Perform any operations on signed in user here.
        let userId = user.userID                  // For client-side use only!
        print(userId as Any)
        //let idToken = user.authentication.idToken // Safe to send to the server
        //user.authentication.id
        //print(idToken as Any)
        print("\n\n\n\(user.authentication.clientID)\n\n\n")
        
        print("\n\n\n\(user.authentication.idToken)\n\n\n")
        
        let fullName = user.profile.name
        print(fullName as Any)
        //let givenName = user.profile.givenName
        //print(givenName as Any)
        //let familyName = user.profile.familyName
        //print(familyName as Any)
        let userEmail = user.profile.email
        print(userEmail as Any)
        let thumbnail = user.profile.imageURL(withDimension: 256)
        print(thumbnail)
        
        let currentUser=User(google_id: userId, name: fullName, email: userEmail, tumbnail: thumbnail?.absoluteString)
        guard let uploadData = try? JSONEncoder().encode(currentUser) else {
            return
        }
        
        let url = URL(string: "https://morning-temple-69567.herokuapp.com/auth/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(("Bearer "+user.authentication.idToken), forHTTPHeaderField: "Authorization")
        //print(("Bearer "+user.authentication.idToken))
        //let userResult = try? JSONDecoder().decode(UserResponse.self, from: data)
        //self.defaults.set(userResult.,forKey: "user_id")
        
        //let task = URLSession.shared.uploadTask(with: request, from: uploadData) { data, response, error in
        let task = URLSession.shared.dataTask(with: request) { (data, response, _) in
            if let data = data,
                let dataString = String(data: data, encoding: .utf8) {
                let userResult = try? JSONDecoder().decode(UserResponse.self, from: data)
                self.defaults.set(userResult?.user_id,forKey: "user_id")
                self.defaults.set(user.authentication.idToken,forKey: "token")
                print ("got data: \(dataString) //end of data//")
                print ("raw data: \(data)")
            }
        }
        task.resume()
        
        
        
      // ...
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let sceneDelegate = windowScene.delegate as? SceneDelegate
          else {
            return
          }
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let controller = storyboard.instantiateViewController(withIdentifier: "Navigation")
        sceneDelegate.window?.rootViewController = controller
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
      // Perform any operations when the user disconnects from app here.
        NotificationCenter.default.post(
              name: Notification.Name(rawValue: "ToggleAuthUINotification"),
              object: nil,
              userInfo: ["statusText": "User has disconnected."])
      // ...
    }
    



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        GIDSignIn.sharedInstance().clientID = "705295141041-dng53ujebcvmlroqas3pfiv8j2qjbb8j.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        
        
        return true
    }
    
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

