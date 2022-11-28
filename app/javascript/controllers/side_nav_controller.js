import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  
  initialize() {

  }

  connect() {
    var el = this.element.querySelector('.sidenav');
    var instances = M.Sidenav.init(el, {});
    //$('.sidenav').sidenav();    
  }

  disconnect() {

  }
}