//
//  ScanerViewController.swift
//  ZrobiQR
//
//  Created by SHIN MIKHAIL on 06.02.2024.
//

import UIKit
import AVFoundation
import SnapKit

final class ScanerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    private let restartButton: UIButton = {
        let button = UIButton()
        button.setTitle("Перезапустити", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 10
        return button
    }()
    // цикл
    override func viewDidLoad() {
        super.viewDidLoad()
        requestCameraAccess()
        setupTarget()
        setupRestartButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    // запрос на разрешение камеры
    private func requestCameraAccess() {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            guard let self = self else { return }
            if granted {
                // Разрешение получено
                DispatchQueue.main.async {
                    self.setupCamera()
                    // Проверка и остановка сессии, если она запущена
                    if let captureSession = self.captureSession, captureSession.isRunning {
                        captureSession.stopRunning()
                    }
                }
            } else {
                // Разрешение не получено
                // Возможно, вы хотите предложить пользователю включить доступ к камере в настройках приложения
            }
        }
    }
    // включение самой камеры
    private func setupCamera() {
        // Инициализация capture session
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            // типы который сканер поймет
            metadataOutput.metadataObjectTypes = [.qr, .ean13, .ean8, .pdf417, .upce, .code128, .code39, .aztec, .interleaved2of5, .itf14]
            
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        DispatchQueue.global(qos: .background).async {
            self.captureSession.startRunning()
        }
    }
    // target
    private func setupTarget() {
        restartButton.addTarget(self, action: #selector(restartCamera), for: .touchUpInside)
    }
    
    private func setupRestartButton() {
        view.addSubview(restartButton)
        restartButton.layer.zPosition = 99999
        restartButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
    }
    // перезапуск
    @objc private func restartCamera() {
        DispatchQueue.global(qos: .background).async {
            self.captureSession.startRunning()
        }
    }
    // ошибка
    private func failed() {
        let ac = UIAlertController(title: "Помилка", message: "Не вдалося ініціалізувати камеру", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    // показываем результат и стоп камера
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first, let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject {
            if let result = readableObject.stringValue {
                // Показываем результат сканирования
                showScanResult(result)
            }
        }
    }
    // показать результат
    private func showScanResult(_ result: String) {
        // Создаем всплывающее сообщение
        let alert = UIAlertController(title: "Результат сканування", message: result, preferredStyle: .alert)
        // Добавляем действие "Копировать"
        alert.addAction(UIAlertAction(title: "Копіювати", style: .default, handler: { _ in
            // Копируем результат сканирования в буфер обмена
            UIPasteboard.general.string = result
            // Показываем сообщение об успешном копировании
            self.showAlert(title: "Чудово", message: "Текст скопійовано у буфер обміну")
        }))
        // Добавляем действие "Закрыть"
        alert.addAction(UIAlertAction(title: "Закрити", style: .cancel, handler: { _ in
            // При нажатии на "Закрыть" снова запускаем сканирование
            DispatchQueue.global(qos: .background).async {
                self.captureSession.startRunning()
            }
        }))
        // Отображаем всплывающее сообщение
        present(alert, animated: true)
    }
    // алерт
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            DispatchQueue.global(qos: .background).async {
                self.captureSession.startRunning()
            }
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
