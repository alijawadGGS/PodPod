//
//  NabuPodUserModel.swift
//  Pods
//
//  Created by Ali Jawad on 03/03/2017.
//
//

/*
 private String appId;
 private String token;
 private String userId;
 private String userName;
 private boolean status;
 private long lastLoginTime;
 
 */

import Foundation

public struct NabuPodUserModel
{
    private var appId : String? = ""
    private var token : String? = ""
    private var userId : String? = ""
    private var userName : String? = ""
    private var status : Bool? = true
    private var lastLoginTime : Double? = 0.0
    
    public mutating func setAppId(appId_ : String?)
    {
        appId = appId_
    }
    
    
    
}
