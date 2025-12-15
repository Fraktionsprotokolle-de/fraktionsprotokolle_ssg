var targetDiv = document.getElementById("sitzungsverlauf");
var copyfrom = document.getElementById("svplist");
var hamburgerMenu = document.getElementById("hamburger-menu");
var copyto = document.getElementById("menu-items");
if (copyfrom && copyto) {
  copyto.innerHTML = copyfrom.innerHTML;
}

var isMenuOpen = false;
var userClosedMenu = false; // Track if user manually closed the menu
var lastScrollY = window.scrollY;
var scrollingUp = false;

function toggleHamburgerMenu() {
  if (!targetDiv || !hamburgerMenu) return;

  const rect = targetDiv.getBoundingClientRect();
  const currentScrollY = window.scrollY;

  // Detect scroll direction
  scrollingUp = currentScrollY < lastScrollY;
  lastScrollY = currentScrollY;

  if (rect.bottom <= 0) {
    // Scrolled past the section - show hamburger menu
    hamburgerMenu.classList.remove("hidden");

    // Hide menu when scrolling up
    if (scrollingUp) {
      hamburgerMenu.classList.remove("force-show");
      hamburgerMenu.classList.remove("menu-open");
      isMenuOpen = false;
      userClosedMenu = true; // Prevent auto-showing until user scrolls down again
    } else {
      // Only auto-show if user hasn't manually closed it and scrolling down
      if (!userClosedMenu) {
        hamburgerMenu.classList.add("force-show");
        hamburgerMenu.classList.add("menu-open"); // Add menu-open for icon rotation
        isMenuOpen = true; // Menu is showing, so set state to open
      }
    }
  } else {
    // Above the section - hide hamburger menu
    hamburgerMenu.classList.add("hidden");
    // Close menu and reset state when scrolling back up
    hamburgerMenu.classList.remove("force-show");
    hamburgerMenu.classList.remove("menu-open");
    isMenuOpen = false;
    userClosedMenu = false; // Reset when scrolling back up
  }
}

// Toggle menu on hamburger icon click
var hamburgerIcon = document.querySelector("#hamburger-menu .hamburger-icon");
if (hamburgerIcon && hamburgerMenu) {
  hamburgerIcon.addEventListener("click", function(e) {
    e.stopPropagation();

    // Check if menu is currently showing (either from scroll or manual open)
    const menuIsShowing = hamburgerMenu.classList.contains("force-show");

    if (menuIsShowing) {
      // Close the menu
      hamburgerMenu.classList.remove("force-show");
      hamburgerMenu.classList.remove("menu-open");
      isMenuOpen = false;
      userClosedMenu = true; // User manually closed the menu
    } else {
      // Open the menu
      hamburgerMenu.classList.add("force-show");
      hamburgerMenu.classList.add("menu-open");
      isMenuOpen = true;
      userClosedMenu = false; // User manually opened the menu
    }
  });
}

// Close menu when clicking outside
document.addEventListener("click", function(e) {
  if (isMenuOpen && hamburgerMenu && !hamburgerMenu.contains(e.target)) {
    hamburgerMenu.classList.remove("force-show");
    hamburgerMenu.classList.remove("menu-open");
    isMenuOpen = false;
    userClosedMenu = true; // User manually closed by clicking outside
  }
});

if (targetDiv) {
  window.addEventListener("scroll", toggleHamburgerMenu);
}

// Get the query parameter "q" from the URL
var urlParams = new URLSearchParams(window.location.search);
var q = urlParams.get("q");

// Function to highlight text within text nodes and insert the span as HTML
function highlightTextInNode(node) {
    if (node.nodeType === Node.TEXT_NODE) {
        // Skip if parent already has highlight class (avoid duplicate processing)
        if (node.parentNode && node.parentNode.classList && node.parentNode.classList.contains('highlight')) {
            return;
        }

        // Escape special regex characters in the search term
        const escapedQ = q.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
        const regex = new RegExp(escapedQ, "gi");
        const text = node.textContent;

        // Check if there's a match
        if (!regex.test(text)) {
            return;
        }

        // Reset regex since test() moves the lastIndex
        regex.lastIndex = 0;

        const parentNode = node.parentNode;
        const fragment = document.createDocumentFragment();
        let lastIndex = 0;
        let match;

        // Split text and wrap matches in highlight spans
        while ((match = regex.exec(text)) !== null) {
            // Add text before match
            if (match.index > lastIndex) {
                fragment.appendChild(document.createTextNode(text.substring(lastIndex, match.index)));
            }

            // Add highlighted match
            const highlight = document.createElement('span');
            highlight.className = 'highlight';
            highlight.textContent = match[0];
            fragment.appendChild(highlight);

            lastIndex = regex.lastIndex;
        }

        // Add remaining text after last match
        if (lastIndex < text.length) {
            fragment.appendChild(document.createTextNode(text.substring(lastIndex)));
        }

        // Replace the text node with the fragment
        parentNode.replaceChild(fragment, node);
    } else if (node.nodeType === Node.ELEMENT_NODE) {
        // Skip if already processed
        if (node.classList && node.classList.contains('highlight')) {
            return;
        }
        // Recursively process child nodes of elements
        Array.from(node.childNodes).forEach(highlightTextInNode);
    }
}

