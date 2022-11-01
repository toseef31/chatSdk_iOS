//
//  bookMarkVC.swift
//  Moozy_App
//
//  Created by Toseef Ahmed on 20/10/2022.
//

import Foundation
import UIKit
import SDWebImage
import QuickLook
import AVFoundation
import CoreLocation

class bookMarkVC: UIViewController {
    
    var topHeaderView: UIView?
    var optionView: UIView?
    //TopHeaderView
    var btnBack: MoozyActionButton?
    var seperatorView: UIView?
    //OptionView
    var tblBookMarkList: UITableView?
    var chatMsgArr : [ChatMessagesModel]? = []
    private var addItemsView: emptyView?
    var OpenfileUrl :NSURL?
    var viewModel : bookMarkVM?
    var viewModels =  ChatDataVM()
    var isLoding : Bool? = false
    
    var timeDeactice = 0.00
    var urlPlayed  : String? = ""
    var audiofilename = ""
    var audioPlayer: AVAudioPlayer?
    var audiotimer:Timer?
    var SelectedAudionRow : IndexPath?
    var playstatus = -1
   
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = bookMarkVM()
        dataBinding()
        configureUI()
    }
    
    func dataBinding(){
        //Loader
        viewModel?.isLoader.bind(observer: { [self] isLoad, _ in
            
            if isLoad.value!{
                isLoding = true
                ActivityController.shared.showActivityIndicator(uiView: view)
            }else{
                isLoding = false
                ActivityController.shared.hideActivityIndicator(uiView: view)
            }
        })
        
        viewModel?.AllChatMsg.bind(observer: { [self] (chat, _ )in
            tblBookMarkList?.backgroundView =  nil
            chatMsgArr = chat.value ?? []
            tblBookMarkList?.reloadData()
        })
        
        if viewModel?.isLoader.value == false && chatMsgArr?.count == 0 {
            tblBookMarkList?.backgroundView  = addItemsView
        }
    }
    
    func initializedControls(){
        view.backgroundColor = UIColor.white
        addItemsView = emptyView(title: "No Friends Available")
        
        topHeaderView = {
            let view = UIView(backgroundColor: .white)
            
            let title = UILabel(title: "BookMarks", fontColor: AppColors.BlackColor, alignment: .center, font: UIFont.font(.PottaOne, type: .Medium, size: 14))
            
            let btnBack = MoozyActionButton(image: UIImage(systemName: "arrow.backward"), foregroundColor: AppColors.BlackColor, backgroundColor: UIColor.clear,imageSize: backButtonSize) {
                self.pop(animated: true)
            }
            
            view.addMultipleSubViews(views: title, btnBack)
            
            btnBack.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 8, bottom: 14, right: 0), size: backButtonSize)
            
            title.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
            title.verticalCenterWith(withView: btnBack)
            
            return view
        }()
        
        
        optionView = {
            let hView = UIView(backgroundColor: UIColor.white)
            configureTableView()
            return hView
        }()
    }
    
    func configureUI(){
        initializedControls()
        
        view.addMultipleSubViews(views: topHeaderView!, optionView!)
        
        topHeaderView?.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        topHeaderView?.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.12).isActive = true
        
        
        optionView?.anchor(top: topHeaderView?.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        //TopHeaderView Constraints
        btnBack?.anchor(top: topHeaderView?.safeAreaLayoutGuide.topAnchor, leading: topHeaderView?.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 12, left: 8, bottom: 0, right: 0), size: backButtonSize)
        
        //OptionView Constraints
        optionView?.addSubview(tblBookMarkList!)
        tblBookMarkList?.fillSuperView(padding: .init(top: 8, left: 8, bottom: 8, right: 8))
    }
    
    
    //Configure Tableview
    func configureTableView(){
        tblBookMarkList = UITableView()
        tblBookMarkList?.register(DisclaimerCell.self, forCellReuseIdentifier: "Cell")
        tblBookMarkList?.register(TextMsgCell.self, forCellReuseIdentifier: "TextMsgCell")
        tblBookMarkList?.register(PhotoMsgCell.self, forCellReuseIdentifier: "Cell2")
        tblBookMarkList?.register(ReplyViewCell.self, forCellReuseIdentifier: "Cell3")
        tblBookMarkList?.register(VideoMsgCell.self, forCellReuseIdentifier: "Cell5")//LocationMsgCell
        tblBookMarkList?.register(AudioMsgCell.self, forCellReuseIdentifier: "Cell6")//AudioMsgCell
        tblBookMarkList?.register(FileMsgCell.self, forCellReuseIdentifier: "Cell7") //FileMsgCell
        
        
        tblBookMarkList?.delegate = self
        tblBookMarkList?.dataSource = self
        tblBookMarkList?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tblBookMarkList?.showsVerticalScrollIndicator = false
        tblBookMarkList?.isScrollEnabled = false
    }
}

