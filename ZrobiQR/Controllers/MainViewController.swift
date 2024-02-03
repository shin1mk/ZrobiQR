//
//  MainViewController.swift
//  ZrobiQR
//
//  Created by SHIN MIKHAIL on 03.02.2024.
//

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
    private let data = ["QR-code", "EAN-13", "UPC-A", "Элемент 4", "Элемент 5"]
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
        default:
            print("Выбран элемент: \(data[indexPath.row])")
        }
    }
}
