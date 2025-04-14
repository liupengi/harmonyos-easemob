import relationalStore from '@ohos.data.relationalStore';
import { Context } from '@ohos.arkui.UIContext';
import UserInfo from '../utils/UserInfo';
import { ValuesBucket } from '@ohos.data.ValuesBucket';
import { ChatLog} from '@easemob/chatuikit'
class UserInfoModel{
  private rdbStore : relationalStore.RdbStore | undefined = undefined;
  private tableName: string = ''

  /*
   * 初始化数据库
   *
   * */
  initUserInfoDB(context:Context,tableName:string){
    this.tableName = tableName
    // 1、 rdb 配置
    const config: relationalStore.StoreConfig = {
      name :"EaseMobUserInfo.db",// 数据库文件名
      securityLevel: relationalStore.SecurityLevel.S1 // 数据库安全级别
    }
    // 2、初始化 SQL 语句
    const sql = `CREATE TABLE IF NOT EXISTS ${this.tableName} (
              ID INTEGER PRIMARY KEY AUTOINCREMENT,
              USERID TEXT NOT NULL,
              NICKNAME TEXT NOT NULL,
              AVATARURL TEXT NOT NULL
            )`

    // 3、获取rdb
    relationalStore.getRdbStore(context,config,(err,rdbStore) =>{
      if (err) {
        console.log("UserInfoModel",'获取RdbStore失败')
        return
      }
      // 执行sql 语句
      rdbStore.executeSql(sql)
      console.log("UserInfoModel",'创建UserInfoModel成功')
      // 保存rdbStore
      this.rdbStore = rdbStore
    })
  }

  /*
   * 查询
   * */
    async getUserInfo(userid :string) : Promise<UserInfo|null>{
    let predicates = new relationalStore.RdbPredicates(this.tableName)
      predicates.equalTo("USERID",userid)
    try {
      // 使用 await 等待查询结果
      const resultSet = await this.rdbStore?.query(predicates, ['USERID', 'NICKNAME', 'AVATARURL']);

      if (!resultSet) {
        ChatLog.d("UserInfoModel: resultSet is null or undefined");
        return null;
      }

      ChatLog.d("UserInfoModel resultSet rowCount:" + resultSet.rowCount);

      // 检查是否有数据
      if (resultSet.rowCount === 0) {
        ChatLog.d("UserInfoModel: No rows found");
        return null;
      }

      // 3.3 指针移动到下一行
      if (resultSet.goToNextRow()) {
        // 根据字段名获取字段index，从而获取字段值
        const getUserid: string = resultSet.getString(resultSet.getColumnIndex("USERID")) || "";
        const getNickname: string = resultSet.getString(resultSet.getColumnIndex("NICKNAME")) || "";
        const getAvatarurl: string = resultSet.getString(resultSet.getColumnIndex("AVATARURL")) || "";

        //ChatLog.d("UserInfoModel-----getUserInfo " + getUserid + "---" + getNickname + "---" + getAvatarurl);

        // 创建并返回 UserInfo 对象
        const userInfo: UserInfo = new UserInfo(getUserid, getNickname, getAvatarurl);
        return userInfo;
      } else {
        ChatLog.d("UserInfoModel: Failed to move to the next row");
        return null;
      }
    } catch (error) {

      return null;
    }


  }




  /*
   * 新增
   * */
  async addUserInfo(userid :string,nickname :string,avatarurl :string){
    let predicates = new relationalStore.RdbPredicates(this.tableName)

    predicates.equalTo("USERID",userid)

    await this.rdbStore?.query(predicates, ['USERID', 'NICKNAME', 'AVATARURL']).then((resultSet)=>{
      console.debug("UserInfoModel" ,"resultSet columnCount:" + resultSet.rowCount);
      if (resultSet.rowCount === 0) {
        //如果查询到为0说明没有该数据，插入数据
        this.rdbStore?.insert(this.tableName,{userid,nickname,avatarurl})
        console.debug("UserInfoModel","添加数据成功")
      }else {
        //3.3  指针移动到下一行
        resultSet?.goToNextRow()
        // 根据字段名获取字段index，从而获取字段值
        let getUserid :string = resultSet?.getString(resultSet.getColumnIndex("USERID")) as string
        let getNickname :string = resultSet?.getString(resultSet.getColumnIndex("NICKNAME"))as string
        let getAvatarurl :string= resultSet?.getString(resultSet.getColumnIndex("AVATARURL"))as string
        console.log("UserInfoModel","数据库中已经存在该数据，请检查是否需要更新数据")
        console.log("UserInfoModel",getUserid+"---"+getNickname+"---"+getAvatarurl)
        if (nickname != getNickname || avatarurl != getAvatarurl) {
          this.updateUserInfo(userid,nickname,avatarurl)
          console.log("UserInfoModel","数据不相同已经更新数据")
        }else {
          console.log("UserInfoModel","数据相同，跳过更新")
        }
      }
    });




  }

  /*
   * 数据更新
   * */
  updateUserInfo(userid :string,nickname :string,avatarurl :string){
    // 更新的数据
    let date :ValuesBucket = {userid,nickname,avatarurl}

    // 更新的条件
    let predicates = new relationalStore.RdbPredicates(this.tableName)
    predicates.equalTo('USERID',userid)
    // 更新操作
    return this.rdbStore?.update( date ,predicates)
  }

  /*
   * 删除
   * */
  deleteUserInfo(userid :string,nickname :string,avatarurl :string){
    //删除的条件
    let predicates = new relationalStore.RdbPredicates(this.tableName)
    predicates.equalTo('USERID',userid)
    // 删除操作
    return this.rdbStore?.delete(predicates)
  }

}

let userInfoModel = new UserInfoModel()
export default userInfoModel as UserInfoModel