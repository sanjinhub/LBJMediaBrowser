import SwiftUI

struct URLVideoView<Placeholder: View, Content: View>: View {

  private let urlVideo: MediaURLVideo
  private let placeholder: (MediaType) -> Placeholder
  private let content: (MediaLoadedResult) -> Content

  init(
    urlVideo: MediaURLVideo,
    @ViewBuilder placeholder: @escaping (MediaType) -> Placeholder,
    @ViewBuilder content: @escaping (MediaLoadedResult) -> Content
  ) {
    self.urlVideo = urlVideo
    self.placeholder = placeholder
    self.content = content
  }
  
  var body: some View {
    if let previewUrl = urlVideo.previewImageUrl {
      URLImageView(
        urlImage: .init(imageUrl: previewUrl),
        placeholder: { _ in placeholder(urlVideo) },
        progress: { _ in EmptyView() },
        failure: { _ in
          content(.video(
            video: urlVideo,
            previewImage: nil,
            videoUrl: urlVideo.videoUrl
          ))
        },
        content: { result in
          if case let .image(_, uiImage) = result {
            content(.video(
              video: urlVideo,
              previewImage: uiImage,
              videoUrl: urlVideo.videoUrl
            ))
          }
        }
      )
    } else {
      content(.video(
        video: urlVideo,
        previewImage: nil,
        videoUrl: urlVideo.videoUrl
      ))
    }
  }
}