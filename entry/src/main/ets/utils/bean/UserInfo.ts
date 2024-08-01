export default  class  UserInfo{
  userid :string
  nickname:string
  avatarurl:string

  constructor(userid:string,avatarurl:string,nickname:string) {
    this.userid = userid
    this.avatarurl = avatarurl
    this.nickname = nickname

  }
}