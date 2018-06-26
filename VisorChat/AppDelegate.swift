//
//  AppDelegate.swift
//  VisorChat
//
//  Created by Marcos Polanco on 6/24/18.
//  Copyright © 2018 Visor Labs. All rights reserved.
//

import UIKit
import Parse
import ParseLiveQuery

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var client: Client?

    
    private func configParse() {
        
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
            let config = NSDictionary(contentsOfFile: path),
            let appId = config["APP_ID"] as? String,
            let serverUrl =  config["SERVER_URL"] as? String,
            let clientKey = config["CLIENT_KEY"] as? String,
            let wssUrl = config["WSS_URL"] as? String else {
                return print("Could not read Parse Configuration")
        }
        
        let parseConfig = ParseClientConfiguration {config in
            config.applicationId = appId
            config.clientKey = clientKey
            config.server = serverUrl
        }
        
        //initialize Parse
        Parse.initialize(with: parseConfig)
        PFUser.enableRevocableSessionInBackground()
        
        //initialize LiveQuery
        self.client = ParseLiveQuery.Client(server: wssUrl)
        
    }
    
    /*  Provide access to the application delegate
     */
    static var shared: AppDelegate? {return UIApplication.shared.delegate as? AppDelegate}
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        self.configParse()
        
        return true
    }
    
}

