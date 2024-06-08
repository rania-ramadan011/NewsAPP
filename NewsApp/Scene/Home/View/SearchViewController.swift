//
//  SearchViewController.swift
//  NewsApp
//
//  Created by Shaimaa Mohammed on 08/06/2024.
//

import UIKit
import Combine
import NewsCore

class SearchViewController: UIViewController {
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var SearchResultTableView: UITableView!
    var cancellables = Set< AnyCancellable > ()
    let searchViewModel = SearchViewModel()
    let homeViewModel = HomeViewModel()
    var articles: [Article]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        setBinding()
        registerTableViewCell()
        homeViewModel.getHeadlines(country: "us")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    func registerTableViewCell(){
        let cellNib = UINib(nibName:"ArticalCell", bundle: nil)
        self.SearchResultTableView.register(cellNib, forCellReuseIdentifier: "ArticalCell")
    }
    
    
    
    func setDelegates(){
        SearchResultTableView.delegate = self
        SearchResultTableView.dataSource = self
        searchTextField.delegate = self
    }
    
    func setBinding() {
        searchViewModel.$resultResponse.sink { [weak self] articles in
            self?.articles = articles
            DispatchQueue.main.async {
                self?.SearchResultTableView.reloadData()
            }
        }
        .store(in: &cancellables)
        searchViewModel.$error.sink {error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        .store(in: &cancellables)
        //Home
        homeViewModel.$resultResponse.sink { [weak self] articles in
            self?.articles = articles
            DispatchQueue.main.async {
                self?.SearchResultTableView.reloadData()
            }
        }
        .store(in: &cancellables)
        homeViewModel.$error.sink {error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        .store(in: &cancellables)
    }
    
}
extension SearchViewController:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        searchViewModel.getSearchResualt(keyword: textField.text ?? "")
        print("inside textfeild delegate ")
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

extension SearchViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles?.count ?? 0 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SearchResultTableView.dequeueReusableCell(withIdentifier: "ArticalCell") as! ArticalCell
        cell.setDataToArticalCell(ArticalModel: articles![indexPath.row])
        cell.action = {
            let articaleUrl =  self.articles![indexPath.row].url
            UIApplication.shared.openURL(NSURL(string: articaleUrl ?? "") as! URL)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
