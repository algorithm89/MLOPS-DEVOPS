export function startLightbox() {
  const overlay = document.createElement("div");
  overlay.className = "lightbox";
  overlay.setAttribute("aria-hidden", "true");
  overlay.innerHTML = `
    <button class="lightbox-close" type="button" aria-label="Close">&times;</button>
    <img class="lightbox-image" alt="">
  `;
  document.body.appendChild(overlay);

  const image = overlay.querySelector(".lightbox-image");
  const closeButton = overlay.querySelector(".lightbox-close");

  function open(src, alt) {
    image.src = src;
    image.alt = alt || "";
    overlay.classList.add("is-open");
    overlay.setAttribute("aria-hidden", "false");
    document.body.style.overflow = "hidden";
  }

  function close() {
    overlay.classList.remove("is-open");
    overlay.setAttribute("aria-hidden", "true");
    document.body.style.overflow = "";
  }

  document.addEventListener("click", (event) => {
    const trigger = event.target.closest(".zoomable");
    if (trigger) {
      open(trigger.currentSrc || trigger.src, trigger.alt);
    }
  });

  overlay.addEventListener("click", (event) => {
    // Click the backdrop or the close button to dismiss; clicking the
    // image itself keeps it open.
    if (event.target !== image) {
      close();
    }
  });

  document.addEventListener("keydown", (event) => {
    if (event.key === "Escape" && overlay.classList.contains("is-open")) {
      close();
    }
  });

  return close;
}
