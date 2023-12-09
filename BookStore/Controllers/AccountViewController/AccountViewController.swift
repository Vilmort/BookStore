//
//  AccountViewController.swift
//  BookStore
//
//  Created by Vanopr on 02.12.2023.
//

import UIKit

final class AccountViewController: UIViewController {
    
    private let defaults = UserDefaults.standard
    private let boundsX = UIScreen.main.bounds.width
    private let boundsY = UIScreen.main.bounds.height
    
    private var textFieldMy: UITextField {
        let textView = UITextField(frame: CGRect.init(x: boundsX * 0.10, y: boundsY / 2, width: boundsX * 0.80, height: boundsY * 0.05))
        let leftView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 80, height: view.frame.size.height))
        let label = UILabel(frame: CGRect.init(x: 20, y: 0, width: 100, height: view.frame.size.height))
        label.text = "Name:"
        leftView.addSubview(label)
        textView.placeholder = "Name"
        textView.layer.cornerRadius = 10
        textView.leftView = leftView
        textView.leftViewMode = .always
        textView.textColor = .black
        textView.font = .boldSystemFont(ofSize: 20)
        textView.backgroundColor = .systemGray5
        return textView
    }
    
    func loadImage() -> UIImage {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let imageUrl = documentsURL.appendingPathComponent("avatar.png")
        guard fileManager.fileExists(atPath: imageUrl.path) else {
            return UIImage(named: "flow")!
        }
        return UIImage(contentsOfFile: imageUrl.path)!
    }
    
    private var avatarView: UIImageView = {
        
        var view = UIImageView()
        view.layer.frame.size.height = 200
        view.layer.frame.size.width = view.layer.frame.size.height
        view.layer.cornerRadius = view.bounds.height/2
        view.clipsToBounds = true
        return view
    }()
    
    func setAvatarConstraints() {
        avatarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        avatarView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        avatarView.widthAnchor.constraint(equalToConstant: avatarView.frame.width).isActive = true
        avatarView.heightAnchor.constraint(equalToConstant: avatarView.frame.height).isActive = true
        avatarView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc private func profileImageButtonTapped() {
        showImagePickerControleActionSheet()
    }
    
    func tapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(profileImageButtonTapped))
        avatarView.isUserInteractionEnabled = true
        avatarView.addGestureRecognizer(tap)
    }
    
    override func viewDidLoad() {
        let userName = textFieldMy
        avatarView.image = loadImage()
        userName.text = defaults.string(forKey: "username") == nil ? "" : "\(defaults.string(forKey: "username")!)"
        super.viewDidLoad()
        view.backgroundColor = .purple
        view.addSubview(avatarView)
        view.addSubview(userName)
        tapGesture()
        userName.delegate = self
        
        
        setAvatarConstraints()
    }
}

extension AccountViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showImagePickerControleActionSheet() {
        let actionSheet = UIAlertController(title: "PhotoSource", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.schoosePicker(sourceType: .camera)
            } else {print("Camera are not available") }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            self.schoosePicker(sourceType: .photoLibrary)}))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true)
    }
    
    func schoosePicker(sourceType: UIImagePickerController.SourceType){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            saveImage(editedImage)
            avatarView.image = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            avatarView.image = originalImage
            saveImage(originalImage)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func saveImage(_ image: UIImage) {
        guard let data = image.pngData() else
        {
            return
        }
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let imageUrl = documentsURL.appendingPathComponent("avatar.png")
        do {
            try data.write(to: imageUrl)
        } catch {
            print("Ошибка сохранения изображения")
        }
    }
    
}


extension AccountViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.endEditing(true)
        defaults.set(textField.text, forKey: "username")
        return true
    }
}




