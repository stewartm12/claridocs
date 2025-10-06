import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results"]
  static values = { 
    open: { type: Boolean, default: false }
  }

  connect() {
    this.boundClickOutside = this.clickOutside.bind(this)
  }

  disconnect() {
    this.removeClickOutsideListener()
  }

  show() {
    if (this.hasResultsTarget && this.resultsTarget.innerHTML.trim() !== "") {
      this.openValue = true
      this.resultsTarget.classList.remove("hidden")
      this.addClickOutsideListener()
    }
  }

  hide() {
    if (this.hasResultsTarget) {
      this.openValue = false
      this.resultsTarget.classList.add("hidden")
      this.removeClickOutsideListener()
    }
  }

  clear() {
    if (this.hasResultsTarget) {
      this.resultsTarget.innerHTML = ""
      this.hide()
    }
  }

  handleInput(event) {
    const query = event.target.value.trim()
    
    // If search is empty, clear and hide results
    if (query === "") {
      this.clear()
      return
    }
  }

  handleFocus() {
    // Only show if there's content in the input and results exist
    if (this.hasInputTarget && this.inputTarget.value.trim() !== "" && 
        this.hasResultsTarget && this.resultsTarget.innerHTML.trim() !== "") {
      this.show()
    }
  }

  clickOutside(event) {
    const isInsideDesktopResults = event.target.closest('#search_results')
    const isInsideMobileResults = event.target.closest('#mobile_search_results')
      
    if (isInsideDesktopResults || isInsideMobileResults) return

    // Don't hide if clicking inside the search component
    if (this.element.contains(event.target)) {
      return
    }
    
    // Clicking outside - hide the results
    this.hide()
  }

  addClickOutsideListener() {
    // Small delay to prevent immediate triggering
    setTimeout(() => {
      document.addEventListener("click", this.boundClickOutside, true)
    }, 100)
  }

  removeClickOutsideListener() {
    document.removeEventListener("click", this.boundClickOutside, true)
  }

  // Called after turbo stream updates the results
  resultsUpdated() {
    // Show results after they're loaded (if input has value)
    if (this.hasInputTarget && this.inputTarget.value.trim() !== "") {
      // Use a small delay to ensure DOM is fully updated
      setTimeout(() => {
        this.show()
      }, 50)
    }
  }
}