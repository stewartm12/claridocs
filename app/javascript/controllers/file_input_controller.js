import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="file-input"
export default class extends Controller {
  static targets = ["input", "output"]

  update() {
    const file = this.inputTarget.files[0]
    this.outputTarget.textContent = file ? file.name : "No file selected"
  }
}
