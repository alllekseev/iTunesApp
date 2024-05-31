//
//  DetailViewController.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 07/05/2024.
//

import UIKit
import SafariServices

final class DetailViewController: UIViewController {

  fileprivate var itemDetails: StoreItem
  private var image: UIImage?

  var imageTask: Task<Void, Never>?
  let detailView: DetailView

  init(itemDetails: StoreItem) {
    self.itemDetails = itemDetails
    self.detailView = DetailView()
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    prepareUI()
    detailView.delegate = self

    detailView.configure(for: itemDetails)
  }
}

extension DetailViewController: OpenLinkDelegate {
  func openLink(with url: URL?) {
    if let url {
      let webViewController = SFSafariViewController(url: url)
      present(webViewController, animated: true, completion: nil)
    }
  }
}

extension DetailViewController: PrepareView {
  func prepareUI() {
    configureAppearance()
    setupViews()
    configureConstraints()
  }

  func setupViews() {
    view.setupView(detailView)
  }
  
  func configureConstraints() {
    NSLayoutConstraint.activate([
      detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      detailView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      detailView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      detailView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
    ])
  }
  
  func configureAppearance() {
    view.backgroundColor = .systemBackground
  }
}
