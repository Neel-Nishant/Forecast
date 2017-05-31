//
//  ViewController.swift
//  Forecast
//
//  Created by Neel Nishant on 09/01/17.
//  Copyright © 2017 Neel Nishant. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth.FIRAuthErrors
import GoogleSignIn

class ViewController: UIViewController, GIDSignInUIDelegate,GIDSignInDelegate{
    
//    @IBOutlet weak var googleSignInBtn: GIDSignInButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
//        GIDSignIn.sharedInstance().signIn()
//
        // Uncomment to automatically sign in the user.
//        GIDSignIn.sharedInstance().signInSilently()
        
        // TODO(developer) Configure the sign-in button look/feel
        // ...
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserDefaults.standard.value(forKey: KEY_UID) != nil {
            self.performSegue(withIdentifier: SEGUE_LOGGED_IN, sender: nil)
        }

    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        print("here")
//        
//        signIn()
//        print(UserDefaults.standard.value(forKey: KEY_UID))
//        if UserDefaults.standard.value(forKey: KEY_UID) != nil {
//            self.performSegue(withIdentifier: SEGUE_LOGGED_IN, sender: nil)
//        }
//    }
//    func authenticateWithGoogle(_ sender: UIButton!) {
//        
//        
//    }
    @IBAction func GoogleSignInPressed(_ sender: Any) {
        signIn()
    }
//    
    func signIn()
    {
        GIDSignIn.sharedInstance().signIn()
    }
    func signOut() {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
//        let authentication = user.authentication
//        let credential = FIRGoogleAuthProvider.credential(withIDToken: (authentication?.idToken)!, accessToken: (authentication?.accessToken)!)
        guard let authentication = user.authentication else { return }
        let credential = FIRGoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                          accessToken: authentication.accessToken)
        
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            if error != nil {
                print("login failed\(error)")
            }
            else {
                let userData = ["provider": (credential.provider)]
                //let userData = ["provider": credential.provider, "email": (user!.email)!]
               DataService.ds.createFirebaseUser(user!.uid, user: userData)
                UserDefaults.standard.setValue(user!.uid, forKey: KEY_UID)
                self.performSegue(withIdentifier: SEGUE_LOGGED_IN, sender: nil)
                print("here")
                
            }
        }
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: NSError!) {
        print("error:\(error)")
    }
//    func signIn(signIn: GIDSignIn!,
//                presentViewController viewController: UIViewController!) {
//        self.performSegue(withIdentifier: SEGUE_LOGGED_IN, sender: nil)
//    }
    

    


    
    @IBAction func attemptLogin(_ sender: UIButton!)
    {
        
        if let email = emailField.text, email != "", let pwd = passwordField.text, pwd != ""{
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (authData, error) in
                if error != nil{
                    print (error.debugDescription)
                    print ((error as! NSError).code)
                    
                    
                    if  (error as! NSError).code == FIRAuthErrorCode.errorCodeEmailAlreadyInUse.rawValue {
                        self.showErrorAlert("Email already in Use", msg: "Please use a different email address")
                    }
                    else if (error as! NSError).code == FIRAuthErrorCode.errorCodeInvalidEmail.rawValue {
                        self.showErrorAlert("Invalid email", msg: "Please use a valid email address")
                    }
                    else if (error as! NSError).code == FIRAuthErrorCode.errorCodeUserMismatch.rawValue{
                        self.showErrorAlert("Invalid credentials", msg: "Please check your email and password")
                    }
                    else if (error as! NSError).code == FIRAuthErrorCode.errorCodeWrongPassword.rawValue {
                        self.showErrorAlert("Invalid credentials", msg: "Please check your email and password")
                    }
                    else if (error as! NSError).code == FIRAuthErrorCode.errorCodeUserNotFound.rawValue {
                        self.showErrorAlert("User not found", msg: "Please sign up to continue")
                    }
                    else{
                        self.showErrorAlert("Unable to login", msg: "Try again later")
                    }
                   
                }
                if authData?.uid != nil {
                self.performSegue(withIdentifier: SEGUE_LOGGED_IN, sender: nil)
                    UserDefaults.standard.setValue(authData!.uid, forKey: KEY_UID)}
            })
        }
        else{
            showErrorAlert("Email and Password required", msg: "You must enter your email and password to login")
        }
    }
    @IBAction func attemptSignUp(_ sender: UIButton!)
    {
        if let email = emailField.text, email != "", let pwd = passwordField.text, pwd != "" {
            FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (result, error) in
                
                if error != nil{
                    if (error as! NSError).code == FIRAuthErrorCode.errorCodeEmailAlreadyInUse.rawValue {
                        self.showErrorAlert("Email already in Use", msg: "Please use a different email address")
                    }
                }
//                else if (error as! NSError).code == nil {
                else {
                    UserDefaults.standard.setValue(result!.uid, forKey: KEY_UID)
                    FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: nil)
                    let user = ["provider": (result?.providerID)!]
                    //let user = ["provider": (result?.providerID)!, "email": (result?.email)!]
                    DataService.ds.createFirebaseUser((result?.uid)!, user: user)
                    self.performSegue(withIdentifier: SEGUE_LOGGED_IN, sender: nil)
                    
                }
            })
        }
        else{
            showErrorAlert("Email and Password required", msg: "You must enter your email and password to sign up")
        }
            
    }
    func showErrorAlert(_ title: String, msg: String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

}

