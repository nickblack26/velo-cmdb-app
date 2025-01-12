//
//  AgoraCanvasView.swift
//  Docs-Examples
//
//  Created by Max Cobb on 22/03/2023.
//

import SwiftUI
import AgoraRtcKit

/// AgoraRtcVideoCanvas must have the `ObservableObject` protocol applied,
/// so it can be a `@StateObject` for ``AgoraVideoCanvasView``.
extension AgoraRtcVideoCanvas: ObservableObject {}

/// This protocol lets ``AgoraVideoCanvasView`` fetch the information it needs,
/// while avoiding a strong dependency on ``AgoraManager``.
public protocol CanvasViewHelper: AnyObject {
    /// Instance of the Agora RTC Engine
    var agoraEngine: AgoraRtcEngineKit { get }
    /// Id of the local user in the channel.
    var localUserId: UInt { get }
}

// Add the `CanvasViewHelper` protocol to AgoraManager.
extension AgoraManager: CanvasViewHelper {}

#if os(macOS)
typealias UIViewRepresentable = NSViewRepresentable
typealias UIView = NSView
#endif

/// AgoraVideoCanvasView is a UIViewRepresentable struct that provides a view
/// for displaying remote or local video in an Agora RTC session.
///
/// Use AgoraVideoCanvasView to create a view that displays the video stream from a remote user
/// or the local user's camera in an Agora RTC session.
/// You can specify the render mode, crop area, and setup mode for the view.
public struct AgoraVideoCanvasView: UIViewRepresentable {
    /// The `AgoraRtcVideoCanvas` object that represents the video canvas for the view.
    @StateObject var canvas = AgoraRtcVideoCanvas()

    /// Reference to a protocol ``CanvasViewHelper`` that helps with fetching the engine instance,
    /// as well as the local user's ID. ``AgoraManager`` conforms to this protocol.
    public weak var manager: CanvasViewHelper?

    // MARK: - Canvas Source ID

    /// 🔤 Video canvas' identifier. Indicating what the source of the render should be.
    public internal(set) var canvasId: CanvasIdType

    /// 🆔 An enum representing different types of canvas IDs, indicating whether it represents
    /// a user ID or a media source.
    public enum CanvasIdType: Hashable {
        /// 🆔 Represents a user ID for the video stream. You'll use this for joining most channels.
        case userId(UInt)
        /// 🆔 Represents a user ID with an `AgoraRtcConnection` for the video stream.
        /// Used when you've joined a channel with `joinChannelEx`.
        case userIdEx(UInt, AgoraRtcConnection)
        /// 🆔 Represents a media source with an `AgoraVideoSourceType` and an optional media player ID.
        case mediaSource(AgoraVideoSourceType, mediaPlayerId: Int32?)
    }

    /// 🔤 Internal method to set the user ID or media source for the `AgoraRtcVideoCanvas`.
    ///
    /// - Parameters:
    ///   - canvasIdType: The `CanvasIdType` indicating whether it represents a user ID or a media source.
    ///   - agoraEngine: The `AgoraRtcEngineKit` instance to perform the setup.
    func setUserId(to canvasId: CanvasIdType, agoraEngine: AgoraRtcEngineKit) {
        switch canvasId {
        case .userId(let userId):
            canvas.uid = userId
            if userId == manager?.localUserId {
                self.setupLocalVideo(agoraEngine: agoraEngine)
            } else {
                agoraEngine.setupRemoteVideo(canvas)
            }
        case .userIdEx(let userId, let connection):
            canvas.uid = userId
            agoraEngine.setupRemoteVideoEx(canvas, connection: connection)
        case .mediaSource(let sourceType, let playerId):
            canvas.sourceType = sourceType
            if let playerId { canvas.mediaPlayerId = playerId }
            agoraEngine.setupLocalVideo(canvas)
        }
    }

    func setupLocalVideo(agoraEngine: AgoraRtcEngineKit) {
        agoraEngine.startPreview()
        agoraEngine.setupLocalVideo(canvas)
    }

    // MARK: - Canvas Properties

