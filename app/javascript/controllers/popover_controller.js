import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="popover"
export default class extends Controller {
  static targets = ["menu"]

  toggle() {
    this.menuTarget.classList.toggle("hidden")
  }

  // Optional: close menu if clicked outside
  connect() {
    document.addEventListener("click", this.closeOutside.bind(this))
  }

  disconnect() {
    document.removeEventListener("click", this.closeOutside.bind(this))
  }

  closeOutside(event) {
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.add("hidden")
    }
  }
}