// Function to recursively highlight text inside shadow DOMs
function highlightInShadowRoot(shadowRoot) {
    // Add highlight styles to shadow DOM (needed because of style encapsulation)
    let styleEl = shadowRoot.querySelector('style.highlight-styles');
    if (!styleEl) {
        styleEl = document.createElement('style');
        styleEl.className = 'highlight-styles';
        styleEl.textContent = '.highlight { background-color: rgb(246, 166, 35); }';
        shadowRoot.appendChild(styleEl);
    }

    // Process all text-containing elements in shadow DOM (not just <p> tags)
    const textContainers = shadowRoot.querySelectorAll("span, p, div, a, td, th, li");
    textContainers.forEach(el => {
        highlightTextInNode(el);  // Process the element and all its descendants recursively
    });

    // If no specific text containers found, process the shadow root's body directly
    if (textContainers.length === 0 && shadowRoot.children.length > 0) {
        Array.from(shadowRoot.children).forEach(child => {
            if (child.nodeType === Node.ELEMENT_NODE) {
                highlightTextInNode(child);
            }
        });
    }

    // Recurse into nested shadow roots
    shadowRoot.querySelectorAll("*").forEach(el => {
        if (el.shadowRoot) {
            highlightInShadowRoot(el.shadowRoot);
        }
    });
}

// Function to search and highlight in all p tags (and text nodes) in the light DOM
function highlightInLightDOM() {
    document.querySelectorAll("p").forEach(p => {
        highlightTextInNode(p);  // Process the paragraph and all its descendants recursively
    });

    // Highlight in shadow DOMs (like popup-info elements)
    document.querySelectorAll("popup-info, custom-checkbox, *").forEach(el => {
        if (el.shadowRoot) {
            highlightInShadowRoot(el.shadowRoot);  // Recurse into shadow roots
        }
    });
}

// Initialize the highlighting in the light DOM only if there's a query parameter
if (q && q.trim() !== "") {
    // Wait for custom elements to be fully initialized before highlighting
    const runHighlighting = () => {
        // Use requestAnimationFrame to wait for the next render cycle
        requestAnimationFrame(() => {
            requestAnimationFrame(() => {
                highlightInLightDOM();
            });
        });
    };

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', runHighlighting);
    } else {
        runHighlighting();
    }
}



var currentMatchIndex = -1;
var matches = [];

// Store original positions of list items
var listItemOriginalPositions = new Map();

function highlightMatches(key) {
  // Reset previous highlights and matches
  // document.querySelectorAll(".highlight").forEach((el) => {
  // el.classList.remove("highlight");
  // el.removeAttribute("tabindex");
  //});
  matches.length = 0;
  currentMatchIndex = -1;

  // Find and highlight new matches
  document.querySelectorAll(`[id="#${key}"]`).forEach((el) => {
    el.classList.add("highlight");
    el.setAttribute("tabindex", "0");
    el.setAttribute("aria-label", `Match ${matches.length + 1} for ${key}`);
    matches.push(el);
  });

  // Set focus to the first match
  if (matches.length > 0) {
    currentMatchIndex = 0;
    matches[0].focus();
  }
}

function bubbleListItem(listItem, isChecked) {
  const ul = listItem.parentElement;
  const checkbox = listItem.querySelector('custom-checkbox');

  // Preserve the checked state before moving
  const checkboxSpan = checkbox ? checkbox.shadowRoot.querySelector("input.checkbox") : null;
  const currentCheckedState = checkboxSpan ? checkboxSpan.getAttribute("aria-checked") : "false";

  if (isChecked) {
    // Store original position if not already stored
    if (!listItemOriginalPositions.has(listItem)) {
      const siblings = Array.from(ul.children);
      const originalIndex = siblings.indexOf(listItem);
      listItemOriginalPositions.set(listItem, {
        index: originalIndex,
        nextSibling: listItem.nextSibling
      });
    }

    // Move to the top
    // Find the first unchecked item or insert at the very beginning
    let insertBefore = null;
    for (let child of ul.children) {
      const cb = child.querySelector('custom-checkbox');
      if (cb) {
        const cbSpan = cb.shadowRoot.querySelector("input.checkbox");
        if (cbSpan && cbSpan.getAttribute("aria-checked") !== "true") {
          insertBefore = child;
          break;
        }
      }
    }

    if (insertBefore) {
      ul.insertBefore(listItem, insertBefore);
    } else {
      ul.appendChild(listItem);
    }
  } else {
    // Return to original position
    const originalPos = listItemOriginalPositions.get(listItem);
    if (originalPos) {
      if (originalPos.nextSibling && originalPos.nextSibling.parentElement === ul) {
        ul.insertBefore(listItem, originalPos.nextSibling);
      } else {
        // If nextSibling doesn't exist, it was the last item
        ul.appendChild(listItem);
      }
      listItemOriginalPositions.delete(listItem);
    }
  }

  // Restore the checked state after moving (connectedCallback resets it)
  // Use requestAnimationFrame to ensure this runs after connectedCallback completes
  if (currentCheckedState === "true") {
    requestAnimationFrame(() => {
      const cbSpan = checkbox ? checkbox.shadowRoot.querySelector("input.checkbox") : null;
      if (cbSpan) {
        cbSpan.setAttribute("aria-checked", "true");
        // Update the visual style
        if (checkbox.updateStyle) {
          checkbox.updateStyle();
        }
      }
    });
  }
}

