import picker from '@ohos.file.picker';
import {checkAppPermission} from '../../utils/permissions/CheckAccess'
import { common } from '@kit.AbilityKit';
import camerapicker from '@ohos.multimedia.cameraPicker';
import camera from '@ohos.multimedia.camera';
import { BusinessError } from '@ohos.base';
import { ChatMessage, } from 'easemob'
import  SendMessages from '../../presenter/SendMessage'
//全局公共样式
@Styles
function fillScreen() {
  .width('100%')
  .backgroundColor(Color.White)
  .borderRadius(20)
  .padding(10)
}

@CustomDialog
@Component
export struct AttachmentMessageDialog {
  @Prop conversationId: ResourceStr
  @Prop imgMsg: ChatMessage|undefined = undefined
  changeMessage = (imgMsg: ChatMessage|undefined)=> {}

  private controller: CustomDialogController
  private context = getContext(this) as common.UIAbilityContext; //UIAbilityContext
  build() {
    Column() {
      Row(){
        Image($r('app.media.ease_chat_image_pressed'))
          .width(20)
          .height(20)
        Text("相册")
          .margin({top:15})
          .fontColor(0xacb4b9)
          .padding({left:20})
      }
      .width('100%')
      .padding(15)
      .alignItems(VerticalAlign.Center)
      .onClick(async () =>{this.photo()})
      Row(){
        Image($r('app.media.ease_chat_takepic_pressed'))
          .width(20)
          .height(20)
        Text("相机")
          .margin({top:10})

      }
      .onClick(async ()=>{this.camera()})

      Text("视频")
        .margin({top:10})
        .onClick(async ()=>{ this.video()})
      Button('关闭')
        .width(200)
        .margin({bottom:15,top:10})
    }
    .width('100%')

  }

  private async photo(){
    //检查是否有读写外部媒体权限
    let res: boolean = await checkAppPermission(this.context)
    //无权限返回
    if (!res) return
    //从相册选择
    let PhotoSelectOptions = new picker.PhotoSelectOptions();
    PhotoSelectOptions.MIMEType = picker.PhotoViewMIMETypes.IMAGE_TYPE;
    PhotoSelectOptions.maxSelectNumber = 1;
    let photoPicker = new picker.PhotoViewPicker();
    photoPicker.select(PhotoSelectOptions).then(async (PhotoSelectResult) => {
      if (PhotoSelectResult.photoUris.length) {
        //复制图片到缓存目录（缓存目录才有读写权限）
        let filePath = PhotoSelectResult.photoUris[0]
        if (filePath) {
          SendMessages.sendImageMessage(this.conversationId+"", filePath).then((value)=>{
            this.changeMessage(value)
          })


        }
      }
    })
  }
  private async camera(){
    //检查是否有读写外部媒体权限
    let res: boolean = await checkAppPermission(this.context)
    //无权限返回
    if (!res) return
    try {
      let pickerProfile: camerapicker.PickerProfile = {
        cameraPosition: camera.CameraPosition.CAMERA_POSITION_BACK
      };
      let pickerResult: camerapicker.PickerResult = await camerapicker.pick(this.context,
        [camerapicker.PickerMediaType.PHOTO, camerapicker.PickerMediaType.PHOTO], pickerProfile);
      if(pickerResult?.resultUri){


      }
    } catch (error) {
      let err = error as BusinessError;
      console.error(`the pick call failed. error code: ${err.code}`);
    }
  }
  private async video(){
    console.log(this.conversationId+"------")
    //检查是否有读写外部媒体权限
    let res: boolean = await checkAppPermission(this.context)
    //无权限返回
    if (!res) return
    //从相册选择
    let PhotoSelectOptions = new picker.PhotoSelectOptions();
    PhotoSelectOptions.MIMEType = picker.PhotoViewMIMETypes.VIDEO_TYPE;
    PhotoSelectOptions.maxSelectNumber = 1;
    let photoPicker = new picker.PhotoViewPicker();
    photoPicker.select(PhotoSelectOptions).then(async (PhotoSelectResult) => {
      if (PhotoSelectResult.photoUris.length) {
        //复制图片到缓存目录（缓存目录才有读写权限）
        let filePath = PhotoSelectResult.photoUris[0]
        if (filePath) {


          SendMessages.sendVideoMessage(this.conversationId+"", filePath,this.context).then((value)=>{
            // this.changeMessage(value)
          })
          console.log("PhotoSelectOptions",filePath)



        }
      }
    })
  }
}
