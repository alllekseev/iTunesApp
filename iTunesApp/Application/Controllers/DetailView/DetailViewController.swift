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
//  private let loader = Loader().indicator
//  private var stateManager = StateManager<Data> {
//
//  }

  var imageTask: Task<Void, Never>?
  lazy var detailView: DetailView = {
    imageTask?.cancel()
    imageTask = Task {
      do {
        guard let url = itemDetails.artworkURL else { return }
        try await loadImage(from: url)
      } catch {

      }
      imageTask = nil
    }
    let view = DetailView(itemDetails: itemDetails, image: image ?? UIImage(systemName: "photo")!)
    return view
  }()

  init(itemDetails: StoreItem) {
    self.itemDetails = itemDetails
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

  @MainActor
  func loadImage(from url: URL) async throws {
    do {
      let image = try await UIImage.fetchImage(from: url)
      self.image = image
    } catch let error as NSError where error.domain == NSURLErrorDomain && error.code == NSURLErrorCancelled {
      // ignore cancelation errors
    } catch {
      throw APIError.unknownError(error: error)
    }
  }
}

extension DetailViewController: DetailViewDelegate {
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
