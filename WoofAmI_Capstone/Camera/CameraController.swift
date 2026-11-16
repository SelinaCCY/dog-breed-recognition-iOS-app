//
//  CameraController.swift
//  WoofAmI_Capstone
//
//  Created by Selina Cheah on 23/01/2024.
//

import Foundation
import UIKit
import AVFoundation

class CameraController: UIViewController{
    
    weak var delegate: CameraControllerDelegate?
    
    //capture session
    var session: AVCaptureSession? //optional
    
    //photo output
    let output = AVCapturePhotoOutput()
    
    //video preview
    let previewLayer = AVCaptureVideoPreviewLayer()
    
    //shutter button
    private let shutterButton: UIButton = {
        let button = UIButton(frame: CGRect(x:0, y:0, width:100, height:100))
        button.layer.cornerRadius = 50
        button.layer.borderWidth = 10
        button.layer.borderColor = UIColor(named: "orange-bright")?.cgColor
        return button
    }()
    
    //image picker button
    private let photoLibraryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "photo"), for: .normal)
        button.tintColor = UIColor(named: "orange-bright")
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.layer.addSublayer(previewLayer)
        view.addSubview(shutterButton)
        
        checkCameraPermissions()
        
        shutterButton.addTarget(self, action: #selector(didTapTakePhoto), for: .touchUpInside)
        
        //configure photo library button
        view.addSubview(photoLibraryButton)
        photoLibraryButton.addTarget(self, action: #selector(photoLibraryButtonTapped), for: .touchUpInside)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        session?.startRunning()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        session?.stopRunning()
    }

    //frame
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
        
        shutterButton.center = CGPoint(x: view.frame.size.width/2,
                                       y: view.frame.size.height - 100)
        
        // Layout the photo library button
        photoLibraryButton.frame = CGRect(
            x: 20,
            y: view.frame.size.height - 120,
            width: 60,
            height: 60
        )
    }
    
    @objc func photoLibraryButtonTapped(){
        print("Photo library button tapped.")
        delegate?.didTapChoosePhoto()
    }
    
    //implement cameraControllerDelegate method
    func didTapChoosePhoto(){
        
    }
    
    //camera permission
    private func checkCameraPermissions(){
        switch AVCaptureDevice.authorizationStatus(for: .video){
            
        case .notDetermined:
            //request permission
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async{ [weak self] in
                        self?.setUpCamera()
                    }
                }
            }
            
        case .restricted:
            break
            
        case .denied:
            break
            
        case .authorized:
            DispatchQueue.main.async{ [weak self] in
                self?.setUpCamera()
            }
            
        @unknown default:
            break
        }
    }
    
    private func setUpCamera(){
        DispatchQueue.main.async{
            let session = AVCaptureSession()
            
            //check device
            guard let device = AVCaptureDevice.default(for: .video) else{
                print("ERROR: No video device available")
                return
            }
            
            do{
                //prepare input to add to session
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input){
                    session.addInput(input)
                } else{
                    print("ERROR: Could not add input to session")
                    return
                }
                
                //prepare output to add to session
                if session.canAddOutput(self.output){
                    session.addOutput(self.output)
                } else{
                    print("ERROR: Could not add output to session")
                    return
                }
                
                //configure preview layer
                self.previewLayer.videoGravity = .resizeAspectFill
                self.previewLayer.session = session
                
                session.startRunning()
                self.session = session
            }
            catch{
                print("Error setting up camera input: \(error)")
            }
        }
        
    }
    
    //session availability
    @objc private func didTapTakePhoto(){
        guard let session = session, session.isRunning else{
            print("Session is not running")
            return
        }
        let settings = AVCapturePhotoSettings()
        output.capturePhoto(with: settings,
                            delegate: self)
    }
    
}

extension CameraController: AVCapturePhotoCaptureDelegate{
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation() else{
            return
        }
        guard let image = UIImage(data: data) else{
            print("failed to convert photo data to UIImage")
            return
        }
        
        delegate?.didCapturePhoto(image)
        
    }
}
