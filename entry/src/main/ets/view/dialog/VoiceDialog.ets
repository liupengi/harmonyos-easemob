import picker from '@ohos.file.picker';
import { checkAppPermission } from '../../utils/permissions/CheckAccess'
import { common } from '@kit.AbilityKit';
import camerapicker from '@ohos.multimedia.cameraPicker';
import camera from '@ohos.multimedia.camera';
import { BusinessError } from '@ohos.base';
import { ChatMessage, } from 'easemob'
import SendMessages from '../../presenter/SendMessage'
import { AudioCapturer } from '../../utils/audio/AudioCapturer'
import fs, { Options } from '@ohos.file.fs';
import AudioRecorder from '../../utils/audio/AudioRecorder'
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
  @State num: number = 0
  @State x: number = 1
  @State audioFilePath: string = ''
  @State pushPayload: string = ''
  //private audioRecorder: AudioRecorder = new AudioRecorder(getContext(this).getApplicationContext())
  private audioCapturer: AudioCapturer = new AudioCapturer(getContext(this).getApplicationContext())
  private file?: fs.File

  async initRecorder(): Promise<void> {
    try {
      const catchDir = getContext(this).getApplicationContext().cacheDir
      let fileDir = catchDir + '/easemob';
      if (!fs.accessSync(fileDir)) {
        fs.mkdirSync(fileDir);
      }

      this.audioFilePath = fileDir + `/${Date.now()}.wav`
      this.file = fs.openSync(this.audioFilePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
      let bufferSize = 0
      //this.audioRecorder.startRecordingProcess(this.audioFilePath)
      this.audioCapturer.init((buffer) => {
        let options = {
          length: buffer.byteLength
        } as Options

        fs.writeSync(this.file?.fd, buffer, options);
        bufferSize += buffer.byteLength;
        console.info(`read bufffer size`, bufferSize)
      })
      //shownDialog(true, JSON.stringify('start audio recorder', null, 2))
    } catch (error) {
      //shownDialog(false, processV2ErrorForPrint(error))
    }
  }

  async startRecorder(): Promise<void> {
    try {
      //const catchDir = getContext(this).getApplicationContext().cacheDir
      //let fileDir = catchDir + '/nim';
      //if (!fs.accessSync(fileDir)) {
      //  fs.mkdirSync(fileDir);
      //}
      //
      //this.audioFilePath = fileDir + `/${Date.now()}.aac`
      //this.audioRecorder.startRecordingProcess(this.audioFilePath)
      this.audioCapturer.start()
    } catch (error) {
    }
  }

  async stopRecorder(): Promise<void> {
    try {
      //await this.audioRecorder.stopRecordingProcess(this.audioFilePath)
      this.audioCapturer.stop(() => {
        fs.close(this.file)
        this.audioCapturer.release()
      })

    } catch (error) {
    }
  }
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
                // this.initRecorder()
                // this.startRecorder()
                 AudioRecorder.startRecordingProcess()
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
                AudioRecorder.stopRecordingProcess()
                // stop().then((filePath)=>{
                //   if (filePath) {
                //     this.filePath = filePath
                //   }
                //   console.log("录音文件"+filePath)
                // })
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

              SendMessages.sendVoiceMessage(this.conversationId + "", AudioRecorder.audioPath, this.num).then((value) => {

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
