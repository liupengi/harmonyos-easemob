import { ChatCallback, ChatClient, ChatError, ChatLog} from '@easemob/chatsdk'
import UserInfoModel from '../../utils/db/UserInfoModel'
import Notification from '../../utils/Notification'
import dataPreference from '@ohos.data.preferences'
import { router } from '@kit.ArkUI'
import TimeConversion from '../../utils/TimeConversion'

//全局公共样式
@Styles function fillScreen(){
  .width('100%')
  .backgroundColor(Color.White)
  .borderRadius(20)
  .height(120)
  .padding(10)
}
@Component
export struct MeComponent {
  @State avatarUrl:string |undefined =''

  @State nickname:string |undefined =''

  aboutToAppear(): void {
    ChatClient.getInstance().userInfoManager()?.fetchUserInfoById(ChatClient.getInstance().getCurrentUser()).then((value)=>{
      value.forEach((value)=>{
       this.avatarUrl = value.avatarUrl
       this.nickname = value.nickname
      })
    })

  }

  build() {
    Column(){

        if (this.avatarUrl === undefined || this.avatarUrl === ''){
          Image($r("app.media.ease_default_avatar_1"))
            .width(100)
            .height(100)
        }else {
          Image(this.avatarUrl)
            .width(100)
            .height(100)
        }
        Text(this.nickname)
          .margin({top:20})

      Text("ID:"+ChatClient.getInstance().getCurrentUser())
        .margin({top:20})

      Button('退出登录')
        .margin({top:300})
        .onClick(()=>{
          ChatClient.getInstance().logout().then(()=>{
            dataPreference.getPreferences(getContext(),'easemob')
              .then( preferences=>{
                {
                  preferences.put("isAutoLogin", false).then(()=>{
                    preferences.flush()
                  })

                }

              }).catch( () =>{

            })
            router.replaceUrl({
              url:"pages/Index",
            })


          }).catch((e:ChatError)=>{
            if (e.errorCode === 201) {
              dataPreference.getPreferences(getContext(),'easemob')
                .then( preferences=>{
                  {
                    preferences.put("isAutoLogin", false).then(()=>{
                      preferences.flush()
                    })

                  }

                }).catch( () =>{

              })
              router.replaceUrl({
                url:"pages/Index",
              })
            }
          })
        })
      Button('新增数据测试')

        .onClick(()=>{

          //UserInfoModel.addUserInfo("p2","测试昵称1222","https://q4.itc.cn/q_70/images03/20240528/298d4abda5e4469d98fa77e7cde46525.jpeg")
          ChatClient.getInstance().userInfoManager()?.updateUserInfo({avatarUrl:"https://q4.itc.cn/q_70/images03/20240528/298d4abda5e4469d98fa77e7cde46525.jpeg",nickname:"测试设置的昵称"})
        })
      Button('查询数据')

        .onClick(async ()=>{

        })
    }
    .alignItems(HorizontalAlign.Center)


  }
}
