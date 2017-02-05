//
//  ViewController.swift
//  Forecast
//
//  Created by Neel Nishant on 09/01/17.
//  Copyright © 2017 Neel Nishant. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate{
    
    @IBOutlet weak var googleSignInBtn: MaterialButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        // Uncomment to automatically sign in the user.
        GIDSignIn.sharedInstance().signInSilently()
        
        // TODO(developer) Configure the sign-in button look/feel
        // ...

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
            self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
        }
    }
    func authenticateWithGoogle(sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
    }
    func signOut() {
        GIDSignIn.sharedInstance().signOut()
        
    }
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        let authentication = user.authentication
        let credential = FIRGoogleAuthProvider.credentialWithIDToken(authentication.idToken, accessToken: authentication.accessToken)
        
        FIRAuth.auth()!.signInWithCredential(credential) { (user, error) in
            if error != nil {
                print("login failed\(error)")
            }
            else {
                let userData = ["provider": (credential.provider)]
                //let userData = ["provider": credential.provider, "email": (user!.email)!]
               DataService.ds.createFirebaseUser(user!.uid, user: userData)
                NSUserDefaults.standardUserDefaults().setValue(user!.uid, forKey: KEY_UID)
                self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                
            }
        }
    }
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user: GIDGoogleUser!, withError error: NSError!) {
        
    }

    
    @IBAction func googleSignInbtnPressed(sender: AnyObject) {
        
        authenticateWithGoogle(googleSignInBtn)
    }
    
    @IBAction func attemptLogin(sender: UIButton!)
    {
        
        if let email = emailField.text where email != "", let pwd = passwordField.text where pwd != ""{
            FIRAuth.auth()?.signInWithEmail(email, password: pwd, completion: { (authData, error) in
                if error != nil{
                    print (error)
                    print (error!.code)
                    
                    
                    if error?.code == FIRAuthErrorCode.ErrorCodeEmailAlreadyInUse.rawValue {
                        self.showErrorAlert("Email already in Use", msg: "Please use a different email address")
                    }
                    else if error?.code == FIRAuthErrorCode.ErrorCodeInvalidEmail.rawValue {
                        self.showErrorAlert("Invalid email", msg: "Please use a valid email address")
                    }
                    else if error?.code == FIRAuthErrorCode.ErrorCodeUserMismatch.rawValue{
                        self.showErrorAlert("Invalid credentials", msg: "Please check your email and password")
                    }
                    else if error?.code == FIRAuthErrorCode.ErrorCodeWrongPassword.rawValue {
                        self.showErrorAlert("Invalid credentials", msg: "Please check your email and password")
                    }
                    else if error?.code == FIRAuthErrorCode.ErrorCodeUserNotFound.rawValue {
                        self.showErrorAlert("User not found", msg: "Please sign up to continue")
                    }
                   
                }
                self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
            })
        }
        else{
            showErrorAlert("Email and Password required", msg: "You must enter your email and password to login")
        }
    }
    @IBAction func attemptSignUp(sender: UIButton!)
    {
        if let email = emailField.text where email != "", let pwd = passwordField.text where pwd != "" {
            FIRAuth.auth()?.createUserWithEmail(email, password: pwd, completion: { (result, error) in
                
                if error?.code == FIRAuthErrorCode.ErrorCodeEmailAlreadyInUse.rawValue {
                    self.showErrorAlert("Email already in Use", msg: "Please use a different email address")
                }
                else if error == nil {
                    NSUserDefaults.standardUserDefaults().setValue(result!.uid, forKey: KEY_UID)
                    FIRAuth.auth()?.signInWithEmail(email, password: pwd, completion: nil)
                    let user = ["provider": (result?.providerID)!]
                    //let user = ["provider": (result?.providerID)!, "email": (result?.email)!]
                    DataService.ds.createFirebaseUser((result?.uid)!, user: user)
                    self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                    
                }
            })
        }
        else{
            showErrorAlert("Email and Password required", msg: "You must enter your email and password to sign up")
        }
            
    }
    func showErrorAlert(title: String, msg: String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }

}

