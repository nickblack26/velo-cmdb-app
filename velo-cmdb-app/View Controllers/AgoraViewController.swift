//import Foundation
//import AgoraRtcKit
//
//#if os(iOS)
//class AgoraViewController: UIViewController {
//    
//    var agoraKit: AgoraRtcEngineKit?
//    var agoraDelegate: AgoraRtcEngineDelegate?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        initializeAgoraEngine()
//        joinChannel()
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        leaveChannel()
//        destroyInstance()
//    }
//    
//    func initializeAgoraEngine() {
//        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: "YOUR_APP_ID", delegate: agoraDelegate)
//    }
//    
//    func joinChannel() {
//        agoraKit?.joinChannel(byToken: "007eJxTYAg4XRllvyzy4VTvmdr7ToqsZn/QdPzUN+9rchfCApi3nzqmwJCSkpxkmZRkmWxsam5iamlskZxoZGyQbJZokmJibGJkGsJlmdYQyMjQ1HCCgREKQXx2hpDU4pLMvHQGBgAFeCE6", channelId: "Testing", info: nil, uid: 0, joinSuccess: {(channel, uid, elapsed) in})
//    }
//    
//    func leaveChannel() {
//        agoraKit?.leaveChannel(nil)
//    }
//    
//    func destroyInstance() {
//        AgoraRtcEngineKit.destroy()
//    }
//    
//    func didClickMuteButton(isMuted: Bool) {
//        isMuted ? (agoraKit?.muteLocalAudioStream(true)) : (agoraKit?.muteLocalAudioStream(false))
//    }
//}
//#endif
//
//#if os(macOS)
//class AgoraViewController: NSViewController {
//    
//    var agoraKit: AgoraRtcEngineKit?
//    var agoraDelegate: AgoraRtcEngineDelegate?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        initializeAgoraEngine()
//        joinChannel()
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        leaveChannel()
//        destroyInstance()
//    }
//    
//    func initializeAgoraEngine() {
//        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: "YOUR_APP_ID", delegate: agoraDelegate)
//    }
//    
//    func joinChannel() {
//        agoraKit?.joinChannel(byToken: "007eJxTYAg4XRllvyzy4VTvmdr7ToqsZn/QdPzUN+9rchfCApi3nzqmwJCSkpxkmZRkmWxsam5iamlskZxoZGyQbJZokmJibGJkGsJlmdYQyMjQ1HCCgREKQXx2hpDU4pLMvHQGBgAFeCE6", channelId: "Testing", info: nil, uid: 0, joinSuccess: {(channel, uid, elapsed) in})
//    }
//    
//    func leaveChannel() {
//        agoraKit?.leaveChannel(nil)
//    }
//    
//    func destroyInstance() {
//        AgoraRtcEngineKit.destroy()
//    }
//    
//    func didClickMuteButton(isMuted: Bool) {
//        isMuted ? (agoraKit?.muteLocalAudioStream(true)) : (agoraKit?.muteLocalAudioStream(false))
//    }
//}
//#endif