extension bookMarkVC: UITableViewDelegate, UITableViewDataSource , ChatItemSelection {
    func audioCellTap(cell: AudioMsgCell) {
        let index = tblBookMarkList?.indexPath(for: cell)
        
        let AudioUrl = APIServices.shared.searchFileExist(fileName: chatMsgArr![index!.section].messagesData![index!.row].messages?.message ?? "" , fileType: 6)
        urlPlayed = AudioUrl //chatMsgArr![indexPath.section].messagesData![indexPath.row].messages?.message ?? ""
        
        btnPlayAction(url: AudioUrl!, IndexpateRow: index!)
        
    }
    
    func audioValueChange(cell: AudioMsgCell, valeSlider: Float) {
        print(valeSlider)
        let index = tblBookMarkList?.indexPath(for: cell)
        audioPlayer?.currentTime = TimeInterval(valeSlider)
        timeDeactice = TimeInterval(valeSlider)
        let AudioUrl = APIServices.shared.searchFileExist(fileName: chatMsgArr![index!.section].messagesData![index!.row].messages?.message ?? "" , fileType: 6)
        urlPlayed = AudioUrl //chatMsgArr![indexPath.section].messagesData![indexPath.row].messages?.message ?? ""
        
        btnPlayAction(url: AudioUrl!, IndexpateRow: index!)
    }
    
    
    func VideoSelected(cell: VideoMsgCell) {
        let index = tblBookMarkList?.indexPath(for: cell)
        
        if (chatMsgArr![index!.section].messagesData![index!.row].messages?.messageType == 5 && chatMsgArr![index!.section].messagesData![index!.row].messages?.chatType == 0)  {
            
            let UrlVedio = "https://chat.chatto.jp:20000/meetingchat/" + (chatMsgArr![index!.section].messagesData![index!.row].messages?.message ?? " ")
            
            guard let url = URL(string: UrlVedio) else {
                print("url not found")
                return
            }
            self.pushTo(viewController: videoPlayers(vedioUrl: UrlVedio)) }
        
    }
    
