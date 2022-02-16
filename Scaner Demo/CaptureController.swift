//
//  ViewController.swift
//  Scaner Demo
//
//  Created by Sashko Shel on 14.02.2022.
//

import UIKit
import AVFoundation
import Photos

class CaptureController: UIViewController, AVCapturePhotoCaptureDelegate {

    @IBOutlet var previewView: PreviewView!
    @IBOutlet weak var flashlightButton: UIButton!
    @IBOutlet weak var shotButton: UIButton!
    var photoOutput: AVCapturePhotoOutput = AVCapturePhotoOutput()
    var videoDeviceInput: AVCaptureDeviceInput?
    var imageData: UIImage?
    var needFlashlight: AVCaptureDevice.FlashMode = .off
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let captureSession = AVCaptureSession()
        
        captureSession.beginConfiguration()
        let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .unspecified)
            
        do {
            videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice!)
            captureSession.canAddInput(videoDeviceInput!)
        } catch {
            return
        }
        
        captureSession.addInput(videoDeviceInput!)
        
//        photoOutput
        guard captureSession.canAddOutput(photoOutput) else { return }
        captureSession.sessionPreset = .photo
        captureSession.addOutput(photoOutput)
        captureSession.commitConfiguration()
        
        previewView.videoPreviewLayer.session = captureSession
        
        if let photoOutputConnection = photoOutput.connection(with: .video) {
            photoOutputConnection.videoOrientation = previewView.videoPreviewLayer.connection!.videoOrientation
        }
        
        captureSession.startRunning()
    }
    
    @IBAction func captureAction(_ sender: Any) {
        shotButton.isEnabled = false
        var photoSettings = AVCapturePhotoSettings()

        // Capture HEIF photos when supported. Enable auto-flash and high-resolution photos.
        if  photoOutput.availablePhotoCodecTypes.contains(.hevc) {
            photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])
        }

        if (videoDeviceInput != nil) {
            if videoDeviceInput!.device.isFlashAvailable {
                photoSettings.flashMode = needFlashlight
            }
        }

//        photoSettings.isHighResolutionPhotoEnabled = true
        if let previewPhotoPixelFormatType = photoSettings.availablePreviewPhotoPixelFormatTypes.first {
            photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPhotoPixelFormatType]
        }
        
        self.photoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {

        guard let cgImage = photo.cgImageRepresentation() else { return }
//        let orientation = photo.metadata[kCGImagePropertyOrientation as String] as! NSNumber
//        let uiOrientation = UIImage.Orientation(rawValue: orientation.intValue)!
        self.imageData = UIImage(cgImage: cgImage, scale: 1, orientation: .right)
            
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "OpenCVSegue", sender: nil) //must be in main dispatch
        }

//        PHPhotoLibrary.shared().performChanges({
//            let creationRequest = PHAssetCreationRequest.forAsset()
//            creationRequest.addResource(with: .photo, data: photo.fileDataRepresentation()!, options: nil)
//        }, completionHandler: { (isSuccessful: Bool, error: Error?) in
//
//        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        shotButton.isEnabled = true
        if segue.identifier == "OpenCVSegue" {
            let OpenCVController = segue.destination as! OpenCVController
            OpenCVController.imageData = self.imageData
        }
    }
    
    @IBAction func toggleFlashlight(_ sender: Any) {
        if (needFlashlight == .off) {
            needFlashlight = .on
            flashlightButton.setImage(UIImage(systemName: "lightbulb.fill"), for: .normal)
        } else {
            needFlashlight = .off
            flashlightButton.setImage(UIImage(systemName: "lightbulb"), for: .normal)
        }
    }
}

