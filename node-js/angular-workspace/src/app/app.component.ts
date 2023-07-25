import { ipcRenderer } from 'electron';
import { Component } from '@angular/core';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss'],
})
export class AppComponent {
  title = 'angular-workspace';

  constructor() {}

  ngAfterViewInit() {}
}