    func IMGorMapSelected(cell: PhotoMsgCell) {
        
        let index = tblBookMarkList?.indexPath(for: cell)
        
        if (chatMsgArr![index!.section].messagesData![index!.row].messages?.messageType == 1 && chatMsgArr![index!.section].messagesData![index!.row].messages?.chatType == 0  || (chatMsgArr![index!.section].messagesData![index!.row].messages?.messageType == 7 && chatMsgArr![index!.section].messagesData![index!.row].messages?.chatType == 0 )){
            
            let cellImage = AppUtils.shared.loadImage(fileName:chatMsgArr![index!.section].messagesData![index!.row].messages?.message ?? "")
            
            if cellImage != nil{
                if chatMsgArr![index!.section].messagesData![index!.row].messages?.messageType == 7 && chatMsgArr![index!.section].messagesData![index!.row].messages?.chatType == 0 {
                    print("open map")
                    openMap(indexPath: index!)
                } else {
                    pushTo(viewController: previewImageVC(data:chatMsgArr![index!.section].messagesData![index!.row].messages?.message))
                }
                
            }
            else {
                //Start Download
                var isSnetData = false
                if chatMsgArr![index!.section].messagesData![index!.row].messages?.receiverId ?? "" == AppUtils.shared.senderID {
                    isSnetData = false
                }
                
                else {
                    isSnetData = false        }
                
                viewModels.StartDownloading(Messages: chatMsgArr!, location: index!)
                
                viewModels.downloadImage(Messages: chatMsgArr!, imageName: chatMsgArr![index!.section].messagesData![index!.row].messages?.message ?? "", senderId: chatMsgArr![index!.section].messagesData![index!.row].messages?.senderId._id ?? "" , isSent: isSnetData, indexPath: index!)
                
                
            }
        }
    }
    

    
    func AudioSelected(cell: AudioMsgCell) {
        let index = tblBookMarkList?.indexPath(for: cell)
        if (chatMsgArr![index!.section].messagesData![index!.row].messages?.messageType == 6 && chatMsgArr![index!.section].messagesData![index!.row].messages?.chatType == 0) {
            let cellImage = APIServices.shared.searchFileExist(fileName: chatMsgArr![index!.section].messagesData![index!.row].messages?.message ?? "", fileType: 6)
            
            if cellImage == nil{
                var isSnetData = false
                if chatMsgArr![index!.section].messagesData![index!.row].messages?.receiverId ?? "" == AppUtils.shared.senderID {
                    isSnetData = false
                }
                
                else {
                    isSnetData = false        }
                
                viewModels.StartDownloading(Messages: chatMsgArr!, location: index!)
                
                viewModels.downloadAudio(Messages: chatMsgArr!, audioName: chatMsgArr![index!.section].messagesData![index!.row].messages?.message ?? "", senderId: chatMsgArr![index!.section].messagesData![index!.row].messages?.senderId._id ?? "" , isSent: isSnetData, indexPath: index!)
                
            }
            else{
                let AudioUrl = APIServices.shared.searchFileExist(fileName: chatMsgArr![index!.section].messagesData![index!.row].messages?.message ?? "" , fileType: 6)
                urlPlayed = AudioUrl //chatMsgArr![indexPath.section].messagesData![indexPath.row].messages?.message ?? ""
                
                btnPlayAction(url: AudioUrl!, IndexpateRow: index!)
            }
        }
        
        
        
    }
        
        func numberOfSections(in tableView: UITableView) -> Int {
            
            if chatMsgArr?.count == 0{
                return 0
            }else{
                return chatMsgArr?.count ?? 0
            }
        }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            return   chatMsgArr?[section].messagesData?.count ?? 0
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            if (chatMsgArr![indexPath.section].messagesData![indexPath.row].messages?.messageType == 0 && chatMsgArr![indexPath.section].messagesData![indexPath.row].messages?.chatType == 0) {
                
                
                let cell = tblBookMarkList?.dequeueReusableCell(withIdentifier: "TextMsgCell") as! TextMsgCell
                cell.isBookMar = true
                cell.selectionStyle = .none
                cell.isSmsSelected = chatMsgArr?[indexPath.section].messagesData![indexPath.row].isSelected
                cell.chatData = chatMsgArr?[indexPath.section].messagesData![indexPath.row].messages
                cell.backgroundColor = UIColor.white
                cell.mainView?.applyBottomShadow()
                
                let interaction = UIContextMenuInteraction(delegate: self)
                cell.mainView?.addInteraction(interaction)
                cell.mainView?.isUserInteractionEnabled = true
                return cell
            }
            
            else if (chatMsgArr![indexPath.section].messagesData![indexPath.row].messages?.messageType == 0 && chatMsgArr![indexPath.section].messagesData![indexPath.row].messages?.chatType == 1){
                let cell = tblBookMarkList?.dequeueReusableCell(withIdentifier: "Cell3") as! ReplyViewCell
                cell.isBookMar = true
                cell.selectionStyle = .none
                cell.isSmsSelected = chatMsgArr?[indexPath.section].messagesData![indexPath.row].isSelected
                cell.dataSet = chatMsgArr![indexPath.section].messagesData![indexPath.row].messages
                
                cell.backgroundColor = UIColor.clear
                cell.mainView?.applyBottomShadow()
                
                let interaction = UIContextMenuInteraction(delegate: self)
                cell.mainView?.addInteraction(interaction)
                cell.mainView?.isUserInteractionEnabled = true
                return cell
            }
            
