//
//  NabuPodDataManager.swift
//  Pods
//
//  Created by Ali Jawad on 02/03/2017.
//
//

import Foundation
import UICKeyChainStore
public class NabuPodDataManager
{
    
    static let keyChainService = "NabuCircleService"
    static let keyChainKey = "NabuCircleService"

    //MARK: Exposed Methods
    
    
    public class func getPreferredUser(appId : String) -> NabuPodUserModel?
    {
        // if found no user record against appId; check in other app
        // if found single user record against appId; return the record
        // if found multiple users against appId, return most recent record
        
        let appSpecificUsers = getAllUsersInApp(appId: appId)
        
        
        
        
        if appSpecificUsers.count == 0
        {
            // search for user in other app
            
            let otherAppUsers = getAllUsersExceptApp(appId: appId)
            
            if otherAppUsers.count == 0
            { // no user found in other app as well
                return nil
            }
            else if otherAppUsers.count == 1
            {
                return otherAppUsers[0]
            }
            else
            { // more than 1 users found in other app
                
                
                let sortedAppSpecificUsers =  otherAppUsers.sorted {
                    item1, item2 in
                    let date1 = item1.getLastLoginTime() ?? NSDate()
                    let date2 = item2.getLastLoginTime() ?? NSDate()
                    return date1.compare(date2 as Date) == ComparisonResult.orderedDescending
                }
                
                return sortedAppSpecificUsers[0]

            }
            
                }
        else if appSpecificUsers.count == 1
        {
            return appSpecificUsers[0]
        }
        else
        {
            // return most recent user
            
           let sortedAppSpecificUsers =  appSpecificUsers.sorted {
                item1, item2 in
                let date1 = item1.getLastLoginTime() ?? NSDate()
                let date2 = item2.getLastLoginTime() ?? NSDate()
                return date1.compare(date2 as Date) == ComparisonResult.orderedDescending
            }
            
            
            return sortedAppSpecificUsers[0]
            
        
        }
    
    }
    
    
    public class func getToken(userId : String) -> String?
    {
        let allRecordsAgainstUser = getAllRecordsAgainstUser(userId: userId)
        
        if allRecordsAgainstUser.count == 0
        {
            return nil
        }
        else if allRecordsAgainstUser.count == 1
        {
            return allRecordsAgainstUser[0].getToken()
        }
        else
        {
            let sortedAllRecordsAgainstUser =  allRecordsAgainstUser.sorted {
                item1, item2 in
                let date1 = item1.getLastLoginTime() ?? NSDate()
                let date2 = item2.getLastLoginTime() ?? NSDate()
                return date1.compare(date2 as Date) == ComparisonResult.orderedDescending
            }
            
            return sortedAllRecordsAgainstUser[0].getToken()
        }
        
        
    }
    
    
    public class func addOrUpdateUser(userInfo : NabuPodUserModel?)
    {
        if let unrUserInfo = userInfo
        {
            // check if user already exists in given app
            
            if let userExists = getUserInApp(userId: unrUserInfo.getUserId() ?? "", appId: unrUserInfo.getAppId() ?? "")
            {
                    updateUser(userId: unrUserInfo.getUserId() ?? "", appId: unrUserInfo.getAppId() ?? "", userInfo: userExists)
            }
            else
            {
                addUser(userInfo: unrUserInfo)
            }
        }
        else
        {
            print("Developer Error: User given to add or update was nil")
        }
    }
    
    
    public class func removeUser(userId : String, appId : String)
    {
    
        
            if let data = UICKeyChainStore.data(forKey: keyChainKey, service: keyChainService)
            {
                let userInfoArray = NSKeyedUnarchiver.unarchiveObject(with: data) as? NSArray as! NSMutableArray?
                
                if userInfoArray != nil
                {
                    
                    if userInfoArray!.count > 0
                    {
                        
                        
                        for index in stride(from: userInfoArray!.count - 1, to: -1, by: -1) {
                            //print(index)
                            
                            
                            if index < userInfoArray!.count
                            {
                                let dictionary = userInfoArray![index] as! Dictionary<String, Any?>
                                
                                let userInfoStruct = NabuPodUserModel.init(propertyListRepresentation: dictionary)
                                
                                if userInfoStruct?.getUserId() == userId && userInfoStruct?.getAppId() == appId
                                {
                                    
                                    let newDiction = userInfoStruct?.propertyListRepresentation()
                                    
                                    if newDiction != nil
                                    {
                                        
                                        userInfoArray?.remove(newDiction!)
                                    }
                                    
                                }
                            }
                            
                            
                        }
                        
                        
                        saveUserInfoArray(array: userInfoArray!)
                    
                    }
                    
                    
                }
                
                
                
            }
            
            
    }
    
    
    //MARK: Internal Methods
    
