//
//  DetailViewController.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 07/05/2024.
//

import UIKit

final class DetailViewController: UIViewController {

  private var itemDetails: StoreItem
  private var image: UIImage?

  var imageTask: Task<Void, Never>?
  let detailView: DetailView

  init(itemDetails: StoreItem) {
    self.itemDetails = itemDetails
    self.detailView = DetailView(itemDetails: itemDetails)
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    prepareUI()
    detailView.delegate = self
  }
}

extension DetailViewController: OpenLinkDelegate {
  func openLink() {
    print("linked: \(String(describing: itemDetails.artworkURL)) open")
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
