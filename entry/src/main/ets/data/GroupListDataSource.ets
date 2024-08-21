import { Group } from 'easemob';
import {BasicDataSource} from '../base/BasicDataSource'
export  class GroupListDataSource extends BasicDataSource {
  private dataArray: Group[] = [];

  public totalCount(): number {
    return this.dataArray.length;
  }

  public getData(index: number): Group {
    return this.dataArray[index];
  }

  public addData(index: number, data: Group): void {
    this.dataArray.splice(index, 0, data);
    this.notifyDataAdd(index);
  }

  public pushData(data: Group): void {
    this.dataArray.push(data);
    this.notifyDataAdd(this.dataArray.length - 1);
  }
}