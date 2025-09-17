import { Controller } from "@hotwired/stimulus"
import { useClickOutside } from 'stimulus-use';

// Connects to data-controller="navbar"
export default class extends Controller {
  static targets = ['content']

  connect() {
    useClickOutside(this, { element: this.contentTarget });
    this.close();
  }

  clickOutside(event) {
    if (event?.target.id === 'navbar-opener') return;

    this.close();
  }

  closeWithKeyboard(event) {
    if (event.key === 'Escape') this.close();
  }

  closeOnBigScreen(event) {
    if (window.innerWidth > 768) {
      this.close();
    }
  }

  toggle(event) {
    if (this.contentTarget.classList.contains('-translate-x-full')) {
      this.open();
    } else {
      this.close();
    }
  }

  open() {
    const burgerElement = document.getElementById('navbar-opener');
    burgerElement.classList.add('hidden');
    this.contentTarget.classList.remove('-translate-x-full');
    let main = document.querySelector('main');
    main.classList.add('brightness-75');
    document.body.classList.add('overflow-hidden');
  }

  close() {
    const burgerElement = document.getElementById('navbar-opener');
    burgerElement.classList.remove('hidden');
    this.contentTarget.classList.add('-translate-x-full');
    let main = document.querySelector('main');
    main.classList.remove('brightness-75');
    document.body.classList.remove('overflow-hidden');
  }
}
