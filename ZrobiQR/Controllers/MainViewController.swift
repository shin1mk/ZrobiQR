//
//  MainViewController.swift
//  ZrobiQR
//
//  Created by SHIN MIKHAIL on 03.02.2024.
//
/*
 Социальные медиа QR Code: Содержит ссылки на профили в социальных сетях.
 Email QR Code: Создает готовое электронное письмо для автоматической отправки.
 Геолокационный QR Code: Содержит координаты местоположения.
 Событие в календаре (Calendar Event) QR Code: Содержит информацию о событии, которую можно добавить в календарь.
 Event Ticket QR Code: Содержит информацию о билете на мероприятие.
 Boarding Pass QR Code: Используется для электронных посадочных билетов.
 Health Card QR Code: Может содержать медицинскую информацию, такую как группа крови или аллергии.
 ID Card QR Code: Содержит информацию, ассоциированную с личностью, например, на рабочей карточке.
 Product Information QR Code: Содержит информацию о продукте, такую как цена, описание или ссылка на сайт.
 
 https://appstoreconnect.apple.com/apps/6477355052/appstore/ios/version/inflight
 */

import UIKit
import SnapKit

final class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // свойства
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Create QR code"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    private let data = ["QR code", "EAN-13 code", "UPC-A code", "Wi-Fi code", "VCard code", "URL code", "Message code"]
    // цикл
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }
    // метод
    private func setupUI() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(0)
            make.leading.equalToSuperview().offset(15)
        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(0)
            make.trailing.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview()
        }
    }
    // делегаты
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        
        return cell
    }
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            let qrViewController = QRViewController()
            navigationController?.pushViewController(qrViewController, animated: true)
        case 1:
            let eanViewController = EANViewController()
            navigationController?.pushViewController(eanViewController, animated: true)
        case 2:
            let upcViewController = UPCViewController()
            navigationController?.pushViewController(upcViewController, animated: true)        
        case 3:
            let wifiViewController = WifiViewController()
            navigationController?.pushViewController(wifiViewController, animated: true)
        case 4:
            let vcardViewController = VCardViewController()
            navigationController?.pushViewController(vcardViewController, animated: true)        
        case 5:
            let urlViewController = URLViewController()
            navigationController?.pushViewController(urlViewController, animated: true)        
        case 6:
            let messageViewController = MessageViewController()
            navigationController?.pushViewController(messageViewController, animated: true)
        default:
            print("Выбран элемент: \(data[indexPath.row])")
        }
    }
}
