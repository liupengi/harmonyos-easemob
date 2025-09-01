@Entry
@Component
struct TestPage {
  private webController: WebController = new WebController();

  build() {
    Column() {
      Web({ src: 'https://support-webim-api-test.easemob.com/', controller: this.webController })
        .javaScriptAccess(true)
        .domStorageAccess(true)
        .mixedMode(MixedMode.All)
        .id('webview')
        .width('100%')
        .height('100%')

    }
    .height('100%')
    .width('100%')
  }

}
