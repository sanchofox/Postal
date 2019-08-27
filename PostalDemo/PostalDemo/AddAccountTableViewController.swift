//
//  ViewController.swift
//  PostalDemo
//
//  Created by Kevin Lefevre on 23/05/2016.
//  Copyright © 2017 snips. All rights reserved.
//

import UIKit
import Postal

protocol MailProvider {
    var hostname: String { get }
    var preConfiguration: Configuration? { get }
}

enum Pop3MailProvider: Int, MailProvider {
    case google
    case aruba
    
    var hostname: String {
        switch self {
        case .google:
            return "google.com"
        case .aruba:
            return "aruba.it"
        }
    }
    
    var preConfiguration: Configuration? {
        switch self {
        case .google:
            return Pop3Configuration.gmail(login: "", password: "")
        case .aruba:
            return Pop3Configuration.aruba(login: "", password: "")
        }
    }
}


enum ImapMailProvider: Int, MailProvider {
    case icloud
    case google
    case yahoo
    case outlook
    case aol

    var hostname: String {
        switch self {
        case .icloud: return "icloud.com"
        case .google: return "gmail.com"
        case .yahoo: return "yahoo.com"
        case .outlook: return "outlook.com"
        case .aol: return "aol.com"
        }
    }
    
    var preConfiguration: Configuration? {
        switch self {
        case .icloud: return ImapConfiguration.icloud(login: "", password: "")
        case .google: return ImapConfiguration.gmail(login: "", password: .plain(""))
        case .yahoo: return ImapConfiguration.yahoo(login: "", password: .plain(""))
        case .outlook: return ImapConfiguration.outlook(login: "", password: "")
        case .aol: return ImapConfiguration.aol(login: "", password: "")
        }
    }
}

final class AddAccountTableViewController: UITableViewController {
    fileprivate let loginSegueIdentifier = "loginSegue"    
}

// MARK: - View lifecycle

extension AddAccountTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


// MARK: - Navigation management

extension AddAccountTableViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == loginSegueIdentifier {
            let vc = segue.destination as? LoginTableViewController
            if let prov = sender as? ImapMailProvider {
                vc?.provider = prov
            }
            else if let prov = sender as? Pop3MailProvider {
                vc?.provider = prov
            }
            
        }

    }
}

// MARK: - UITableViewDelegate

extension AddAccountTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        var provider: MailProvider?
        
        switch indexPath.section {
        case 0:
            guard let mProvider = ImapMailProvider(rawValue: indexPath.row) else {
                fatalError("Unknown provider")
            }
            provider = mProvider

        case 1:
            guard let mProvider = Pop3MailProvider(rawValue: indexPath.row) else {
                fatalError("Unknown provider")
            }
            provider = mProvider
        default:
            break
        }
        
        performSegue(withIdentifier: loginSegueIdentifier, sender: provider)
        
    }
}
