import { common } from '@kit.AbilityKit';
import { ChatClient, ChatError, ChatMessage, } from '@easemob/chatsdk'
import EaseConstant from '../../utils/EaseConstant';
import { EventBus } from '../../utils/EventBus';

//全局公共样式
@Styles
function fillScreen() {
  .width('100%')
  .padding({ top: 20, bottom: 20 })
}

@CustomDialog
@Component
export struct AddContactDialog {
  @Prop conversationId: ResourceStr
  @Prop imgMsg: ChatMessage | undefined = undefined
  isClose = (isClose: boolean) => {

  }
  controller: CustomDialogController = new CustomDialogController({
    builder: AddContactDialog({})
  })
  private context = getContext(this) as common.UIAbilityContext; //UIAbilityContext

  build() {
    Column() {

      Text("添加联系人")
        .fontWeight(FontWeight.Bold)
        .fontSize(20)
        .margin({top:20,bottom:20})
      TextInput({})
        .width(300)
        .margin({ left: 5, right: 5 })
        .onChange((value: string) => {

        })
      Row(){
        Button('取消')
        Button('确认')
          .onClick(()=>{
            ChatClient.getInstance().contactManager()?.addContact("lp1", "加个好友呗").then(()=>{

            }).catch((error:ChatError)=>{

            })
          })
      }
      .width('100%')
      .margin({bottom:20,top:20})
      .justifyContent(FlexAlign.SpaceAround)

    }

  }
}
