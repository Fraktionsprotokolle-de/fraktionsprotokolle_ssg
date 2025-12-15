class CustomCheckbox extends HTMLElement {
  constructor() {
    super();
    this.attachShadow({ mode: "open" });
  }

  static get observedAttributes() {
    return ["color", "text-value", "key"];
  }

  connectedCallback() {
    // Only render if shadow DOM is empty (first time connection)
    // This prevents re-rendering when element is moved in DOM
    if (!this.shadowRoot.querySelector('.checkbox-container')) {
      this.render();
      this.setupEventListeners();
    }
  }

  attributeChangedCallback(name, oldValue, newValue) {
    if (this.shadowRoot) {
      this.updateStyle();
      this.updateTextValue();
    }
  }

  render() {
    this.shadowRoot.innerHTML = `
          <style>
           :host {
  display: block;
  width: 100%;
}
.checkbox-container {
  display: flex;
  align-items: center;
  cursor: pointer;
  padding: 2px;
  width: 100%; /* Container stretches as needed */
}
.checkbox {

  font-size: 1rem;
  border: 2px solid #333;
  border-radius: 3px;
  margin-right: 8px;
  display: flex;
  justify-content: center;
  align-items: center;
  font-weight: bold;
  font-size: 12px;
  color: #333;
  transition: background-color 0.3s ease;
  flex-shrink: 0;
  line-height: 1.15;
}
.checkbox:focus {
  /*outline: 2px solid blue;*/
  /*outline-offset: 2px;*/
}
.checkbox[aria-checked="true"]::after {
  content: "✓";
  color: white;
}
::slotted(*) {
  flex: 1;
  text-align: right;
}
.text-value {
  /* Push text to the far end/right */
  font-size: 14px;
  margin-left: 0;
  text-align: right;
}

          </style>
          <label class="checkbox-container">
            <input type="checkbox" class="checkbox" aria-checked="false" />
            <slot></slot>
            <span class="text-value d-flex px-2 align-items-center mb-1 me-4 text-black"></span>
          </label>
        `;

    this.updateStyle();
    this.updateTextValue();
  }

  setupEventListeners() {
    this.checkboxSpan.addEventListener("click", () => this.toggle());
    this.checkboxSpan.addEventListener("keydown", (e) => {
      if (e.key === " " || e.key === "Enter") {
        e.preventDefault();
        this.toggle();
      }
    });
  }

  toggle() {
    const isChecked = this.checkboxSpan.getAttribute("aria-checked") === "true";
    this.checkboxSpan.setAttribute("aria-checked", !isChecked);
    const key = this.getAttribute("key");
    this.updateStyle();

    this.dispatchEvent(
      new CustomEvent("custom-checkbox-change", {
        bubbles: true,
        composed: true,
        detail: { checked: !isChecked, key: key },
      }),
    );

    this.dispatchEvent(
      new CustomEvent("change", {
        bubbles: true,
        composed: true,
        detail: { checked: !isChecked },
      }),
    );
  }

  updateStyle() {
    const color = this.getAttribute("color") || "#e0e0e0";
    this.checkboxSpan = this.shadowRoot.querySelector("input.checkbox");
    var isChecked;
    if (this.checkboxSpan) {
      isChecked = this.checkboxSpan.getAttribute("aria-checked") === "true";
      this.checkboxSpan.style.backgroundColor = isChecked
        ? color
        : "transparent";
    } else {
      isChecked = false;
    }
  }

  updateTextValue() {
    this.textValueSpan = this.shadowRoot.querySelector(".text-value");
    if (this.textValueSpan) {
      const textValue = this.getAttribute("text-value") || "";
      this.textValueSpan.textContent = textValue;
    }
  }
}

customElements.define("custom-checkbox", CustomCheckbox);
