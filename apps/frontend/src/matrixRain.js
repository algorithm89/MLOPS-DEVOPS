export function startMatrixRain() {
  const canvas = document.createElement("canvas");
  canvas.className = "matrix-rain";
  canvas.setAttribute("aria-hidden", "true");
  document.body.prepend(canvas);

  const context = canvas.getContext("2d");
  // Number-heavy stream with a few code-ish glyphs mixed in.
  const characters = "0123456789012345678901234567{}[]<>#$";
  const fontSize = 16;
  let columns = 0;
  let drops = [];
  let directions = [];
  let animationFrameId;

  function resetColumn(index, randomStart) {
    const rows = Math.ceil(window.innerHeight / fontSize);
    // Roughly a third of the columns rise instead of fall.
    directions[index] = Math.random() > 0.66 ? -1 : 1;
    drops[index] = randomStart
      ? Math.floor(Math.random() * rows)
      : directions[index] === 1
        ? 0
        : rows;
  }

  function resize() {
    const pixelRatio = window.devicePixelRatio || 1;
    canvas.width = Math.floor(window.innerWidth * pixelRatio);
    canvas.height = Math.floor(window.innerHeight * pixelRatio);
    canvas.style.width = `${window.innerWidth}px`;
    canvas.style.height = `${window.innerHeight}px`;
    context.setTransform(pixelRatio, 0, 0, pixelRatio, 0, 0);

    columns = Math.ceil(window.innerWidth / fontSize);
    drops = new Array(columns);
    directions = new Array(columns);
    for (let index = 0; index < columns; index += 1) {
      resetColumn(index, true);
    }
  }

  function draw() {
    context.fillStyle = "rgba(5, 10, 24, 0.08)";
    context.fillRect(0, 0, window.innerWidth, window.innerHeight);
    context.font = `${fontSize}px Cascadia Code, Consolas, monospace`;

    for (let index = 0; index < columns; index += 1) {
      const character = characters[Math.floor(Math.random() * characters.length)];
      const x = index * fontSize;
      const y = drops[index] * fontSize;

      context.fillStyle = Math.random() > 0.985 ? "#f0abfc" : "#22d3ee";
      context.fillText(character, x, y);

      const offScreen =
        directions[index] === 1 ? y > window.innerHeight : y < 0;
      if (offScreen && Math.random() > 0.975) {
        resetColumn(index, false);
      } else {
        drops[index] += directions[index];
      }
    }

    animationFrameId = window.requestAnimationFrame(draw);
  }

  resize();
  draw();

  window.addEventListener("resize", resize);

  return () => {
    window.cancelAnimationFrame(animationFrameId);
    window.removeEventListener("resize", resize);
    canvas.remove();
  };
}