    /// Properties struct to encapsulate all possible canvas properties
    public struct CanvasProperties {
        /// 🎨 The render mode for the video stream, which determines how the video is scaled and displayed.
        public var renderMode: AgoraVideoRenderMode
        /// 🖼️ The portion of the video stream to display, specified as a CGRect with values between 0 and 1.
        public var cropArea: CGRect
        /// 🔧 The mode for setting up the video view, which determines whether to replace or merge with existing views.
        public var setupMode: AgoraVideoViewSetupMode
        /// 🪞 A property that represents the mirror mode for the video stream.
        /// The mirror mode determines how the video is mirrored when displayed.
        public var mirrorMode: AgoraVideoMirrorMode
        /// 🫥 A property that determines whether the alpha mask is enabled for the video stream.
        /// When `true`, the alpha mask is enabled, allowing transparency to be displayed in the video stream.
        /// When `false`, the alpha mask is disabled, and the video stream is opaque.
        public var enableAlphaMask: Bool

        /// Initializes a `CanvasProperties` instance with the specified values.
        ///
        /// - Parameters:
        ///   - renderMode: 🎨 The render mode for the video stream, which determines how the video is
        ///                 scaled and displayed.
        ///   - cropArea: 🖼️ The portion of the video stream to display, specified as a CGRect with values
        ///               between 0 and 1.
        ///   - setupMode: 🔧 The mode for setting up the video view, which determines whether to replace
        ///                 or merge with existing views.
        ///   - mirrorMode: 🪞 A property that represents the mirror mode for the video stream.
        ///   - enableAlphaMask: 🫥 Enables or disables the alpha mask for the video stream.
        public init(renderMode: AgoraVideoRenderMode = .hidden,
                    cropArea: CGRect = .zero,
                    setupMode: AgoraVideoViewSetupMode = .replace,
                    mirrorMode: AgoraVideoMirrorMode = .disabled,
                    enableAlphaMask: Bool = false) {
            self.renderMode = renderMode
            self.cropArea = cropArea
            self.setupMode = setupMode
            self.mirrorMode = mirrorMode
            self.enableAlphaMask = enableAlphaMask
        }
    }

    /// 🔤 The canvas properties struct to encapsulate all possible canvas properties.
    private var canvasProperties: CanvasProperties
    /// 🎨 The render mode for the video stream, which determines how the video is scaled and displayed.
    public var renderMode: AgoraVideoRenderMode {
        get { canvasProperties.renderMode } set { canvasProperties.renderMode = newValue }
    }
    /// 🖼️ The portion of the video stream to display, specified as a CGRect with values between 0 and 1.
    public var cropArea: CGRect {
        get { canvasProperties.cropArea } set { canvasProperties.cropArea = newValue }
    }
    /// 🔧 The mode for setting up the video view, which determines whether to replace or merge with existing views.
    public var setupMode: AgoraVideoViewSetupMode {
        get { canvasProperties.setupMode } set { canvasProperties.setupMode = newValue }
    }
    /// 🫥 A property that determines whether the alpha mask is enabled for the video stream.
    /// When `true`, the alpha mask is enabled, allowing transparency to be displayed in the video stream.
    /// When `false`, the alpha mask is disabled, and the video stream is opaque.
    public var enableAlphaMask: Bool {
        get { canvasProperties.enableAlphaMask } set { canvasProperties.enableAlphaMask = newValue }
    }
    /// 🪞 A property that represents the mirror mode for the video stream.
    /// The mirror mode determines how the video is mirrored when displayed.
    public var mirrorMode: AgoraVideoMirrorMode {
        get { canvasProperties.mirrorMode } set { canvasProperties.mirrorMode = newValue }
    }

    // MARK: - Initialisers

