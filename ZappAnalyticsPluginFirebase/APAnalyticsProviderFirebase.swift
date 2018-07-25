/*!
 * @type              APAnalyticsProviderFirebase.swift
 * @abstract          Implement Firebase analytics agent
 * @discussion        Because firebase limitation we encode special characters (LEGENT_JSON).
 * @additional tag    Firebase
 * @additional tag    analytics
 */

//  Created by Elad Ben david on 19/01/2017.
//  Copyright © 2017 Applicaster Ltd. All rights reserved.
//

import Firebase
import ZappAnalyticsPluginsSDK

open class APAnalyticsProviderFirebase: ZPAnalyticsProvider {
    
    public let MAX_PARAM_NAME_CHARACTERS_LONG  :Int = 40
    public let MAX_PARAM_VALUE_CHARACTERS_LONG :Int = 100
    public let FIREBASE_PREFIX : String = "Firebase_"
    public let APPLICASTER_PREFIX : String = "applicaster_"
    private var LEGENT : Dictionary<String, String> = [:]
    private var LEGENT_JSON : String = "{\" \":\"__\",\"_\":\"_0\",\"-\":\"_1\",\":\":\"_2\",\"'\":\"_3\",\".\":\"_4\",\",\":\"_5\",\"/\":\"_6\",\"\\\\\":\"_7\",\"(\":\"_8\",\")\":\"_A\",\"?\":\"_B\",\"\\\"\":\"_C\",\"!\":\"_D\",\"@\":\"_E\",\"#\":\"_F\",\"$\":\"_G\",\"%\":\"_H\",\"^\":\"_I\",\"&\":\"_J\",\"*\":\"_K\",\"=\":\"_M\",\"+\":\"_N\",\"~\":\"_L\",\"`\":\"_O\",\"|\":\"_P\",\";\":\"_Q\",\"[\":\"_R\",\"]\":\"_S\",\"}\":\"_T\",\"{\":\"_U\"}"
    
    
    override open func getKey() -> String {
        return "firebase"
    }
    
    override open func configureProvider() -> Bool {
        initLegent()
        if let path = Bundle.main.path(forResource: "GoogleService-Info",
                                       ofType: "plist") {
            if let plistDictionary = NSDictionary(contentsOfFile: path){
                if  plistDictionary.allKeys.count > 0 {
                    if (FirebaseApp.app() == nil) {
                        FirebaseApp.configure()
                    }
                    return true
                }
            }
        }
        return false
    }
    
    override open func trackEvent(_ eventName:String, parameters:[String:NSObject]) {
        super.trackEvent(eventName, parameters: parameters)
        var combinedParameters = ZPAnalyticsProvider.defaultProperties(self.defaultEventProperties, combinedWithEventParams: parameters)

        let eventName = refactorParamName(eventName: eventName)

        if combinedParameters.isEmpty == true {
            //The following line should be replaced with the second one when firebase SDK will be fixed
             NotificationCenter.default.post(name: Notification.Name(rawValue: "kLogFirebaseEvent"), object:["event name" : eventName])
            //FIRAnalytics.logEvent(withName : eventName, parameters: nil)
        }
        else{
            combinedParameters = refactorEventParameters(parameters: combinedParameters)
            
            //The next two lines should be replaced with the third one when firebase SDK will be fixed
            
            combinedParameters["event name"] = eventName as NSObject;
            NotificationCenter.default.post(name: Notification.Name(rawValue: "kLogFirebaseEvent"), object:combinedParameters)
            //FIRAnalytics.logEvent(withName: eventName, parameters:combinedParameters)
        }
    }

    override open func trackEvent(_ eventName:String, message: String, exception:NSException) {
        trackEvent(eventName, parameters: [String : NSObject]())
    }
    
    override open func trackEvent(_ eventName:String, message: String, error: NSError) {
        trackEvent(eventName, parameters: [String : NSObject]())

    }
    
    override open func trackEvent(_ eventName:String, timed:Bool) {
        if timed {
            registerTimedEvent(eventName, parameters: nil)
        } else {
            trackEvent(eventName, parameters: [String : NSObject]())
        }
    }
    
    override open func trackEvent(_ eventName:String, parameters: [String:NSObject], timed:Bool) {
        if timed {
            registerTimedEvent(eventName, parameters: parameters)
        } else {
            trackEvent(eventName, parameters: parameters)
        }
    }
    
    override open func trackEvent(_ eventName:String){
        trackEvent(eventName, parameters: [String : NSObject]())
    }
    
