import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  
  initialize() {

  }

  connect() {
    var el = this.element.querySelector('.sidenav');
    this.instance = M.Sidenav.init(el, {});
    //$('.sidenav').sidenav();    
  }

  checkOpen(){
    setTimeout(this.checkOpenAfterLoad.bind(null, this), 0);
  }

  checkOpenAfterLoad(self){
    if(!self.instance.isOpen){
      self.instance.open();
    }
  }

  disconnect() {
    this.instance = null;
  }
}