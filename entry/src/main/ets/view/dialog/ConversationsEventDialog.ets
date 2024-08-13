import { common } from '@kit.AbilityKit';
import { ChatClient, ChatError, ChatMessage, } from 'easemob'
import EaseConstant from '../../utils/EaseConstant';
import { EventBus } from '../../utils/EventBus';

//全局公共样式
@Styles
function fillScreen() {
  .width('100%')
  .padding({top:20,bottom:20})
}

@CustomDialog
@Component
export struct ConversationsEventDialog {


  @Prop conversationId: ResourceStr
  @Prop imgMsg: ChatMessage|undefined = undefined
  isClose = (isClose: boolean)=> {

  }
  controller: CustomDialogController = new CustomDialogController({
    builder: ConversationsEventDialog({

    })
  })

  private context = getContext(this) as common.UIAbilityContext; //UIAbilityContext
  build() {
    Column() {
      Row(){

        Text("免打扰")
          .fontColor('#33b1ff')

      }
      .fillScreen()
      .justifyContent(FlexAlign.Center)
      .onClick( ()=>{

      })
      Row(){}.width('100%').backgroundColor("#e7e9eb").height(1)
      Row(){

        Text("置顶")
          .fontColor('#33b1ff')

      }
      .fillScreen()
      .justifyContent(FlexAlign.Center)
      .onClick( () =>{
        ChatClient.getInstance().chatManager()?.pinConversation(this.conversationId+"", true).then(()=> {
          // success logic
          this.controller.close()
        }).catch((e: ChatError) => {
          // failed logic

        });


      })
      Row(){}.width('100%').backgroundColor("#e7e9eb").height(1)
      Row(){
        Text("删除")
          .fontColor(Color.Red)
      }
      .fillScreen()
      .justifyContent(FlexAlign.Center)
      .onClick(()=>{
        ChatClient.getInstance().chatManager()?.deleteConversation(this.conversationId+"",true)
        EventBus.send(EaseConstant.connected_change)
        this.controller.close()
      })
      Row(){}.width('100%').backgroundColor("#e7e9eb").height(7)
      Row(){
        Text("取消")
          .fontColor('#33b1ff')
      }
      .fillScreen()
      .justifyContent(FlexAlign.Center)
      .onClick(()=>{
        this.controller.close()
      })

    }


  }

}