            else if (chatMsgArr![indexPath.section].messagesData![indexPath.row].messages?.messageType == 6 && chatMsgArr![indexPath.section].messagesData![indexPath.row].messages?.chatType == 0){
                let cell = tblBookMarkList?.dequeueReusableCell(withIdentifier: "Cell6") as! AudioMsgCell
                cell.isBookMar = true
                cell.selectionStyle = .none
                cell.isdownloading = chatMsgArr![indexPath.section].messagesData![indexPath.row].isDownloading ?? false
                cell.delegteAudioSelected = self
                cell.isSmsSelected = chatMsgArr?[indexPath.section].messagesData![indexPath.row].isSelected
                cell.chatData = chatMsgArr![indexPath.section].messagesData![indexPath.row].messages
                cell.backgroundColor = UIColor.clear
                cell.mainView?.applyBottomShadow()
                
                let interaction = UIContextMenuInteraction(delegate: self)
                cell.mainView?.addInteraction(interaction)
                cell.mainView?.isUserInteractionEnabled = true
                return cell
            }
            
            else if (chatMsgArr![indexPath.section].messagesData![indexPath.row].messages?.messageType == 1 && chatMsgArr![indexPath.section].messagesData![indexPath.row].messages?.chatType == 0){
                let cell = tblBookMarkList?.dequeueReusableCell(withIdentifier: "Cell2") as! PhotoMsgCell
                cell.isBookMar = true
                cell.selectionStyle = .none
                cell.isdownloading = chatMsgArr![indexPath.section].messagesData![indexPath.row].isDownloading ?? false
                cell.delegteImgViewSelected = self
                cell.isSmsSelected = chatMsgArr?[indexPath.section].messagesData![indexPath.row].isSelected
                cell.chatData = chatMsgArr![indexPath.section].messagesData![indexPath.row].messages
                
                let interaction = UIContextMenuInteraction(delegate: self)
                cell.mainView?.addInteraction(interaction)
                cell.mainView?.isUserInteractionEnabled = true
                return cell
            }
            
            
            
