import {ChatClient, ChatError, ChatLog, ChatOptions} from "@easemob/chatsdk";
import router from '@ohos.router';
import dataPreference from '@ohos.data.preferences'
import { EventBus } from '../utils/EventBus';
import EaseConstant from '../utils/EaseConstant';

@Component
export struct LoginComponent {
  @Prop context :Context
  @StorageProp('isMinHeight') isMinHeight: boolean = false;
  @State userName: string = '';
  @State password: string = '';
  build() {
    Column(){
      Column() {
        TextInput({ placeholder: $r('app.string.username') })
          .width('100%')
          .height($r('app.float.text_input_height'))
          .placeholderColor($r('app.color.text_input_place_holder'))
          .placeholderFont({ size: $r('app.float.text_input_font_size') })
          .backgroundColor($r('app.color.login_input_text_background'))
          .fontSize($r('app.float.text_input_font_size'))
          .padding({ left: $r('app.float.username_padding_left') })
          .border({
            width: { bottom: $r('app.float.input_border_width') },
            color: $r('app.color.input_border_color'),
            radius: $r('app.float.input_border_radius')
          })
          .onChange((value: string) => {
            this.userName = value;
          })

        TextInput({ placeholder: $r('app.string.password') })
          .width('100%')
          .height($r('app.float.text_input_height'))
          .placeholderColor($r('app.color.text_input_place_holder'))
          .placeholderFont({ size: $r('app.float.text_input_font_size') })
          .fontSize($r('app.float.text_input_font_size'))
          .backgroundColor($r('app.color.login_input_text_background'))
          .type(InputType.Password)
          .padding({ left: $r('app.float.password_padding_left') })
          .border({
            width: { bottom: $r('app.float.input_border_width') },
            color: $r('app.color.input_border_color'),
            radius: $r('app.float.input_border_radius')
          })
          .margin({ bottom: $r('app.float.input_margin_bottom') })
          .onChange((value: string) => {
            this.password = value;
          })
      }

      Button($r('app.string.login'))
        .width('100%')
        .height($r('app.float.login_btn_height'))
        .borderRadius($r('app.float.login_btn_border_radius'))
        .fontSize($r('app.float.text_input_font_size'))
        .margin({ top: $r('app.float.register_btn_margin_top') })
        .fontWeight(500)
        .enabled(isLoginButtonClickable(this.userName, this.password))
        .fontColor(isLoginButtonClickable(this.userName, this.password) ?
        Color.White : $r('app.color.login_font_normal'))
        .backgroundColor(isLoginButtonClickable(this.userName, this.password) ?
        $r('app.color.login_btn_enabled') : $r('app.color.login_btn_normal'))
        .onClick(() => {

            ChatClient.getInstance().login(this.userName,this.password).then(()=>{
              router.replaceUrl({
                url:"pages/MainPage",
              })



              dataPreference.getPreferences(getContext(),'easemob')
                .then( preferences=>{
                  {
                    preferences.put("isAutoLogin", true).then(()=>{
                      preferences.flush()
                    })

                  }

                }).catch( () =>{

              })



            }).catch((s:ChatError)=>{
              ChatLog.d('登录失败'+s.errorCode+"----"+s.description);
              AlertDialog.show(
                {
                  title: '提示', //弹窗标题
                  message: '登录失败'+s.errorCode+":"+s.description, //弹窗信息
                  autoCancel: true, //点击遮障层时，是否关闭弹窗
                  alignment: DialogAlignment.Center, //弹窗位置
                  offset: { dx: 0, dy: -20 }, //相对于弹窗位置的偏移量
                  secondaryButton: {
                    value: '退出重新登录',
                    action: () => {
                      if (s.errorCode== 200) {
                        ChatClient.getInstance().logout().then(()=>{
                          dataPreference.getPreferences(getContext(),'easemob')
                            .then( preferences=>{
                              {
                                preferences.delete("isAutoLogin")

                              }

                            }).catch( () =>{

                          })
                        });

                      }
                      console.log('取消删除')
                    }
                  },
                  cancel: () => { //点击遮罩层取消时的回调
                    console.info('Closed callbacks')
                  }
                }
              )

            });

        })

      Button($r('app.string.register'))
        .width('100%')
        .height($r('app.float.login_btn_height'))
        .fontSize($r('app.float.text_input_font_size'))
        .fontWeight(500)
        .borderRadius($r('app.float.register_btn_border_radius'))
        .margin({ top: $r('app.float.register_btn_margin_top') })
        .fontColor($r('app.color.register_font_clickable'))
        .backgroundColor($r('app.color.register_btn_clickable'))
        .onClick(() => {
          ChatClient.getInstance().createAccount("userId", "pwd").then(()=> {
            // success
          }).catch((e:ChatError)=>{
            // error
          });
        })
    }

  }
}
function isLoginButtonClickable(userName: string, password: string): boolean {
  return userName !== '' && password !== '';
}

