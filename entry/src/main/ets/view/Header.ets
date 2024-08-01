import router from '@ohos.router'

@Component
export struct Header {
  @Prop title: ResourceStr
  @Prop isReturn: boolean = true
  @Prop isAdd: boolean = false

  build() {
    //标题部分
    Row() {
      if (this.isReturn) {
        Image($r('app.media.ease_default_navigation_icon'))
          .width(30)
          .onClick(() => {
            router.back()
          })
      }
      Text(this.title)
        .fontSize(25)
        .fontWeight(FontWeight.Bold)
      Blank()

      if (this.isAdd) {
        Image($r('app.media.ease_icon_add'))
          .width(40)
          .height(40)
          .onClick(() => {

          })
      }
    }
    .width('100%')
    .height(30)


  }
}