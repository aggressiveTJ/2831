//
//  ImagePicker.swift
//  MonthlyCollage
//
//  Created by TJ on 2020/08/19.
//  Copyright © 2020 TJ. All rights reserved.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    
    private let sourceType: UIImagePickerController.SourceType
    private let onImagePicked: ((UIImage) -> Void)
    
    init(sourceType: UIImagePickerController.SourceType, onImagePicked: @escaping ((UIImage) -> Void)) {
        self.sourceType = sourceType
        self.onImagePicked = onImagePicked
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.allowsEditing = true
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onImagePicked: onImagePicked, onDismiss: {
            self.presentationMode.wrappedValue.dismiss()
        })
    }
    
    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        private let onImagePicked: ((UIImage) -> Void)
        private let onDismiss: (() -> Void)
        
        init(onImagePicked: @escaping ((UIImage) -> Void), onDismiss: @escaping (() -> Void)) {
            self.onImagePicked = onImagePicked
            self.onDismiss = onDismiss
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.editedImage] as? UIImage {
                onImagePicked(image)
            }
            
            onDismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            onDismiss()
        }
    }
}
