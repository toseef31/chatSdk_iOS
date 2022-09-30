//
//  popupMessageAction.swift
//  Moozy_App
//
//  Created by Ali Abdullah on 18/05/2022.
//

import Foundation
import UIKit

class PopupMessageAction: UIView{
    
    var tblMessage: UITableView?
    
    var values: [attacmentArr]? = []
    var isSender: Bool? = false
    
    init(isSender: Bool? = false, frame: CGRect = .zero) {
        self.isSender = isSender
        super.init(frame: frame)
        values = ConstantStrings.attacments.messageActiomName
        if isSender!{
            values?.remove(at: 2)
            values?.remove(at: 3)
        }else{
            values?.remove(at: 0)
        }
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializedControls(){
        
        layer.cornerRadius = 10
        clipsToBounds = true
        configureTableView()
    }
    
    func configureUI(){
        
        initializedControls()
        addSubview(tblMessage!)
        tblMessage?.fillSuperView()
    }
    
    func configureTableView(){
        tblMessage = UITableView()
        tblMessage?.register(AttachmentCell.self, forCellReuseIdentifier: "Cell")
        tblMessage?.delegate = self
        tblMessage?.dataSource = self
        tblMessage?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tblMessage?.separatorStyle = .none
        tblMessage?.isScrollEnabled = false
    }
}

extension PopupMessageAction: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! AttachmentCell
        cell.dataSet = values![indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        NotificationCenter.default.post(name: .selectMessagesAction, object: nil, userInfo: ["select": values![index].name ?? "" ])
    }
}