    class func addUser(userInfo : NabuPodUserModel)
    {
        
        
        if let array = getUserInfoArray()
        {
            let mutableArray = NSMutableArray(array: array)
            mutableArray.add(userInfo.propertyListRepresentation())
            saveUserInfoArray(array: mutableArray)
            
        }
        else
        {
        
            let array : NSArray = [userInfo.propertyListRepresentation()]
            
            saveUserInfoArray(array: array)

        }
        

    }
    
    
    class func updateUser(userId : String, appId : String, userInfo : NabuPodUserModel)
    {
        if let data = UICKeyChainStore.data(forKey: keyChainKey, service: keyChainService)
        {
            var userInfoArray = NSKeyedUnarchiver.unarchiveObject(with: data) as? NSArray as! NSMutableArray?
            
            if userInfoArray != nil
            {
                for index in 0...userInfoArray!.count - 1  {
                    
                    let dictionary = userInfoArray![index] as! Dictionary<String, Any?>
                    
                   var userInfoStruct = NabuPodUserModel.init(propertyListRepresentation: dictionary)
                    
                    if userInfoStruct?.getUserId() == userId && userInfoStruct?.getAppId() == appId
                    {
                        userInfoStruct?.setLastLoginTime(lastLoginTime_: userInfo.getLastLoginTime())
                        userInfoStruct?.setToken(token_: userInfo.getToken())
                        userInfoStruct?.setStatus(status_: userInfo.getStatus())
                        userInfoStruct?.setUserName(userName_: userInfo.getUserName())
                        
                        let newDiction = userInfoStruct?.propertyListRepresentation()
                        
                        if newDiction != nil
                        {
                            userInfoArray?.replaceObject(at: index, with: newDiction!)

                        }
                        
                        
                    }
                    
                }
                
                
                saveUserInfoArray(array: userInfoArray!)
            }
            
           
            
        }
    }
    
    
     class func getUserInApp(userId : String, appId : String) -> NabuPodUserModel?
    {
        if let userInfoArray = getUserInfoArray()
        {
           // var filteredArray = userInfoArray.filtered(using: NSPredicate(format: "(userId == %@) AND (appId == %@)", userId, appId))
            
            var filteredArray = userInfoArray.filter{
                if $0["userId"] as? String == userId && $0["appId"] as? String == appId
                {
                    return true
                }
                return false

            }

            
            print("Numnber of users in app \(filteredArray.count)")
            if filteredArray.count > 0
            {
                
                
                return NabuPodUserModel.init(propertyListRepresentation: filteredArray[0] as? Dictionary<String, Any?>)
            
            }
            
        }
        
             return nil
    }
    
    
    class func getAllUsersExceptApp(appId : String) ->[NabuPodUserModel]
    { // returns all users in app other than appId
    
        var arrToReturn = [NabuPodUserModel]()
        
        if let userInfoArray = getUserInfoArray()
        {
           // let filteredArray = userInfoArray.filtered(using: NSPredicate(format: "appId != %@", appId))
            
            let filteredArray = userInfoArray.filter{
                if $0["appId"] as? String == appId
                {
                    return true
                }
            return false
            }
            
            for object in filteredArray
            {
                arrToReturn.append(NabuPodUserModel.init(propertyListRepresentation: object as! Dictionary<String, Any?>)!)

            }
            
//            for(_, object) in filteredArray.enumerated()
//            {
//                arrToReturn.append(NabuPodUserModel.init(propertyListRepresentation: object as! Dictionary<String, Any?>)!)
//            }
            
            
        }
        
        return arrToReturn
    }
    
    class func getAllUsersInApp(appId : String) -> [NabuPodUserModel]
    {
    
        var arrToReturn = [NabuPodUserModel]()

        if let userInfoArray = getUserInfoArray()
        {
           // let filteredArray = userInfoArray.filtered(using: NSPredicate(format: "appId == %@", appId))
            let filteredArray = userInfoArray.filter{
                if $0["appId"] as? String == appId
                {
                    return true
                }
                return false

            }
            
            for object in filteredArray
            {
                arrToReturn.append(NabuPodUserModel.init(propertyListRepresentation: object as? Dictionary<String, Any?>)!)
            }
            
            
//            for(_, object) in filteredArray.enumerated()
//            {
//                arrToReturn.append(NabuPodUserModel.init(propertyListRepresentation: object as? Dictionary<String, Any?>)!)
//            }
            
            
        }
        
        return arrToReturn
    }
    
    
    class func getAllRecordsAgainstUser(userId : String) -> [NabuPodUserModel]
    {        var arrToReturn = [NabuPodUserModel]()
        
        if let userInfoArray = getUserInfoArray()
        {
            
            
            let filteredArray = userInfoArray.filter
            {
                if $0["userId"] as? String == userId
                {
                    return true
                }
                
                return false

            }
            
            
            //(NSPredicate(format: "userId == %@", userId))
            
            
            
            for object in filteredArray
            {
                arrToReturn.append(NabuPodUserModel.init(propertyListRepresentation: object as? Dictionary<String, Any?>)!)
            }
            
//            for(_, object) in filteredArray.enumerated()
//            {
//                arrToReturn.append(NabuPodUserModel.init(propertyListRepresentation: object as? Dictionary<String, Any?>)!)
//            }
            
            
        }
        
        return arrToReturn

    
    }
    
    
    class func getUserInfoArray() -> [[String : Any]]?
    {
        if let data = UICKeyChainStore.data(forKey: keyChainKey, service: keyChainService)
        {
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? [[String : Any]]

        }
    
        return nil
    }
    
    
    class func saveUserInfoArray(array : NSArray)
    {
        let archivedUserData = NSKeyedArchiver.archivedData(withRootObject: array)

        UICKeyChainStore.setData(archivedUserData, forKey: keyChainKey, service: keyChainService)
    }
    
    
   
}
