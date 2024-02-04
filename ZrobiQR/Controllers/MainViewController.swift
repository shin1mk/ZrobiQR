//
//  MainViewController.swift
//  ZrobiQR
//
//  Created by SHIN MIKHAIL on 03.02.2024.
//
/*
 Вот несколько распространенных типов QR-кодов:

 URL QR Code: Содержит веб-ссылку для быстрого доступа к веб-сайту.
 Текстовый QR Code: Может содержать простой текстовый блок информации.
 WiFi QR Code: Позволяет быстро подключиться к беспроводной сети Wi-Fi.
 Социальные медиа QR Code: Содержит ссылки на профили в социальных сетях.
 Email QR Code: Создает готовое электронное письмо для автоматической отправки.
 SMS QR Code: Генерирует готовое SMS-сообщение.
 Геолокационный QR Code: Содержит координаты местоположения.
 Контактные данные (vCard) QR Code: Предоставляет контактные данные, такие как имя, номер телефона и адрес электронной почты.
 Событие в календаре (Calendar Event) QR Code: Содержит информацию о событии, которую можно добавить в календарь.
 PayPal QR Code: Позволяет быстро совершать платежи через сервис PayPal.
 Bitcoin QR Code: Для сканирования адреса Bitcoin для проведения транзакций.
 Аудио QR Code: Может содержать аудиофайл или текст, который может быть озвучен.
 Ссылка на приложение (App Store / Google Play) QR Code: Ссылка для быстрого доступа к загрузке приложения.
 Это некоторые из популярных видов, и существует множество других, предназначенных для различных сфер применения.
 Wi-Fi Credentials QR Code: Подобно Wi-Fi QR Code, но содержит конкретные учетные данные для подключения.
 Текстовая заметка QR Code: Содержит короткий текст или заметку.
 Контактные данные (MeCard) QR Code: Подобно vCard, но использует немного другой формат.
 Skype Call QR Code: Запускает звонок через Skype.
 WhatsApp Message QR Code: Создает готовое сообщение для отправки через WhatsApp.
 Event Ticket QR Code: Содержит информацию о билете на мероприятие.
 Boarding Pass QR Code: Используется для электронных посадочных билетов.
 Health Card QR Code: Может содержать медицинскую информацию, такую как группа крови или аллергии.
 ID Card QR Code: Содержит информацию, ассоциированную с личностью, например, на рабочей карточке.
 ISBN QR Code: Для быстрого доступа к информации о книге, используя ее ISBN.
 Product Information QR Code: Содержит информацию о продукте, такую как цена, описание или ссылка на сайт.
 Coupon QR Code: Используется для получения скидок или промокодов.
 Virtual Business Card (MeCard) QR Code: Аналог vCard, использующий другой формат.
 Loyalty Card QR Code: Для хранения информации о программе лояльности.
 */

import UIKit
import SnapKit

final class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // свойства
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Create code"
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
    private let data = ["QR-code", "EAN-13", "UPC-A", "Wi-Fi", "VCard"]
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
        default:
            print("Выбран элемент: \(data[indexPath.row])")
        }
    }
}
