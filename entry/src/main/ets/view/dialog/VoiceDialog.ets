import picker from '@ohos.file.picker';
import { checkAppPermission } from '../../utils/permissions/CheckAccess'
import { common } from '@kit.AbilityKit';
import camerapicker from '@ohos.multimedia.cameraPicker';
import camera from '@ohos.multimedia.camera';
import { BusinessError } from '@ohos.base';
import { ChatMessage, } from 'easemob'
import SendMessages from '../../presenter/SendMessage'
import { Size, start, stop } from '../../utils/AudioCapturer'

@CustomDialog
@Component
export struct VoiceDialog {
  @Prop conversationId: ResourceStr
  @Prop imgMsg: ChatMessage | undefined = undefined
  changeMessage = (imgMsg: ChatMessage | undefined) => {
  }
  @State isStart: boolean = true
  private controller: CustomDialogController
  private context = getContext(this) as common.UIAbilityContext; //UIAbilityContext
  @State isShow: boolean = false
  @State isShowTime: boolean = false
  private filePath: string = ''
  @State num: number = 0
  @State x: number = 1

  build() {
    Column() {
      Row() {
        if (this.isShow) {
          Button({ type: ButtonType.Circle, stateEffect: false })
            .backgroundColor(0xacb4b9)
            .width(40)
            .height(40)
            .backgroundImage($r('app.media.ease_chat_voice_file_delete'))
            .backgroundImageSize({ width: 15, height: 15 })
            .backgroundImagePosition(Alignment.Center)
        }


        if (this.isShowTime === false){
          Button({ type: ButtonType.Capsule, stateEffect: false })
            .backgroundColor(0x009eff)
            .width(72)
            .height(48)
            .backgroundImage($r('app.media.ease_chat_voice_icon'))
            .backgroundImageSize({width:20,height:20})
            .backgroundImagePosition(Alignment.Center)
            .onClick(()=>{
              if (this.isStart === true) {
                console.log("开始录音")
                start()
                this.isStart = false
                this.x = setInterval(()=>{
                  this.num++
                },1000)
              }
              this.isShowTime = true
            })
        }
        if (this.isShowTime === true){
          Button(this.num+'s',{ type: ButtonType.Capsule, stateEffect: false })
            .backgroundColor(0x009eff)
            .width(72)
            .height(48)
            .backgroundImageSize({width:20,height:20})
            .backgroundImagePosition(Alignment.Center)
            .onClick(()=>{
              if (this.isStart=== false) {
                console.log("停止录音")
                clearInterval(this.x)
                stop().then((filePath)=>{
                  if (filePath) {
                    this.filePath = filePath
                  }
                  console.log("录音文件"+filePath)
                })
                this.isShow = true
              }
            })

        }


        if (this.isShow === true) {
          Button({ type: ButtonType.Circle, stateEffect: false })
            .backgroundColor(0x009eff)
            .width(40)
            .height(40)
            .backgroundImage($r('app.media.ease_chat_send_icon'))
            .backgroundImageSize({ width: 15, height: 15 })
            .backgroundImagePosition(Alignment.Center)
            .onClick(async () => {
              SendMessages.sendVoiceMessage(this.conversationId + "", this.filePath, this.num).then((value) => {
                // this.changeMessage(value)
              })
            })
        }


      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceEvenly)

    }
    .width('100%')
    .height(200)
    .justifyContent(FlexAlign.Center)

  }
}