    override open func endTimedEvent(_ eventName: String, parameters: [String : NSObject]) {
        processEndTimedEvent(eventName, parameters: parameters)
    }
    
    /*
     * loading LEGENT Dictionary according LEGENT_JSON
     */
    public func initLegent() {
        LEGENT = convertToDictionary(jsonString: LEGENT_JSON)
    }
    
    /**
     * @param eventValue the text we should encode according param value limitations.
     * @return encoded string base on eventValue
     * @discussion  Firebase param value limitations:
     * @discussion  **********************
     * @discussion  1. Param values can be up to 100 characters long.
     * @discussion  2. The "firebase_" prefix is reserved and should not be used so APPLICASTER_PREFIX will be added.
     */
    public func  refactorParamValue(eventValue:  String) -> String{
        var returnValue:String = eventValue
        
        if (returnValue.hasPrefix(FIREBASE_PREFIX)) {
            returnValue = APPLICASTER_PREFIX + returnValue;
        }
        
        //Param values can be up to 100 characters long.
        if (returnValue.count > MAX_PARAM_VALUE_CHARACTERS_LONG) {
            returnValue = String(returnValue[returnValue.startIndex..<returnValue.index(returnValue.startIndex, offsetBy: MAX_PARAM_VALUE_CHARACTERS_LONG)])
        }
        
        return returnValue;
    }
    
    /*
     * @param eventValue the text we should encode according param name limitations.
     * @return encoded string base on eventName
     * @discussion  Firebase param names limitations:
     * @discussion  **********************
     * @discussion  1. Param names can be up to 40 characters long.
     * @discussion  2. Contain alphanumeric characters and underscores ("_").
     * @discussion  3. must start with an alphabetic character.
     * @discussion  4. The "firebase_" prefix is reserved and should not be used so APPLICASTER_PREFIX will be added.
     */
    public func refactorParamName( eventName: String) -> String {
        var returnValue:String = eventName
        //Contain alphanumeric characters and underscores ("_").
        returnValue = recursiveEncodeAlphanumericCharacters(eventName: returnValue)
        
        if (returnValue.hasPrefix(FIREBASE_PREFIX)) {
            returnValue = APPLICASTER_PREFIX + returnValue
        }
        
        // 3. must start with an alphabetic chaacter.
        switch returnValue[returnValue.startIndex] {
        case "0"..."9" , "a"..."z", "A"..."Z":
            break
        default:
            returnValue = APPLICASTER_PREFIX + returnValue;
            break
        }
        
        //Param names can be up to 40 characters long.
        if (returnValue.count > MAX_PARAM_NAME_CHARACTERS_LONG) {
            returnValue = String(returnValue[returnValue.startIndex..<returnValue.index(returnValue.startIndex, offsetBy: MAX_PARAM_NAME_CHARACTERS_LONG)])
        }
        
        return returnValue;
    }
    
    /*
     * Convert json string to dictionary
     */
    private func convertToDictionary(jsonString: String) -> [String: String] {
        guard let data = jsonString.data(using: String.Encoding.utf8) else {
            return [:]
        }
        
        guard let jsonDictionary = try? JSONSerialization.jsonObject(with: data, options: [] ) as! [String: String] else {
            return [:]
        }
        
        return jsonDictionary
    }
    
    /*
     * This function replace all the forbidden charcters with new one, according the legend dictionary.
    */
    private func recursiveEncodeAlphanumericCharacters( eventName: String ) -> String {
        let name:String = eventName
        if name.count > 0 {
            let send = name.index(name.startIndex, offsetBy: 1)
            let sendvalue = String(name[send..<name.endIndex])
            if let prefix = LEGENT[name.getFirstCharacter! as String] {
                return prefix + recursiveEncodeAlphanumericCharacters( eventName: sendvalue)
            }else{
                return name.getFirstCharacter! + recursiveEncodeAlphanumericCharacters( eventName: sendvalue)
            }
        }
        return ""
    }
    
    
    /*
     * Validate and refactor parameters before sending event
     */
    public func refactorEventParameters(parameters: [String: NSObject]) -> [String: NSObject]{
        var validateParameters = [String: NSObject]()
        for (key, value) in parameters {
            let validateParamName = refactorParamName(eventName:key)
            var validateParamValue = value
            if ((value as? String) != nil){
                validateParamValue = refactorParamValue(eventValue:value as! String) as NSObject
            }
            validateParameters[validateParamName] = validateParamValue
        }
        return validateParameters
    }

}
