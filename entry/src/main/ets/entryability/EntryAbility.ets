import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { router, window } from '@kit.ArkUI';
import ChatPresenter from '../presenter/ChatPresenter';
import { ChatLog, ChatOptions } from '@easemob/chatsdk';
import { ChatClient } from '@easemob/chatsdk';

export default class EntryAbility extends UIAbility {

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
    let chatOption :ChatOptions = new ChatOptions("1137220225110285#demo");
    chatOption.setAutoLogin(true);
    chatOption.setAutoDownloadThumbnail(true)
    chatOption.setAppIDForPush("111703463")

    //自定义设备类型
    // chatOption.setCustomOSPlatform(1)
    // chatOption.setCustomDeviceName("zidngyide1")

    // 私有化配置
    // chatOption.setRestServer("http://a1.easemob.com")
    // chatOption.setIMServer("60.205.128.208")
    // chatOption.setImPort(6717)
    ChatClient.getInstance().init(this.context,chatOption);

    let isSdkInited = ChatClient.getInstance().isSdkInited();
    ChatLog.d(`isSdkInited${isSdkInited}`);

    ChatPresenter.ChatPresenter();

  }




  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {

    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');

    });

  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground

    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    //点击Notification通知并打开App的具体页面
    let page = want?.parameters?.page  as string
    router.pushUrl({
      url:"pages/MainPage"
    })
    console.log('want参数'+want?.parameters?.page)


  }
}
