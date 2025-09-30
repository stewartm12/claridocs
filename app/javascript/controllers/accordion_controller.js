import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="accordion"
export default class extends Controller {
  static targets = ["content", "icon", "button"]

  toggle(event) {
    const clickedButton = event.currentTarget
    const clickedIndex = parseInt(clickedButton.dataset.index)
    
    // Get the specific content and icon for the clicked accordion
    const content = this.contentTargets[clickedIndex]
    const icon = this.iconTargets[clickedIndex]
    
    // Toggle the clicked accordion only
    const isOpen = content.style.maxHeight && content.style.maxHeight !== "0px"
    
    if (isOpen) {
      content.style.maxHeight = "0px"
      icon.classList.remove('rotate-90')
    } else {
      content.style.maxHeight = content.scrollHeight + "px"

      icon.classList.add('rotate-90')
    }
  }
}
