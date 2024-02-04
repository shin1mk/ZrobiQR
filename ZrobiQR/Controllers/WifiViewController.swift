//
//  WifiViewController.swift
//  ZrobiQR
//
//  Created by SHIN MIKHAIL on 04.02.2024.
//

import UIKit
import SnapKit
import Photos

final class WifiViewController: UIViewController, UIGestureRecognizerDelegate {
    // свойства
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Wi-Fi Response Code"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let generateButton: UIButton = {
        let button = UIButton()
        button.setTitle("Сгенерировать", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemGray6
        return button
    }()

    private let wifiSSIDTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Wi-Fi SSID"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.returnKeyType = .done
        textField.keyboardType = .asciiCapable
        textField.clearButtonMode = .whileEditing
        return textField
    }()

    private let wifiPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Wi-Fi Password"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.returnKeyType = .done
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    private let saveToGalleryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Сохранить", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemGray6
        return button
    }()
    private var imageView: UIImageView = {
        let newImageView = UIImageView()
        newImageView.contentMode = .scaleAspectFit
        newImageView.translatesAutoresizingMaskIntoConstraints = false
        return newImageView
    }()
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    private let shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.tintColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    // цикл
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGesture()
        setupUI()
        setupTarget()
        setupDelegate()
    }
    // ui
    private func setupUI() {
        view.backgroundColor = .black
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(0)
            make.leading.equalToSuperview().offset(15)
        }
        view.addSubview(wifiSSIDTextField)
        wifiSSIDTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(45)
        }
        
        view.addSubview(wifiPasswordTextField)
        wifiPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(wifiSSIDTextField.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(45)
        }
        view.addSubview(generateButton)
        generateButton.snp.makeConstraints { make in
            make.top.equalTo(wifiPasswordTextField.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(45)
        }
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(generateButton.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(200)
        }
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        view.addSubview(saveToGalleryButton)
        saveToGalleryButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(45)
        }
        view.addSubview(shareButton)
        shareButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(0)
            make.trailing.equalToSuperview().offset(0)
            make.width.equalTo(50)
        }
    }
    // target
    private func setupTarget() {
        saveToGalleryButton.addTarget(self, action: #selector(saveToGalleryButtonTapped), for: .touchUpInside)
        generateButton.addTarget(self, action: #selector(generateButtonTapped), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
    }
    // делегат
    private func setupDelegate() {
        wifiSSIDTextField.delegate = self
    }
    // жесты
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    // закрытие клавиатуры
    @objc private func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    // Добавим метод делегата UIGestureRecognizerDelegate для точного определения касаний
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !(touch.view is UIControl)
    }
    // generate qr
    @objc private func generateButtonTapped() {
        // Скрыть предыдущий результат
        self.imageView.image = nil
        activityIndicator.startAnimating()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }

            if let ssid = self.wifiSSIDTextField.text, !ssid.isEmpty,
               let password = self.wifiPasswordTextField.text,
               let qrCodeImage = WifiCodeGenerator.generateWiFiQRCode(ssid: ssid, password: password, size: CGSize(width: 2048, height: 2048)) {
                // Set the new image
                self.imageView.image = qrCodeImage
                // Hide activity indicator
                self.activityIndicator.stopAnimating()
            }
        }
        dismissKeyboard(UITapGestureRecognizer())
    }
    // save
    @objc private func saveToGalleryButtonTapped() {
        guard let qrCodeImage = imageView.image else {
            print("Ошибка: Изображение для сохранения в галерею отсутствует")
            return
        }
        
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                // Разрешение получено, можно сохранять изображение
                UIImageWriteToSavedPhotosAlbum(qrCodeImage, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
            case .denied:
                print("Доступ к галерее запрещен.")
                self.showAlert(title: "Ошибка", message: "Доступ к галерее запрещен.")
            case .notDetermined:
                print("Пользователь еще не принял решение относительно доступа к галерее.")
            case .restricted:
                print("Доступ к галерее ограничен.")
                self.showAlert(title: "Ошибка", message: "Доступ к галерее ограничен.")
            default:
                break
            }
        }
    }
    // если получилось или не получилось
    @objc private func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("Ошибка сохранения изображения в галерею: \(error.localizedDescription)")
            self.showAlert(title: "Ой, ошибка", message: "Не удалось сохранить изображение в галерею.")
        } else {
            print("Изображение успешно сохранено в галерею")
            self.showAlert(title: "Отлично!", message: "Изображение успешно сохранено в галерею.")
        }
    }
    // алерт
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    // share
    @objc private func shareButtonTapped() {
        guard let qrCodeImage = imageView.image else {
            print("Ошибка: Изображение для обмена отсутствует")
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: [qrCodeImage], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
} // end
extension WifiViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        generateButtonTapped()
        dismissKeyboard(UITapGestureRecognizer())
        return true
    }
}
// MARK: - generateQRCode
final class WifiCodeGenerator {
    static func generateWiFiQRCode(ssid: String, password: String, size: CGSize) -> UIImage? {
        let wifiConfig = "WIFI:S:\(ssid);T:WPA;P:\(password);;"
        return QRCodeGenerator.generateQRCode(from: wifiConfig, size: size)
    }
}
