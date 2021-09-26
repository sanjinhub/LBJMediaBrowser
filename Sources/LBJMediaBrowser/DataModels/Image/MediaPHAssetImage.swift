import Photos

public struct MediaPHAssetImage: MediaImageStatusEditable {

  let asset: PHAssetWrapper
  let targetSize: CGSize
  let contentMode: PHImageContentMode

  public internal(set) var status: MediaImageStatus = .idle

  public init(
    asset: PHAsset,
    targetSize: CGSize = PHImageManagerMaximumSize,
    contentMode: PHImageContentMode = .aspectFit
  ) {
    guard asset.mediaType == .image else {
      fatalError("[MediaPHAssetImage] The `asset` should be a type of image.")
    }
    self.asset = PHAssetWrapper(asset: asset)
    self.targetSize = targetSize
    self.contentMode = contentMode
  }

  init(
    asset: PHAssetWrapper,
    targetSize: CGSize = PHImageManagerMaximumSize,
    contentMode: PHImageContentMode = .aspectFit
  ) {
    self.asset = asset
    self.targetSize = targetSize
    self.contentMode = contentMode
  }
}