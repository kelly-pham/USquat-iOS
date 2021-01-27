//
//  CameraViewController.swift
//  USquat-ios
//
//  Created by Kelly Pham on 1/22/21.
//

import SwiftUI
import UIKit
import AVFoundation

struct CameraViewController: View {
    @StateObject var camera = CameraModel()
    var body: some View {
        ZStack{
            CameraPreview(camera: camera)
                .ignoresSafeArea(.all, edges: .all)
            
            // Draw Switch Button
            VStack{
                HStack{
                    Spacer()
                    Button(action: camera.changeCamera, label:{
                        Text("Switch")
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white)
                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)

                    })
                }
            }
        }
        .onAppear(){
            camera.Check()
        }
    }
}

struct CameraViewController_Previews: PreviewProvider {
    static var previews: some View {
        CameraViewController()
    }
}

public enum SessionSetupResult {
    case success
    case notAuthorized
    case configurationFailed
}

// MARK: DEFINE CAMERA MODEL
class CameraModel: ObservableObject{
    
    // create session
    @Published var session = AVCaptureSession()
    @Published var setupResult: SessionSetupResult = .success
    
    // video input
    @objc dynamic var videoDeviceInput: AVCaptureDeviceInput!
    private let videoDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera,.builtInWideAngleCamera,.builtInTrueDepthCamera], mediaType: .video, position: .unspecified)
    // Manage session
    private var sessionQueue = DispatchQueue(label: "session queue")
    
    // AV preview
    @Published var preview: AVCaptureVideoPreviewLayer!
    
    // MARK: CHECK CAMERA PERMISSION
    func Check(){
        // Checking permission to use Camera
        switch AVCaptureDevice.authorizationStatus(for: .video){
        case .authorized:
            setUp() // setting things up
            return
        case .notDetermined:
            // Request Access for Camera usage
            AVCaptureDevice.requestAccess(for: .video) { (status) in
                if status {
                    self.setUp()
                }
            }
        case .denied:
            return
        default:
            return
            
        }
    }
    
    // MARK: SETTING UP CAMERA
    func setUp(){
          
        if setupResult != .success {
            return
        }
        
        do {
            // setting configuration
            self.session.beginConfiguration()
            
            var defaultVideoDevice: AVCaptureDevice?
            
            // Add video input
            if let dualCameraDevice = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .front){
                defaultVideoDevice = dualCameraDevice
            } else if let backCameraDevice = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back){
                defaultVideoDevice = backCameraDevice
            } else if let frontCameraDevice = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .front){
                defaultVideoDevice = frontCameraDevice
            }
            
            guard let videoDevice = defaultVideoDevice else {
                print("Default Camera is unavailable")
                setupResult = .configurationFailed
                return
                
            }
            
            // input
            let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
            
            // Checking and adding input to session
            guard self.session.canAddInput(videoDeviceInput) else {
                return
            }
            self.session.addInput(videoDeviceInput)
            
            //output
            let videoDeviceOutput = AVCaptureVideoDataOutput()
            
            
            // Checking output
            if self.session.canAddOutput(videoDeviceOutput){
                self.session.addOutput(videoDeviceOutput)
                // Add Video Data Output
                videoDeviceOutput.alwaysDiscardsLateVideoFrames = true
                videoDeviceOutput.videoSettings = [
                    String(kCVPixelBufferPixelFormatTypeKey): Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
            }
            
            let captureConnection = videoDeviceOutput.connection(with: .video)
            captureConnection?.preferredVideoStabilizationMode = .standard
            
            // Always process frames
            captureConnection?.isEnabled = true
            
            // Commit Session Configurations
            self.session.commitConfiguration()
            
            
            // TODO: Might have to do Video Orientation
            
            
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    // MARK: CHANGE CAMERA VIEW
   
    func changeCamera() {
        self.session.beginConfiguration()
        // get current input
        let currentInput = self.session.inputs.first as? AVCaptureDeviceInput
        // remove input
        self.session.removeInput(currentInput!)
        // If current camera is .back then switch to front and vice versa
        let newCameraDevice = currentInput?.device.position == .back ? getCamera(with: .front) : getCamera(with: .back)
        // add new input
        let newVideoInput = try? AVCaptureDeviceInput(device: newCameraDevice!)
        self.session.addInput(newVideoInput!)
        
        // Commit Device Configuration
        self.session.commitConfiguration()
    }
    
    func getCamera(with position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let devices = self.videoDeviceDiscoverySession.devices
        return devices.filter {
            $0.position == position
            }.first
    }
}

// MARK: CAMERA PREVIEW to DISPLAY

struct CameraPreview: UIViewRepresentable{
  
    @ObservedObject var camera: CameraModel

    func makeUIView(context: Context) ->  UIView {
        let view = UIView(frame: UIScreen.main.bounds)

        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        

        // Own Configuration
        camera.preview.videoGravity =  .resizeAspectFill
        camera.preview.frame = view.frame
        view.layer.addSublayer(camera.preview)
        
        // start running session
        camera.session.startRunning()
        return view
    }
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}

