import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="flash-message"
export default class extends Controller {
  static targets = ["bar"]

  connect() {
    this.totalTime = 8
    this.elapsed = 0
    this.startTime = performance.now()
    this.running = true

    this.animate()

    // Trigger the slide-in
    this.element.classList.add("opacity-0", "-translate-y-4")
    requestAnimationFrame(() => {
      this.element.classList.remove("opacity-0", "-translate-y-4")
      this.element.classList.add("opacity-100", "translate-y-0")
    })

    this.timeout = setTimeout(() => this.dismiss(), this.totalTime * 1000)

    this.element.addEventListener("mouseenter", this.pause)
    this.element.addEventListener("mouseleave", this.resume)
  }

  animate = () => {
    if (!this.running) return

    const now = performance.now()
    this.elapsed = (now - this.startTime) / 1000
    const timeLeft = Math.max(this.totalTime - this.elapsed, 0)
    const percentage = (timeLeft / this.totalTime) * 100

    this.barTarget.style.width = `${percentage}%`

    if (timeLeft > 0) {
      requestAnimationFrame(this.animate)
    }
  }

  pause = () => {
    this.running = false
    clearTimeout(this.timeout)
  }

  resume = () => {
    this.running = true
    this.startTime = performance.now() - this.elapsed * 1000
    this.animate()
    const timeLeft = this.totalTime - this.elapsed
    this.timeout = setTimeout(() => this.dismiss(), timeLeft * 1000)
  }

  dismiss() {
    this.element.classList.remove("opacity-100", "translate-y-0")
    this.element.classList.add("opacity-0", "-translate-y-4")

    setTimeout(() => this.element.remove(), 500) }
};