document.addEventListener("custom-checkbox-change", (e) => {
  const key = e.target.getAttribute("key");
  const checkbox = e.target;

  // Use the event detail which contains the correct checked state
  const isChecked = e.detail.checked;

  // Find the parent li element
  const listItem = checkbox.closest('li');

  if (isChecked) {
    highlightMatches(key);
    // Defer DOM manipulation to let the custom element finish its toggle
    if (listItem) {
      setTimeout(() => bubbleListItem(listItem, true), 0);
    }
  } else {
    document.querySelectorAll(`[id="#${key}"]`).forEach((el) => {
      el.classList.remove("highlight");
      el.removeAttribute("tabindex");
    });
    matches.length = 0;
    currentMatchIndex = -1;
    // Defer DOM manipulation to let the custom element finish its toggle
    if (listItem) {
      setTimeout(() => bubbleListItem(listItem, false), 0);
    }
  }
});

document.addEventListener("keydown", (e) => {
  if (e.key === "ArrowRight") {
    e.preventDefault();
    if (matches.length > 0) {
      currentMatchIndex = (currentMatchIndex + 1) % matches.length;
      matches[currentMatchIndex].focus();
    }
  } else if (e.key === "ArrowLeft") {
    e.preventDefault();
    if (matches.length > 0) {
      currentMatchIndex =
        (currentMatchIndex - 1 + matches.length) % matches.length;
      matches[currentMatchIndex].focus();
    }
  }
});

// Hash navigation support for elements inside shadow DOM
function findElementById(id) {
  // First try light DOM
  let element = document.getElementById(id);
  if (element) return element;

  // Search inside all shadow roots
  const allElements = document.querySelectorAll('*');
  for (let el of allElements) {
    if (el.shadowRoot) {
      element = el.shadowRoot.getElementById(id);
      if (element) return element;

      // Recursively search in shadow root
      const found = el.shadowRoot.querySelector(`#${CSS.escape(id)}`);
      if (found) return found;
    }
  }

  return null;
}

function scrollToHash(hash) {
  if (!hash) return;

  // Remove the # prefix
  const id = hash.substring(1);

  // Find element in light DOM or shadow DOM
  let element = findElementById(id);

  if (element) {
    // If element is inside a web component (slotted content),
    // scroll to the host element instead
    let scrollTarget = element;

    // Check if element is a child of a custom element (web component)
    const hostElement = element.closest('popup-info, custom-checkbox');
    if (hostElement) {
      // Element is slotted content inside a web component
      // Scroll to the host element instead
      scrollTarget = hostElement;
    }

    // Also check if we found it in shadow DOM - if so, use the host
    if (element.getRootNode() && element.getRootNode() !== document) {
      const shadowRoot = element.getRootNode();
      if (shadowRoot.host) {
        scrollTarget = shadowRoot.host;
      }
    }

    scrollTarget.scrollIntoView({ behavior: 'smooth', block: 'center' });

    // Try to focus if possible
    if (element.tabIndex >= 0 || element.tagName === 'A') {
      element.focus();
    }

    // Add a temporary highlight to the host element
    const originalBg = scrollTarget.style.backgroundColor;
    const originalOutline = scrollTarget.style.outline;
    scrollTarget.style.backgroundColor = 'rgba(246, 166, 35, 0.3)';
    scrollTarget.style.outline = '2px solid rgb(246, 166, 35)';
    setTimeout(() => {
      scrollTarget.style.backgroundColor = originalBg;
      scrollTarget.style.outline = originalOutline;
    }, 2000);
  }
}

// Handle hash on page load
window.addEventListener('DOMContentLoaded', () => {
  if (window.location.hash) {
    // Delay to ensure shadow DOMs are created
    setTimeout(() => scrollToHash(window.location.hash), 100);
  }
});

// Handle hash changes
window.addEventListener('hashchange', () => {
  scrollToHash(window.location.hash);
});

// Intercept clicks on hash links
document.addEventListener('click', (e) => {
  const link = e.target.closest('a[href^="#"]');
  if (link) {
    const hash = link.getAttribute('href');
    if (hash && hash !== '#') {
      e.preventDefault();
      window.location.hash = hash;
      scrollToHash(hash);
    }
  }
}, true); // Use capture phase to catch clicks in shadow DOM

