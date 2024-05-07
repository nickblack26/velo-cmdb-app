////
////  ViewController.swift
////  Twilio Voice Quickstart - Swift
////
////  Copyright © 2016 Twilio, Inc. All rights reserved.
////
//
//import UIKit
//import AVFoundation
//import PushKit
//import CallKit
//import TwilioVoice
//
//let accessToken = ProcessInfo.processInfo.environment["TWILIO_ACCESS_TOKEN"] ?? ""
//let twimlParamTo = "to"
//
//let kRegistrationTTLInDays = 365
//
//let kCachedDeviceToken = "CachedDeviceToken"
//let kCachedBindingDate = "CachedBindingDate"
//
//class TwilioViewController: UIViewController {
//    var incomingPushCompletionCallback: (() -> Void)?
//
//    var callKitCompletionCallback: ((Bool) -> Void)? = nil
//    var audioDevice = DefaultAudioDevice()
//    var activeCallInvites: [String: CallInvite]! = [:]
//    var activeCalls: [String: Call]! = [:]
//    
//    // activeCall represents the last connected call
//    var activeCall: Call? = nil
//
//    var callKitProvider: CXProvider?
//    let callKitCallController = CXCallController()
//    var userInitiatedDisconnect: Bool = false
//    
//    /*
//     Custom ringback will be played when this flag is enabled.
//     When [answerOnBridge](https://www.twilio.com/docs/voice/twiml/dial#answeronbridge) is enabled in
//     the <Dial> TwiML verb, the caller will not hear the ringback while the call is ringing and awaiting
//     to be accepted on the callee's side. Configure this flag based on the TwiML application.
//    */
//    var playCustomRingback = false
//    var ringtonePlayer: AVAudioPlayer? = nil
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        /* Please note that the designated initializer `CXProviderConfiguration(localizedName: String)` has been deprecated on iOS 14. */
//        let configuration = CXProviderConfiguration(localizedName: "Voice Quickstart")
//        configuration.maximumCallGroups = 2
//        configuration.maximumCallsPerCallGroup = 1
//        callKitProvider = CXProvider(configuration: configuration)
//        if let provider = callKitProvider {
//            provider.setDelegate(self, queue: nil)
//        }
//        
//        /*
//         * The important thing to remember when providing a TVOAudioDevice is that the device must be set
//         * before performing any other actions with the SDK (such as connecting a Call, or accepting an incoming Call).
//         * In this case we've already initialized our own `TVODefaultAudioDevice` instance which we will now set.
//         */
//        TwilioVoiceSDK.audioDevice = audioDevice
//        
//        /* Example usage of Default logger to print app logs */
//        let defaultLogger = TwilioVoiceSDK.logger
//        if let params = LogParameters.init(module:TwilioVoiceSDK.LogModule.platform , logLevel: TwilioVoiceSDK.LogLevel.debug, message: "The default logger is used for app logs") {
//            defaultLogger.log(params: params)
//        }
//    }
//
//    func getActiveCall() -> Call? {
//        if let activeCall = activeCall {
//            return activeCall
//        } else if activeCalls.count == 1 {
//            // This is a scenario when the only remaining call is still on hold after the previous call has ended
//            return activeCalls.first?.value
//        } else {
//            return nil
//        }
//    }
//
//    func checkRecordPermission(completion: @escaping (_ permissionGranted: Bool) -> Void) {
//        let permissionStatus = AVAudioApplication.shared.recordPermission
//
//        switch permissionStatus {
//        case .granted:
//            // Record permission already granted.
//            completion(true)
//        case .denied:
//            // Record permission denied.
//            completion(false)
//        case .undetermined:
//            // Requesting record permission.
//            // Optional: pop up app dialog to let the users know if they want to request.
//            AVAudioApplication.requestRecordPermission { granted in completion(granted) }
//        default:
//            completion(false)
//        }
//    }
//    
//    // MARK: AVAudioSession
//    
//    func toggleAudioRoute(toSpeaker: Bool) {
//        // The mode set by the Voice SDK is "VoiceChat" so the default audio route is the built-in receiver. Use port override to switch the route.
//        audioDevice.block = {
//            do {
//                if toSpeaker {
//                    try AVAudioSession.sharedInstance().overrideOutputAudioPort(.speaker)
//                } else {
//                    try AVAudioSession.sharedInstance().overrideOutputAudioPort(.none)
//                }
//            } catch {
//                NSLog(error.localizedDescription)
//            }
//        }
//        
//        audioDevice.block()
//    }
//}
//    
//    
//// MARK: - UITextFieldDelegate
//
//extension TwilioViewController: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
////        outgoingValue.resignFirstResponder()
//        return true
//    }
//}
//    
//    
//// MARK: - PushKitEventDelegate
//
//extension TwilioViewController: PushKitEventDelegate {
//    func credentialsUpdated(credentials: PKPushCredentials) {
//        guard
//            (registrationRequired() || UserDefaults.standard.data(forKey: kCachedDeviceToken) != credentials.token)
//        else {
//            return
//        }
//
//        let cachedDeviceToken = credentials.token
//        /*
//         * Perform registration if a new device token is detected.
//         */
//        TwilioVoiceSDK.register(accessToken: accessToken, deviceToken: cachedDeviceToken) { error in
//            if let error = error {
//                NSLog("An error occurred while registering: \(error.localizedDescription)")
//            } else {
//                NSLog("Successfully registered for VoIP push notifications.")
//                
//                // Save the device token after successfully registered.
//                UserDefaults.standard.set(cachedDeviceToken, forKey: kCachedDeviceToken)
//                
//                /**
//                 * The TTL of a registration is 1 year. The TTL for registration for this device/identity
//                 * pair is reset to 1 year whenever a new registration occurs or a push notification is
//                 * sent to this device/identity pair.
//                 */
//                UserDefaults.standard.set(Date(), forKey: kCachedBindingDate)
//            }
//        }
//    }
//    
//    /**
//     * The TTL of a registration is 1 year. The TTL for registration for this device/identity pair is reset to
//     * 1 year whenever a new registration occurs or a push notification is sent to this device/identity pair.
//     * This method checks if binding exists in UserDefaults, and if half of TTL has been passed then the method
//     * will return true, else false.
//     */
//    func registrationRequired() -> Bool {
//        guard
//            let lastBindingCreated = UserDefaults.standard.object(forKey: kCachedBindingDate)
//        else { return true }
//        
//        let date = Date()
//        var components = DateComponents()
//        components.setValue(kRegistrationTTLInDays/2, for: .day)
//        let expirationDate = Calendar.current.date(byAdding: components, to: lastBindingCreated as! Date)!
//
//        if expirationDate.compare(date) == ComparisonResult.orderedDescending {
//            return false
//        }
//        return true;
//    }
//    
//    func credentialsInvalidated() {
//        guard let deviceToken = UserDefaults.standard.data(forKey: kCachedDeviceToken) else { return }
//        
//        TwilioVoiceSDK.unregister(accessToken: accessToken, deviceToken: deviceToken) { error in
//            if let error = error {
//                NSLog("An error occurred while unregistering: \(error.localizedDescription)")
//            } else {
//                NSLog("Successfully unregistered from VoIP push notifications.")
//            }
//        }
//        
//        UserDefaults.standard.removeObject(forKey: kCachedDeviceToken)
//        
//        // Remove the cached binding as credentials are invalidated
//        UserDefaults.standard.removeObject(forKey: kCachedBindingDate)
//    }
//    
//    func incomingPushReceived(payload: PKPushPayload) {
//        // The Voice SDK will use main queue to invoke `cancelledCallInviteReceived:error:` when delegate queue is not passed
//        TwilioVoiceSDK.handleNotification(payload.dictionaryPayload, delegate: self, delegateQueue: nil)
//    }
//    
//    func incomingPushReceived(payload: PKPushPayload, completion: @escaping () -> Void) {
//        // The Voice SDK will use main queue to invoke `cancelledCallInviteReceived:error:` when delegate queue is not passed
//        TwilioVoiceSDK.handleNotification(payload.dictionaryPayload, delegate: self, delegateQueue: nil)
//        
//        if let version = Float(UIDevice.current.systemVersion), version < 13.0 {
//            // Save for later when the notification is properly handled.
//            incomingPushCompletionCallback = completion
//        }
//    }
//
//    func incomingPushHandled() {
//        guard let completion = incomingPushCompletionCallback else { return }
//        
//        incomingPushCompletionCallback = nil
//        completion()
//    }
//}
//
//
//// MARK: - TVONotificaitonDelegate
//
//extension TwilioViewController: NotificationDelegate {
//    func callInviteReceived(callInvite: CallInvite) {
//        NSLog("callInviteReceived:")
//        
//        /**
//         * The TTL of a registration is 1 year. The TTL for registration for this device/identity
//         * pair is reset to 1 year whenever a new registration occurs or a push notification is
//         * sent to this device/identity pair.
//         */
//        UserDefaults.standard.set(Date(), forKey: kCachedBindingDate)
//        
//        let callerInfo: TVOCallerInfo = callInvite.callerInfo
//        if let verified: NSNumber = callerInfo.verified {
//            if verified.boolValue {
//                NSLog("Call invite received from verified caller number!")
//            }
//        }
//        
//        let from = (callInvite.from ?? "Voice Bot").replacingOccurrences(of: "client:", with: "")
//
//        // Always report to CallKit
//        reportIncomingCall(from: from, uuid: callInvite.uuid)
//        activeCallInvites[callInvite.uuid.uuidString] = callInvite
//    }
//    
//    func cancelledCallInviteReceived(cancelledCallInvite: CancelledCallInvite, error: Error) {
//        NSLog("cancelledCallInviteCanceled:error:, error: \(error.localizedDescription)")
//
//        guard let activeCallInvites = activeCallInvites, !activeCallInvites.isEmpty else {
//            NSLog("No pending call invite")
//            return
//        }
//        
//        let callInvite = activeCallInvites.values.first { invite in invite.callSid == cancelledCallInvite.callSid }
//        
//        if let callInvite = callInvite {
//            performEndCallAction(uuid: callInvite.uuid)
//            self.activeCallInvites.removeValue(forKey: callInvite.uuid.uuidString)
//        }
//    }
//}
//
//
//// MARK: - TVOCallDelegate
//
//extension TwilioViewController: CallDelegate {
//    func callDidStartRinging(call: Call) {
//        NSLog("callDidStartRinging:")
//                
//        /*
//         When [answerOnBridge](https://www.twilio.com/docs/voice/twiml/dial#answeronbridge) is enabled in the
//         <Dial> TwiML verb, the caller will not hear the ringback while the call is ringing and awaiting to be
//         accepted on the callee's side. The application can use the `AVAudioPlayer` to play custom audio files
//         between the `[TVOCallDelegate callDidStartRinging:]` and the `[TVOCallDelegate callDidConnect:]` callbacks.
//        */
//        if playCustomRingback {
//            playRingback()
//        }
//    }
//    
//    func callDidConnect(call: Call) {
//        NSLog("callDidConnect:")
//        
//        if playCustomRingback {
//            stopRingback()
//        }
//        
//        if let callKitCompletionCallback = callKitCompletionCallback {
//            callKitCompletionCallback(true)
//        }
//        
//
//        toggleAudioRoute(toSpeaker: true)
//
//    }
//
//    func callIsReconnecting(call: Call, error: Error) {
//        NSLog("call:isReconnectingWithError:")
//        
//    }
//    
//    func callDidReconnect(call: Call) {
//        NSLog("callDidReconnect:")
//        
//    }
//    
//    func callDidFailToConnect(call: Call, error: Error) {
//        NSLog("Call failed to connect: \(error.localizedDescription)")
//        
//        if let completion = callKitCompletionCallback {
//            completion(false)
//        }
//        
//        if let provider = callKitProvider {
//            provider.reportCall(with: call.uuid!, endedAt: Date(), reason: CXCallEndedReason.failed)
//        }
//
//        callDisconnected(call: call)
//    }
//    
//    func callDidDisconnect(call: Call, error: Error?) {
//        if let error = error {
//            NSLog("Call failed: \(error.localizedDescription)")
//        } else {
//            NSLog("Call disconnected")
//        }
//        
//        if !userInitiatedDisconnect {
//            var reason = CXCallEndedReason.remoteEnded
//            
//            if error != nil {
//                reason = .failed
//            }
//            
//            if let provider = callKitProvider {
//                provider.reportCall(with: call.uuid!, endedAt: Date(), reason: reason)
//            }
//        }
//
//        callDisconnected(call: call)
//    }
//    
//    func callDisconnected(call: Call) {
//        if call == activeCall {
//            activeCall = nil
//        }
//        
//        activeCalls.removeValue(forKey: call.uuid!.uuidString)
//        
//        userInitiatedDisconnect = false
//        
//        if playCustomRingback {
//            stopRingback()
//        }
//        
//        guard let activeCall = getActiveCall() else { return }
//    }
//    
//    func callDidReceiveQualityWarnings(call: Call, currentWarnings: Set<NSNumber>, previousWarnings: Set<NSNumber>) {
//        /**
//        * currentWarnings: existing quality warnings that have not been cleared yet
//        * previousWarnings: last set of warnings prior to receiving this callback
//        *
//        * Example:
//        *   - currentWarnings: { A, B }
//        *   - previousWarnings: { B, C }
//        *   - intersection: { B }
//        *
//        * Newly raised warnings = currentWarnings - intersection = { A }
//        * Newly cleared warnings = previousWarnings - intersection = { C }
//        */
//        var warningsIntersection: Set<NSNumber> = currentWarnings
//        warningsIntersection = warningsIntersection.intersection(previousWarnings)
//        
//        var newWarnings: Set<NSNumber> = currentWarnings
//        newWarnings.subtract(warningsIntersection)
//        if newWarnings.count > 0 {
//            qualityWarningsUpdatePopup(newWarnings, isCleared: false)
//        }
//        
//        var clearedWarnings: Set<NSNumber> = previousWarnings
//        clearedWarnings.subtract(warningsIntersection)
//        if clearedWarnings.count > 0 {
//            qualityWarningsUpdatePopup(clearedWarnings, isCleared: true)
//        }
//    }
//    
//    func qualityWarningsUpdatePopup(_ warnings: Set<NSNumber>, isCleared: Bool) {
//        var popupMessage: String = "Warnings detected: "
//        if isCleared {
//            popupMessage = "Warnings cleared: "
//        }
//        
//        let mappedWarnings: [String] = warnings.map { number in warningString(Call.QualityWarning(rawValue: number.uintValue)!)}
//        popupMessage += mappedWarnings.joined(separator: ", ")
//    }
//    
//    func warningString(_ warning: Call.QualityWarning) -> String {
//        switch warning {
//        case .highRtt: return "high-rtt"
//        case .highJitter: return "high-jitter"
//        case .highPacketsLostFraction: return "high-packets-lost-fraction"
//        case .lowMos: return "low-mos"
//        case .constantAudioInputLevel: return "constant-audio-input-level"
//        default: return "Unknown warning"
//        }
//    }
//    
//    
//    // MARK: Ringtone
//    
//    func playRingback() {
//        let ringtonePath = URL(fileURLWithPath: Bundle.main.path(forResource: "ringtone", ofType: "wav")!)
//        
//        do {
//            ringtonePlayer = try AVAudioPlayer(contentsOf: ringtonePath)
//            ringtonePlayer?.delegate = self
//            ringtonePlayer?.numberOfLoops = -1
//            
//            ringtonePlayer?.volume = 1.0
//            ringtonePlayer?.play()
//        } catch {
//            NSLog("Failed to initialize audio player")
//        }
//    }
//    
//    func stopRingback() {
//        guard let ringtonePlayer = ringtonePlayer, ringtonePlayer.isPlaying else { return }
//        
//        ringtonePlayer.stop()
//    }
//}
//
// 
//// MARK: - CXProviderDelegate
//
//extension TwilioViewController: CXProviderDelegate {
//    func providerDidReset(_ provider: CXProvider) {
//        NSLog("providerDidReset:")
//        audioDevice.isEnabled = false
//    }
//
//    func providerDidBegin(_ provider: CXProvider) {
//        NSLog("providerDidBegin")
//    }
//
//    func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
//        NSLog("provider:didActivateAudioSession:")
//        audioDevice.isEnabled = true
//    }
//
//    func provider(_ provider: CXProvider, didDeactivate audioSession: AVAudioSession) {
//        NSLog("provider:didDeactivateAudioSession:")
//        audioDevice.isEnabled = false
//    }
//
//    func provider(_ provider: CXProvider, timedOutPerforming action: CXAction) {
//        NSLog("provider:timedOutPerformingAction:")
//    }
//
//    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
//        NSLog("provider:performStartCallAction:")
//        provider.reportOutgoingCall(with: action.callUUID, startedConnectingAt: Date())
//        
//        performVoiceCall(uuid: action.callUUID, client: "") { success in
//            if success {
//                NSLog("performVoiceCall() successful")
//                provider.reportOutgoingCall(with: action.callUUID, connectedAt: Date())
//            } else {
//                NSLog("performVoiceCall() failed")
//            }
//        }
//        
//        action.fulfill()
//    }
//
//    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
//        NSLog("provider:performAnswerCallAction:")
//        
//        performAnswerVoiceCall(uuid: action.callUUID) { success in
//            if success {
//                NSLog("performAnswerVoiceCall() successful")
//            } else {
//                NSLog("performAnswerVoiceCall() failed")
//            }
//        }
//        
//        action.fulfill()
//    }
//
//    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
//        NSLog("provider:performEndCallAction:")
//        
//        if let invite = activeCallInvites[action.callUUID.uuidString] {
//            invite.reject()
//            activeCallInvites.removeValue(forKey: action.callUUID.uuidString)
//        } else if let call = activeCalls[action.callUUID.uuidString] {
//            call.disconnect()
//        } else {
//            NSLog("Unknown UUID to perform end-call action with")
//        }
//
//        action.fulfill()
//    }
//    
//    func provider(_ provider: CXProvider, perform action: CXSetHeldCallAction) {
//        NSLog("provider:performSetHeldAction:")
//        
//        if let call = activeCalls[action.callUUID.uuidString] {
//            call.isOnHold = action.isOnHold
//
//            /** Explicitly enable the TVOAudioDevice.
//            * This is workaround for an iOS issue where the `provider(_:didActivate:)` method is not called
//            * when un-holding a VoIP call after an ended PSTN call.
//            */ https://developer.apple.com/forums/thread/694836
//            if !call.isOnHold {
//                audioDevice.isEnabled = true
//                activeCall = call
//            }
//
//
//            action.fulfill()
//        } else {
//            action.fail()
//        }
//    }
//    
//    func provider(_ provider: CXProvider, perform action: CXSetMutedCallAction) {
//        NSLog("provider:performSetMutedAction:")
//
//        if let call = activeCalls[action.callUUID.uuidString] {
//            call.isMuted = action.isMuted
//            action.fulfill()
//        } else {
//            action.fail()
//        }
//    }
//
//    
//    // MARK: Call Kit Actions
//    func performStartCallAction(uuid: UUID, handle: String) {
//        guard let provider = callKitProvider else {
//            NSLog("CallKit provider not available")
//            return
//        }
//        
//        let callHandle = CXHandle(type: .generic, value: handle)
//        let startCallAction = CXStartCallAction(call: uuid, handle: callHandle)
//        let transaction = CXTransaction(action: startCallAction)
//
//        callKitCallController.request(transaction) { error in
//            if let error = error {
//                NSLog("StartCallAction transaction request failed: \(error.localizedDescription)")
//                return
//            }
//
//            NSLog("StartCallAction transaction request successful")
//
//            let callUpdate = CXCallUpdate()
//            
//            callUpdate.remoteHandle = callHandle
//            callUpdate.supportsDTMF = true
//            callUpdate.supportsHolding = true
//            callUpdate.supportsGrouping = false
//            callUpdate.supportsUngrouping = false
//            callUpdate.hasVideo = false
//
//            provider.reportCall(with: uuid, updated: callUpdate)
//        }
//    }
//
//    func reportIncomingCall(from: String, uuid: UUID) {
//        guard let provider = callKitProvider else {
//            NSLog("CallKit provider not available")
//            return
//        }
//
//        let callHandle = CXHandle(type: .generic, value: from)
//        let callUpdate = CXCallUpdate()
//        
//        callUpdate.remoteHandle = callHandle
//        callUpdate.supportsDTMF = true
//        callUpdate.supportsHolding = true
//        callUpdate.supportsGrouping = false
//        callUpdate.supportsUngrouping = false
//        callUpdate.hasVideo = false
//
//        provider.reportNewIncomingCall(with: uuid, update: callUpdate) { error in
//            if let error = error {
//                NSLog("Failed to report incoming call successfully: \(error.localizedDescription).")
//            } else {
//                NSLog("Incoming call successfully reported.")
//            }
//        }
//    }
//
//    func performEndCallAction(uuid: UUID) {
//
//        let endCallAction = CXEndCallAction(call: uuid)
//        let transaction = CXTransaction(action: endCallAction)
//
//        callKitCallController.request(transaction) { error in
//            if let error = error {
//                NSLog("EndCallAction transaction request failed: \(error.localizedDescription).")
//            } else {
//                NSLog("EndCallAction transaction request successful")
//            }
//        }
//    }
//    
//    func performVoiceCall(uuid: UUID, client: String?, completionHandler: @escaping (Bool) -> Void) {
//        let connectOptions = ConnectOptions(accessToken: accessToken) { builder in
////            builder.params = [twimlParamTo: self.outgoingValue.text ?? ""]
//            builder.uuid = uuid
//        }
//        
//        let call = TwilioVoiceSDK.connect(options: connectOptions, delegate: self)
//        activeCall = call
//        activeCalls[call.uuid!.uuidString] = call
//        callKitCompletionCallback = completionHandler
//    }
//    
//    func performAnswerVoiceCall(uuid: UUID, completionHandler: @escaping (Bool) -> Void) {
//        guard let callInvite = activeCallInvites[uuid.uuidString] else {
//            NSLog("No CallInvite matches the UUID")
//            return
//        }
//        
//        let acceptOptions = AcceptOptions(callInvite: callInvite) { builder in
//            builder.uuid = callInvite.uuid
//        }
//        
//        let call = callInvite.accept(options: acceptOptions, delegate: self)
//        activeCall = call
//        activeCalls[call.uuid!.uuidString] = call
//        callKitCompletionCallback = completionHandler
//        
//        activeCallInvites.removeValue(forKey: uuid.uuidString)
//        
//        guard #available(iOS 13, *) else {
//            incomingPushHandled()
//            return
//        }
//    }
//}
//
//
//// MARK: - AVAudioPlayerDelegate
//
//extension TwilioViewController: AVAudioPlayerDelegate {
//    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
//        if flag {
//            NSLog("Audio player finished playing successfully");
//        } else {
//            NSLog("Audio player finished playing with some error");
//        }
//    }
//    
//    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
//        if let error = error {
//            NSLog("Decode error occurred: \(error.localizedDescription)")
//        }
//    }
//}
