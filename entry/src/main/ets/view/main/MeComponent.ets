import { ChatCallback, ChatClient, ChatError, ChatLog} from 'easemob'
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


  aboutToAppear(): void {


  }

  build() {
    Column(){
      Row(){
        Image($r("app.media.ease_default_avatar_1"))
          .width(100)
          .height(100)
        Column({space:4}){
          Text("")
            .fontSize(20)
            .fontWeight(FontWeight.Bold)


        }
        .alignItems(HorizontalAlign.Start)
        .padding({left:10})
      }
      .fillScreen()
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

          })
        })
      Button('新增数据测试')

        .onClick(()=>{

          UserInfoModel.addUserInfo("p2","测试昵称1222","https://q4.itc.cn/q_70/images03/20240528/298d4abda5e4469d98fa77e7cde46525.jpeg")

        })
      Button('查询数据')

        .onClick(async ()=>{

        })
    }


  }
}