    /// Create a new AgoraRtcVideoCanvas for displaying a remote or local video stream in a SwiftUI view.
    ///
    /// - Parameters:
    ///    - manager: An instance of an object that conforms to ``CanvasViewHelper``.
    ///    - uid: The user ID for the video stream.
    ///    - renderMode: The render mode for the video stream, which determines how the video is scaled and displayed.
    ///    - cropArea: The portion of the video stream to display, specified as a CGRect with values between 0 and 1.
    ///    - setupMode: The mode for setting up the video view, which determines whether to replace
    ///                 or merge with existing views.
    ///
    /// - Returns: An AgoraVideoCanvasView instance, which can be added to a SwiftUI view hierarchy.
    ///
    /// Prefer to use ``init(manager:canvasId:canvasProps:)``
    public init(
        manager: CanvasViewHelper, uid: UInt,
        renderMode: AgoraVideoRenderMode = .hidden,
        cropArea: CGRect = .zero,
        setupMode: AgoraVideoViewSetupMode = .replace
    ) {
        self.init(
            manager: manager, canvasId: .userId(uid),
            canvasProps: CanvasProperties(renderMode: renderMode, cropArea: cropArea, setupMode: setupMode)
        )
    }

    /// Initializes an `AgoraVideoCanvasView` for displaying a remote or local video stream in a SwiftUI view.
    ///
    /// - Parameters:
    ///   - manager: An instance of an object that conforms to `CanvasViewHelper`.
    ///   - canvasId: The canvas ID type indicating whether it represents a user ID or a media source.
    ///   - canvasProps: An optional struct of canvas properties.
    public init(
        manager: CanvasViewHelper,
        canvasId: CanvasIdType,
        canvasProps: CanvasProperties = CanvasProperties()
    ) {
        self.manager = manager
        self.canvasId = canvasId
        self.canvasProperties = canvasProps
    }

    private func createCanvasView() -> UIView {
        // Create and return the remote video view
        let canvasView = UIView()
        canvas.view = canvasView
        canvas.renderMode = canvasProperties.renderMode
        canvas.cropArea = canvasProperties.cropArea
        canvas.setupMode = canvasProperties.setupMode
        canvas.mirrorMode = canvasProperties.mirrorMode
        canvas.enableAlphaMask = canvasProperties.enableAlphaMask
        canvasView.isHidden = false
        if let manager {
            self.setUserId(to: self.canvasId, agoraEngine: manager.agoraEngine)
        }
        return canvasView
    }

    /// Updates the `AgoraRtcVideoCanvas` object for the view with new values, if necessary.
    private func updateCanvasValues() {
        // Update the canvas properties if needed
        if canvas.renderMode != renderMode { canvas.renderMode = renderMode }
        if canvas.cropArea != cropArea { canvas.cropArea = cropArea }
        if canvas.setupMode != setupMode { canvas.setupMode = setupMode }
        if canvas.mirrorMode != mirrorMode { canvas.mirrorMode = mirrorMode }
        if canvas.enableAlphaMask != enableAlphaMask { canvas.enableAlphaMask = enableAlphaMask }
        if let manager {
            self.setUserId(to: self.canvasId, agoraEngine: manager.agoraEngine)
        }
    }
}
extension AgoraVideoCanvasView {
    #if os(iOS)
    /// Creates and configures a `UIView` for the view. This UIView will be the view the video is rendered onto.
    ///
    /// - Parameter context: The `UIViewRepresentable` context.
    ///
    /// - Returns: A `UIView` for displaying the video stream.
    public func makeUIView(context: Context) -> UIView {
        createCanvasView()
    }

    /// Updates the Canvas view.
    public func updateUIView(_ uiView: UIView, context: Context) {
        self.updateCanvasValues()
    }
    #elseif os(macOS)
    /// Creates and configures a `NSView` for the view. This UIView will be the view the video is rendered onto.
    ///
    /// - Parameter context: The `NSViewRepresentable` context.
    ///
    /// - Returns: A `NSView` for displaying the video stream.
    public func makeNSView(context: Context) -> NSView {
        createCanvasView()
    }

    /// Updates the Canvas view.
    public func updateNSView(_ uiView: NSView, context: Context) {
        self.updateCanvasValues()
    }
    #endif
}//
//  AgoraVideoCanvasView.swift
//  velo-cmdb-app
//
//  Created by Nick Black on 5/6/24.
//

import Foundation
