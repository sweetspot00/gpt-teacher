//
//  TeacherCardViewController.swift
//  bot_teacher
//
//  Created by niwanchun on 2023/3/4.
//

import UIKit

class TeacherCardsViewController: UIViewController {
    
    // MARK: -UI
    private lazy var tableVw: UITableView = {
        
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor(white: 1, alpha: 1)
        tv.estimatedRowHeight = 100
        tv.separatorStyle = .none
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tv.register(CardsTableViewCell.self, forCellReuseIdentifier: CardsTableViewCell.cellId)
        return tv
        
    }()

    // MARK: -Lifecycle
    override func loadView() {
        super.loadView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(white: 1, alpha: 1)
    }


}

private extension TeacherCardsViewController {
    
    func setup() {
        
        self.title = "Teachers List"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        tableVw.dataSource = self
        
        self.view.addSubview(tableVw)
        
        tableVw.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}


// MARK: - UITableViewDataSource
extension TeacherCardsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teachers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let teacher = teachers[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CardsTableViewCell.cellId, for: indexPath) as! CardsTableViewCell
        
        cell.configure(with: teacher)
        
        return cell
    }
    
    
}
