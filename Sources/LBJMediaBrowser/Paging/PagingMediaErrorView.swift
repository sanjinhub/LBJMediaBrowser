import SwiftUI

struct PagingMediaErrorView: View {

  @EnvironmentObject
  private var browser: PagingBrowser

  let error: Error

  var body: some View {
    VStack(spacing: Constant.stackSpacing) {
      Image(systemName: "multiply")
        .foregroundColor(.white)
        .font(.system(size: Constant.multiplyFontSize, weight: .light))

      Text(error.localizedDescription)
        .foregroundColor(.white)

      Button {
        browser.loadMedia(at: browser.currentPage, withAdjacent: false)
      } label: {
        Text("Retry")
          .font(.system(size: Constant.retryFontSize, weight: .regular))
          .foregroundColor(.black)
          .frame(size: Constant.retryFrameSize)
          .background(.white)
          .cornerRadius(Constant.retryCornerRadius)
      }
    }
  }
}

private extension PagingMediaErrorView {
  enum Constant {
    static let stackSpacing: CGFloat = 20
    static let multiplyFontSize: CGFloat = 80
    static let retryFontSize: CGFloat = 16
    static let retryFrameSize: CGSize = .init(width: 100, height: 40)
    static let retryCornerRadius: CGFloat = 20
  }
}

#if DEBUG
struct PagingErrorView_Previews: PreviewProvider {
  static var previews: some View {
    PagingMediaErrorView(error: NSError.unknownError)
      .padding()
      .background(.black)
  }
}
#endif