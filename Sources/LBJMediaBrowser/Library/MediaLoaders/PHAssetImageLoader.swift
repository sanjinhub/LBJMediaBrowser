import Photos
import AlamofireImage

final class PHAssetImageLoader: MediaLoader<MediaImageStatus, PHImageRequestID> {

  static let shared = PHAssetImageLoader()

  let manager: PHImageManagerType
  let imageCache: ImageCache

  init(
    manager: PHImageManagerType = PHImageManager(),
    imageCache: ImageCache = .shared
  ) {
    self.manager = manager
    self.imageCache = imageCache
  }

  func loadImage(for assetImage: MediaPHAssetImage, targetSize: ImageTargetSize) {
    let cacheKey = assetImage.cacheKey(for: targetSize)
    imageCache.image(forKey: cacheKey) { [unowned self] result in
      if let image = try? result.get() {
        updateStatus(.loaded(image), forKey: cacheKey)
      } else {
        requestImage(for: assetImage, targetSize: targetSize)
      }
    }
  }

  private func requestImage(for assetImage: MediaPHAssetImage, targetSize: ImageTargetSize) {
    let cacheKey = assetImage.cacheKey(for: targetSize)

    guard isLoading(forKey: cacheKey) == false else { return }

    requestQueue.async { [unowned self] in

      let options = PHImageRequestOptions()
      options.version = .original
      options.isNetworkAccessAllowed = true

      let requestId = manager.requestImage(
        for: assetImage.asset,
           targetSize: assetImage.targetSize(for: targetSize),
           contentMode: assetImage.contentMode(for: targetSize),
           options: options
      ) { [unowned self] result in

        removeRequestId(forKey: cacheKey)

        switch result {
        case .success(let image):
          updateStatus(.loaded(image), forKey: cacheKey)
          imageCache.store(image, forKey: cacheKey)
        case .failure(let error):
          updateStatus(.failed(error), forKey: cacheKey)
        }
      }

      updateRequestId(requestId, forKey: cacheKey)
    }
  }

  func cancelLoading(for assetImage: MediaPHAssetImage, targetSize: ImageTargetSize) {
    let cacheKey = assetImage.cacheKey(for: targetSize)

    if let requestId = requestIdCache[cacheKey] {
      manager.cancelImageRequest(requestId)
    }

    let currentStatus = imageStatus(for: assetImage, targetSize: targetSize)
    if currentStatus.isLoaded == false {
      removeStatus(forKey: cacheKey)
    }

    removeRequestId(forKey: cacheKey)
  }

  func imageStatus(for assetImage: MediaPHAssetImage, targetSize: ImageTargetSize) -> MediaImageStatus {
    statusCache[assetImage.cacheKey(for: targetSize)] ?? .idle
  }
}
