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
    private var lastLoginTime : NSDate? = NSDate()
    
    
    public init() {
    }
    
    public init(data: Dictionary<String, Any?>?)
    {
        if let userData = data
        {
            self.appId = userData["appId"]! as! String?
//            self.token = userData.object(forKey: "token") as? String
//            self.userId = userData.object(forKey: "userId") as? String
//            self.userName = userData.object(forKey: "userName") as? String
//            self.status = userData.object(forKey: "status") as? Bool
//            self.lastLoginTime = userData.object(forKey: "lastLoginTime") as? NSDate
        }
    }
    
    
    //MARK: Setters
    
    mutating func setAppId(appId_ : String?)
    {
        appId = appId_
    }
    
    mutating func setToken(token_ : String?)
    {
        token = token_
    }
    
    mutating func setUserId(userId_ : String?)
    {
        userId = userId_
    }
    
    mutating func setUserName(userName_ : String?)
    {
        userName = userName_
    }
    
    mutating func setStatus(status_ : Bool?)
    {
        status = status_
    }
    
    mutating func setLastLoginTime(lastLoginTime_ : NSDate?)
    {
        lastLoginTime = lastLoginTime_
    }
    
    
    //MARK: Getters
    
    public func getAppId() -> String?
    {
        return appId
    }
    
    public func getToken() -> String?
    {
        return token
    }
    
    public func getUserId() -> String?
    {
        return userId
    }

    public func getUserName() -> String?
    {
        return userName
    }

    public func getStatus() -> Bool?
    {
        return status
    }

    public func getLastLoginTime() -> NSDate?
    {
        return lastLoginTime
    }


}

extension NabuPodUserModel : PropertyListReadable
{
    
    func propertyListRepresentation() -> Dictionary<String, Any?> {
        
        var representation = [String : Any?]()
        if let appId = self.getAppId()  {
            representation["appId"] = appId as Any?
        }
        if let token = self.getToken(){
            representation["token"] = token as Any?
        }
        if let userId = self.getUserId(){
            representation["userId"] = userId as Any?
        }
        if let userName = self.getUserName(){
            representation["userName"] = userName as Any?
        }
        if let status = self.getStatus(){
            representation["status"] = status as Any?
        }
        if let lastLoginTime = self.getLastLoginTime(){
            representation["lastLoginTime"] = lastLoginTime as Any?
        }

        
        return representation as Dictionary<String, Any?>
    }
    

    public init?(propertyListRepresentation:Dictionary<String, Any?>?) {
        
        guard let values = propertyListRepresentation
            else {return nil}
        self =  NabuPodUserModel(data: values)
    }
}