            else if (chatMsgArr![indexPath.section].messagesData![indexPath.row].messages?.messageType == 5 && chatMsgArr![indexPath.section].messagesData![indexPath.row].messages?.chatType == 0){
                let cell = tblBookMarkList?.dequeueReusableCell(withIdentifier: "Cell5") as! VideoMsgCell
                cell.delegteVideoSelected = self
                cell.isBookMar = true
                cell.selectionStyle = .none
                cell.isdownloading = chatMsgArr![indexPath.section].messagesData![indexPath.row].isDownloading ?? false
                cell.isSmsSelected = chatMsgArr?[indexPath.section].messagesData![indexPath.row].isSelected
                cell.dataSet =  chatMsgArr![indexPath.section].messagesData![indexPath.row].messages
                
                cell.backgroundColor = UIColor.clear
                let interaction = UIContextMenuInteraction(delegate: self)
                cell.mainView?.addInteraction(interaction)
                cell.mainView?.isUserInteractionEnabled = true
                
                return cell
                
            }
            
            
            else if (chatMsgArr![indexPath.section].messagesData![indexPath.row].messages?.messageType == 2 && chatMsgArr![indexPath.section].messagesData![indexPath.row].messages?.chatType == 0){
                let cell = tblBookMarkList?.dequeueReusableCell(withIdentifier: "Cell7") as! FileMsgCell
                
                cell.isBookMar = true
                cell.selectionStyle = .none
                cell.isdownloading = chatMsgArr![indexPath.section].messagesData![indexPath.row].isDownloading ?? false
                cell.isSmsSelected = chatMsgArr?[indexPath.section].messagesData![indexPath.row].isSelected
                
                cell.chatData = chatMsgArr![indexPath.section].messagesData![indexPath.row].messages
                
                
                cell.backgroundColor = UIColor.clear
                cell.mainView?.applyBottomShadow()
                let interaction = UIContextMenuInteraction(delegate: self)
                cell.mainView?.addInteraction(interaction)
                cell.mainView?.isUserInteractionEnabled = true
                return cell
            }
            
            
            else {
                //used as map
                let cell = tblBookMarkList?.dequeueReusableCell(withIdentifier: "Cell2") as! PhotoMsgCell
                cell.selectionStyle = .none
                cell.isBookMar = true
                cell.isdownloading = chatMsgArr![indexPath.section].messagesData![indexPath.row].isDownloading ?? false
                cell.isSmsSelected = chatMsgArr?[indexPath.section].messagesData![indexPath.row].isSelected
                cell.chatData = chatMsgArr?[indexPath.section].messagesData![indexPath.row].messages
                cell.delegteImgViewSelected = self
                cell.backgroundColor = UIColor.clear
                
                let interaction = UIContextMenuInteraction(delegate: self)
                cell.mainView?.addInteraction(interaction)
                cell.mainView?.isUserInteractionEnabled = true
                
                return cell
            }
        }
        
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            if (chatMsgArr![indexPath.section].messagesData![indexPath.row].messages?.messageType == 2 && chatMsgArr![indexPath.section].messagesData![indexPath.row].messages?.chatType == 0) {
                
                let indexPathe = tblBookMarkList?.indexPathForSelectedRow //optional, to get from any UIButton for example
                
                let currentCell = tblBookMarkList?.cellForRow(at: indexPathe!) as! FileMsgCell
                
                print("oPEN Files Here....")
                let fileis = chatMsgArr![indexPath.section].messagesData![indexPath.row].messages?.message ?? ""
                let dataCompare = fileis.count > 38  ? String(fileis.dropFirst(37) ) : fileis
                
                
                var docPath =  DownloadData.sharedInstance.searchFileExist(fileName: dataCompare, fileType: 2)
                currentCell.imgdownloadFile.isHidden = true
                
                if docPath == "" || docPath == nil {
                    var isSnetData = false
                    if chatMsgArr![indexPath.section].messagesData![indexPath.row].messages?.receiverId ?? "" == AppUtils.shared.senderID {
                        isSnetData = false
                    }
                    else {
                        isSnetData = false   }
                    
                    viewModels.StartDownloading(Messages: chatMsgArr!, location: indexPath)
                    print(chatMsgArr![indexPath.section].messagesData![indexPath.row].messages?.message ?? "")
                    viewModels.dowloadFile(Messages: chatMsgArr!, fileName: chatMsgArr![indexPath.section].messagesData![indexPath.row].messages?.message ?? "", isSent: isSnetData, senderId: chatMsgArr![indexPath.section].messagesData![indexPath.row].messages?.senderId._id ?? "", indexPath: indexPath)
                    
                }
                else{
                    docPath = "file://" + docPath!
                    OpenfileUrl = NSURL(string: docPath!)
                    let quickLookViewController = QLPreviewController()
                    quickLookViewController.dataSource = self
                    self.present(quickLookViewController, animated: true, completion: nil)
                }
                
            }
            
            else {
                print("nil")
            }
        }
        
    }
    

    
    extension bookMarkVC : QLPreviewControllerDataSource {
        func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            return 1
        }
        
        func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            return OpenfileUrl!
        }
    }
    
    
    
    extension bookMarkVC : UIContextMenuInteractionDelegate {
        
        
        func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
            
            let location = interaction.location(in: tblBookMarkList!)
            guard let indexPath = tblBookMarkList?.indexPathForRow(at: location) else {
                return nil
            }
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [self] _ -> UIMenu? in
                //                smsStatus is used to indicate that sms send or recived.
                var issmsRecived = false
                if  chatMsgArr?[indexPath.section].messagesData?[indexPath.row].messages?.receiverId ?? "" == AppUtils.shared.senderID {
                    issmsRecived = true
                }
                else {
                    issmsRecived = false
                    
                }
                
                return self.createContextMenu(issmsRecived: issmsRecived, stringTocpy: chatMsgArr?[indexPath.section].messagesData?[indexPath.row].messages?.message ?? "0", messageType: chatMsgArr?[indexPath.section].messagesData?[indexPath.row].messages?.messageType ?? 0 , messageid: chatMsgArr?[indexPath.section].messagesData?[indexPath.row].messages?._id ?? "", reciverid: chatMsgArr?[indexPath.section].messagesData?[indexPath.row].messages?.receiverId ?? "", status: "0" , indexRow: indexPath)
            }
            
        }
        
        func createContextMenu(issmsRecived: Bool,stringTocpy: String, messageType : Int,messageid: String? = "", reciverid: String? = "" , status: String? = "" , indexRow : IndexPath) -> UIMenu {
            let bookImage = UIImage(systemName: "bookmark")?.withTintColor(AppColors.primaryColor, renderingMode: .alwaysOriginal)
            
            let removebookMark = UIAction(title: "Remove bookmark", image: bookImage) { [self] _ in
                viewModel?.unBookMark(messageId: messageid, receiverId: reciverid)
                print(indexRow.row)
                chatMsgArr![indexRow.section].messagesData?.remove(at: indexRow.row)
                tblBookMarkList?.reloadData()
                
            }
            return UIMenu( options: .singleSelection, children: [removebookMark])
            
        }
    }
    
    
    extension bookMarkVC: AVAudioPlayerDelegate {
        
        func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
            let visibleIndexPaths = tblBookMarkList?.indexPathsForVisibleRows
            let res = visibleIndexPaths?.contains(SelectedAudionRow!)
            if res == false {
                timeDeactice = 0.00
                audiotimer?.invalidate()
                timeDeactice = 0.00
                let setindexpath = IndexPath(row: 0, section:  0)
                
                SelectedAudionRow = setindexpath
                print("finishedPlayed audion")
                playstatus = -1
                return
                
            }
            let indexpath = IndexPath(row: SelectedAudionRow?.row ?? 0, section: SelectedAudionRow?.section ?? 0)
            let dummycell = self.tblBookMarkList?.cellForRow(at: indexpath) as! AudioMsgCell
            dummycell.downloadbtn.image = #imageLiteral(resourceName: "play_circle")
            audiotimer?.invalidate()
            dummycell.audioslider?.value =  Float(0.0)
            timeDeactice = 0.00
            let setindexpath = IndexPath(row: 0, section:  0)
            
            SelectedAudionRow = setindexpath
            print("finishedPlayed audion")
            playstatus = -1
        }
        
        @objc func btnPlayAction(url: String, IndexpateRow : IndexPath){
            
            if audioPlayer?.isPlaying == true {
                if URL(string: url) != audioPlayer?.url! {
                    timeDeactice = 0.00
                    audioPlayer?.stop()
                    audiotimer?.invalidate()
                    playstatus = -1
                    
                    let indexpath = IndexPath(row: SelectedAudionRow?.row ?? 0, section: SelectedAudionRow?.section ?? 0)
                    
                    let visibleIndexPaths = tblBookMarkList?.indexPathsForVisibleRows
                    let res = visibleIndexPaths?.contains(SelectedAudionRow!)
                    if res == true {
                        let dummycell = self.tblBookMarkList?.cellForRow(at: indexpath) as! AudioMsgCell
                        dummycell.downloadbtn.image = #imageLiteral(resourceName: "play_circle")
                        dummycell.audioslider?.value =  Float(0.0)
                    }
                    
                }
                
            }
            
            else if URL(string: url) != audioPlayer?.url!  &&   SelectedAudionRow?.row  != nil {
                timeDeactice = 0.00
                audioPlayer?.stop()
                audiotimer?.invalidate()
                playstatus = -1
                
                let indexpath = IndexPath(row: SelectedAudionRow?.row ?? 0, section: SelectedAudionRow?.section ?? 0)
                
                let visibleIndexPaths = tblBookMarkList?.indexPathsForVisibleRows
                let res = visibleIndexPaths?.contains(SelectedAudionRow!)
                if res == true {
                    let dummycell = self.tblBookMarkList?.cellForRow(at: indexpath) as! AudioMsgCell
                    dummycell.downloadbtn.image = #imageLiteral(resourceName: "play-circle-1")
                    dummycell.audioslider?.value =  Float(0.0)
                }
            }
            
            else {
                print("not plauing")
            }
            
            print("Play/Puse")
            let stopCurrent = false
            let indexpath = IndexPath(row: IndexpateRow.row, section: IndexpateRow.section)
            let dummycell = self.tblBookMarkList?.cellForRow(at: indexpath) as! AudioMsgCell
            
            SelectedAudionRow = IndexpateRow
            print(url)
            print(IndexpateRow.row)
            if url != nil{
                
                if playstatus < 0{
                    var error: NSError?
                    do {
                        guard let audiourl = URL(string: url) else {return}
                        if audioPlayer != nil {
                            audioPlayer?.stop()
                            audiotimer?.invalidate()
                        }
                        audioPlayer = try AVAudioPlayer(contentsOf: audiourl)
                    } catch let err as NSError {
                        error = err
                        self.audioPlayer = nil
                    }
                    if let err = error {
                        print("AVAudioPlayer error: \(err.localizedDescription)")
                    }else {
                        audioPlayer?.delegate = self
                        audioPlayer?.prepareToPlay()
                        dummycell.downloadbtn.image = #imageLiteral(resourceName: "pausebtn")
                        
                        audioPlayer?.play()
                        audiotimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateslider(sender:)), userInfo: nil, repeats: true)
                    }
                    
                    playstatus = 1
                }else if playstatus > 0{
                    // timeDeactice = 0.00
                    if ((audioPlayer?.isPlaying) == true){
                        audiotimer?.invalidate()
                        dummycell.downloadbtn.image = #imageLiteral(resourceName: "play-circle-1")
                        self.audioPlayer?.pause()
                    }else{
                        dummycell.downloadbtn.image = #imageLiteral(resourceName: "pausebtn")
                        audiotimer?.invalidate()
                        self.audioPlayer?.play()
                        audiotimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateslider(sender:)), userInfo: nil, repeats: true)
                    }
                }else {
                    timeDeactice = 0.00
                    audioPlayer?.stop()
                    playstatus = -1
                    //  checckcellplaystatus(index: playcellindex, status: -1)
                }
            }
            
        }
        
        
        @objc func updateslider(sender:UISlider) {
            
            var clrimg = UIImage()
            var audioduration:Float? = 0
            var audiotimestring:String? = ""
            (audioduration,audiotimestring) = checkaudiotime(audiourl: URL(string: urlPlayed!)!)
            let indexpath = IndexPath(row: SelectedAudionRow?.row ?? 0, section: SelectedAudionRow?.section ?? 0)
            
            let visibleIndexPaths = tblBookMarkList?.indexPathsForVisibleRows
            let res = visibleIndexPaths?.contains(indexpath)
            if res == false {
                
                timeDeactice += 0.01
                return
            }
            
            let dummycell = self.tblBookMarkList?.cellForRow(at: indexpath) as! AudioMsgCell
            dummycell.downloadbtn.image = #imageLiteral(resourceName: "pausebtn")
            dummycell.audioslider?.maximumValue = audioduration ?? 0.0
            print(audioduration)
            print(TimeInterval.self)
            
            
            dummycell.audioslider?.value =  Float(timeDeactice) //4.0//Float(audioPlayer!.currentTime)
            let currentTime1 = Int((audioPlayer?.currentTime)!)
            let minutes = currentTime1/60
            let seconds = currentTime1 - minutes * 60
            dummycell.audiotime?.text = NSString(format: "%02d:%02d", minutes,seconds) as String
            
            timeDeactice += 0.01
            print(timeDeactice)
            print(( dummycell.audioslider?.maximumValue ?? 0) + 1.00)
            if Float(timeDeactice)  >= ( dummycell.audioslider?.maximumValue ?? 0) + 1.00 {
                audiotimer?.invalidate()
                dummycell.audioslider?.value =  Float(0.0)
            }
        }
        
        //New Code OF THE Audeio Poalyere
        
        @objc func playAudio(url: String, IndexpateRow : IndexPath) {
            print("playAudio and  updata sliders..")
        }
    }
    
extension bookMarkVC: addLocationDelegate{
    func addLocation(locImage: UIImage, location: CLLocationCoordinate2D) {
      //
    }
    
        
        func openMap(indexPath: IndexPath) {
            let message = chatMsgArr?[indexPath.section].messagesData![indexPath.row].messages?.message.split(separator: "&")
            print(chatMsgArr?[indexPath.section].messagesData![indexPath.row].messages?.message)
            print(message?.count)
            if message?.count ?? 0 > 1{
                let latVal =   Double((message?[0])!)
                let longVal =   Double((message?[1])!)
                if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
                    UIApplication.shared.canOpenURL(NSURL(string:
                                                            "comgooglemaps://?saddr=&daddr=\(latVal ?? 0.0),\(longVal ?? 0.0)&directionsmode=driving")! as URL)
                }else{
                    var direction:String = ""
                    direction = "http://maps.apple.com/?daddr=\(latVal ?? 0.0),\(longVal ?? 0.0)"
                    let directionsURL = URL(string: direction)
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(directionsURL!)
                    } else {
                        UIApplication.shared.openURL(directionsURL!)
                    }
                }
            }
        }
        
        
}
