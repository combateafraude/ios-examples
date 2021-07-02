//
//  DocumentDetectorCustomViewController.swift
//  iOS-example
//
//  Created by Daniel Seitenfus on 01/07/21.
//

import UIKit
import DocumentDetector

class DetectorViewController: UIViewController, DocumentDetectorCustomViewControllerDelegate {

    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var documentMask: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var labelStepName: UILabel!
    
    private var controller: DocumentDetectorCustomViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let documentDetector = DocumentDetector.Builder(mobileToken: Configuration.mobileToken)
        
        documentDetector.setDocumentDetectorFlow(flow: [
            DocumentDetectorStep(document: Document.RG_FRONT, stepLabel: nil, illustration: nil, audio: nil),
            DocumentDetectorStep(document: Document.RG_BACK, stepLabel: nil, illustration: nil, audio: nil)
        ])
        
        documentDetector.showPreview(true, title: nil, subtitle: nil, confirmLabel: nil, retryLabel: nil)
        
        self.controller = DocumentDetectorCustomViewController(documentDetector: documentDetector.build(), viewController: self, previewView: previewView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.controller.viewWillDisappear()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.controller.viewDidAppear()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.controller.viewDidLayoutSubviews()
    }
    
    // MARK: - UI Changes
    
    func show(loading show: Bool) {
        if(show){
            activityIndicator.startAnimating()
        }else{
            activityIndicator.stopAnimating()
        }
    }
    
    func show(message text: String) {
        labelMessage.text = text
    }
    
    func show(stepName text: String) {
        labelStepName.text = text
    }
    
    func show(mask type: MaskType) {

        switch type {
        case .normal:
            self.documentMask.image = UIImage(named: "document_mask_white")
            break
        case .success:
            self.documentMask.image = UIImage(named: "document_mask_green")
            break
        case .error:
            self.documentMask.image = UIImage(named: "document_mask_red")
            break
        default:
            self.documentMask.image = UIImage(named: "document_mask_white")
        }
    }
    
    // MARK: - SDK Response
    
    func documentDetectionController(didFinishWithResults results: DocumentDetectorResult) {
        self.openCompleted()
    }
    
    func documentDetectionControllerDidCancel() {
        self.openCompleted()
    }
    
    func documentDetectionController(didFailWithError error: DocumentDetectorFailure) {
        self.openCompleted()
    }
    
    // MARK: - Screen Actions
    
    func openCompleted(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeButtonClick(_ sender: Any) {
        self.controller.cancelButtonClick()
    }
    
}
