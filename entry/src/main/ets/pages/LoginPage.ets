import { LoginComponent } from '../view/LoginComponent';
import dataPreference from '@ohos.data.preferences'
import router from '@ohos.router';

@Entry
@Component
struct LoginPage {
  @State context :Context= getContext()
  aboutToAppear(): void {

    dataPreference.getPreferences(getContext(), 'easemob')
      .then(async preferences => {
        {
          if (await preferences.get("isAutoLogin", false)) {
            router.replaceUrl({
              url: "pages/MainPage",
            })
          }

        }

      }).catch(() => {

    })


  }

  build() {
    Column() {
      this.Title()
      Scroll() {
        Column() {
          LoginComponent({context:this.context})
            .padding(30)
        }
        .margin({ top: 100 })
      }
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  Title() {
    Row() {
      Text($r('app.string.title'))
        .fontSize($r('app.float.title_text_size'))
        .fontColor($r('app.color.title'))
        .fontWeight(500)
        .align(Alignment.Center)
    }
    .width('100%')
    .height($r('app.float.title_height'))
    .justifyContent(FlexAlign.Center)
  }
}