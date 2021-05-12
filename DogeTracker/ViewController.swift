//
//  ViewController.swift
//  DogeTracker
//
//  Created by Carlos Cardona on 07/05/21.
//

import UIKit



class ViewController: UIViewController {
    
    private var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(DogeTableViewCell.self, forCellReuseIdentifier: DogeTableViewCell.identifier)
        
        return table
    }()
    
    private var vieWModels = [nameDogeTableViewCellViewModel]()
    
    static var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 5
        formatter.locale = .current
        formatter.numberStyle = .currency
        return formatter
    }()
    
    static var percentageFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 5
        formatter.locale = .current
        formatter.numberStyle = .percent
        return formatter
    }()
    
    static var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 5
        formatter.locale = .current
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    static var dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = .withFractionalSeconds
        formatter.timeZone = .current
        return formatter
    }()
    
    static let prettyDateForamatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.dateStyle = .medium
        return formatter
    }()
    
    private var data: DogecoinData?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "DOGE"
        
        fetchData()
        setUpViewModels()
        
        tableView.refreshControl = UIRefreshControl()
        
        tableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    @objc private func didPullToRefresh() {
        // Refetch data
        fetchData()
    }
    
    private func fetchData() {
        
        vieWModels.removeAll()
        
        if tableView.refreshControl?.isRefreshing == true {
            print("refreshing data")
        } else {
            print("fetching data")
        }
        
        APICaller.shared.getDogecoinData { [weak self] result in
            switch result {
            case .success(let data):
                self?.data = data
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self?.tableView.refreshControl?.endRefreshing()
                    self?.setUpViewModels()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func setFormatter(value: Double) -> String {
        let number = NSNumber(value: value)
        let string = Self.percentageFormatter.string(from: number)!
        return string
    }
    
    func setNumberFormatter(value: Double) -> String {
        let number = NSNumber(value: value)
        let string = Self.numberFormatter.string(from: number)!
        return string
    }
    
    private func setUpViewModels() {
        guard let model = data else { return }
        
        configureTableView()
        
        let number = NSNumber(value: model.quote["USD"]!.market_cap)
        let string = Self.formatter.string(from: number)
        
        guard let quote = model.quote["USD"] else { return }
        
        // Create viewModels
        vieWModels = [
            nameDogeTableViewCellViewModel(title: "Name", value: model.name),
            nameDogeTableViewCellViewModel(title: "Symbol", value: "$" + model.symbol),
            nameDogeTableViewCellViewModel(title: "1 Hour change %", value: setFormatter(value: Double(quote.percent_change_1h))),
            nameDogeTableViewCellViewModel(title: "24 Hour change %", value: setFormatter(value: Double(quote.percent_change_24h))),
            nameDogeTableViewCellViewModel(title: "7 Day change %", value: setFormatter(value: Double(quote.percent_change_7d))),
            nameDogeTableViewCellViewModel(title: "Market cap", value: string!),
            nameDogeTableViewCellViewModel(title: "Total supply", value: setNumberFormatter(value: Double(model.total_supply)))
        ]
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        configureHeader()
    }
    
    private func configureHeader() {
        
        guard let price = data?.quote["USD"]?.price else { return }
         
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width / 1.3))
        header.clipsToBounds = true
        
        // Image
        let image = UIImageView(image: UIImage(named: "dogecoin"))
        image.contentMode = .scaleAspectFit
        let size: CGFloat = view.frame.size.width / 3
        image.frame =  CGRect(x: (view.frame.size.width-size) / 2, y: 10, width: size, height: size)
        
        header.addSubview(image)
        
        //Label
        let number = NSNumber(value: price)
        let string = Self.formatter.string(from: number)
        
        let label = UILabel()
        label.text = string
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 42, weight: .medium)
        label.frame = CGRect(x: 10, y: 20 + size, width: view.frame.size.width - 20, height: 200)
        header.addSubview(label)
        
        tableView.tableHeaderView = header
        
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vieWModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DogeTableViewCell.identifier, for: indexPath) as? DogeTableViewCell else {
            fatalError()
        }
        cell.configure(with: vieWModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
