//import Foundation
//import SwiftUI
//
//#if os(iOS)
//import AgoraRtcKit
//struct AgoraRep: UIViewControllerRepresentable {
//    
//    @Binding var isMuted: Bool
//    
//    func makeUIViewController(context: Context) -> AgoraViewController {
//        let agoraViewController = AgoraViewController()
//        agoraViewController.agoraDelegate = context.coordinator
//        return agoraViewController
//    }
//    
//    func updateUIViewController(_ uiViewController: AgoraViewController, context: Context) {
//        isMuted ? (uiViewController.didClickMuteButton(isMuted: true)) : (uiViewController.didClickMuteButton(isMuted: false))
//    }
//    
//    
//
//    class Coordinator: NSObject, AgoraRtcEngineDelegate {
//        var parent: AgoraRep
//        init(_ agoraRep: AgoraRep) {
//            self.parent = agoraRep
//        }
//    }
//    
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(self)
//    }
//}
//#endif
//
//#if os(macOS)
//struct AgoraRep: NSViewControllerRepresentable {
//    @Binding var isMuted: Bool
//    
//    func makeNSViewController(context: Context) -> AgoraViewController {
//        let agoraViewController = AgoraViewController()
//        agoraViewController.agoraDelegate = context.coordinator
//        return agoraViewController
//    }
//    
//    func updateNSViewController(_ nsViewController: AgoraViewController, context: Context) {
//        isMuted ? (nsViewController.didClickMuteButton(isMuted: true)) : (nsViewController.didClickMuteButton(isMuted: false))
//    }
//
//    class Coordinator: NSObject, AgoraRtcEngineDelegate {
//        var parent: AgoraRep
//        init(_ agoraRep: AgoraRep) {
//            self.parent = agoraRep
//        }
//    }
//    
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(self)
//    }
//}
//#endif
