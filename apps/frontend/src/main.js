import "./styles.css";
import { startMatrixRain } from "./matrixRain.js";
import { startLightbox } from "./lightbox.js";
import {
  cryptoTopics,
  engagementRules,
  learningPaths,
  securityWorkflow,
  terminalLines
} from "./resources/content.js";

startMatrixRain();
startLightbox();

document.querySelector("#app").innerHTML = `
  <main class="shell">
    <section class="hero">
      <div class="hero-copy">
        <span class="eyebrow">Cryptography // White-Hat Hacking</span>
        <h1>Learn how to protect systems, verify trust, and test ethically.</h1>
        <p>
          Cryptoverse is a learning space for encryption, hashing, secure systems,
          and authorized security testing. The focus is simple: learn the concepts,
          practice safely, and build better defenses.
        </p>
        <div class="hero-actions" aria-label="Primary learning areas">
          <a href="#paths">Start learning</a>
          <a href="#ethics">Rules of engagement</a>
        </div>
      </div>

      <div class="terminal-panel" aria-label="Security terminal preview">
        <div class="panel-header">
          <span>secure-lab.local</span>
          <strong>authorized</strong>
        </div>
        <div class="terminal">
          ${terminalLines
            .map((line) =>
              line.command
                ? `<p><span>$</span> ${line.command.replace("$ ", "")}</p>`
                : `<p class="${line.tone}">${line.result}</p>`
            )
            .join("")}
        </div>
      </div>
    </section>

    <section class="pathway-feature" aria-label="Ethical pentester pathway">
      <img class="zoomable" src="/resources/images/place4.png" alt="Ethical pentester pathway" title="Click to magnify">
      <div>
        <span class="eyebrow">Authorized Testing Pathway</span>
        <h2>Learn the process before touching the tools.</h2>
        <p>
          The goal is not just finding issues. It is understanding scope,
          validating safely, explaining risk, and helping teams improve defenses.
        </p>
      </div>
    </section>

    <section class="learning-paths" id="paths" aria-label="Learning paths">
      ${learningPaths
        .map(
          (path) => `
            <article class="path-card">
              <img src="${path.image}" alt="${path.title}">
              <div>
                <span>${path.eyebrow}</span>
                <h2>${path.title}</h2>
                <p>${path.description}</p>
              </div>
            </article>
          `
        )
        .join("")}
    </section>

    <section class="split-panel" aria-label="Cryptography and white-hat focus areas">
      <div class="focus focus-crypto">
        <span class="eyebrow">Cryptography</span>
        <h2>Protect the data.</h2>
        <p>
          Study encryption, key exchange, hashing, signatures, and how each layer
          supports confidentiality, integrity, and trust.
        </p>
        <div class="mini-grid">
          ${cryptoTopics
            .map(
              (topic) => `
                <article>
                  <span>${topic.label}</span>
                  <strong>${topic.value}</strong>
                  <small>${topic.status}</small>
                </article>
              `
            )
            .join("")}
        </div>
      </div>

      <div class="focus focus-hacking">
        <span class="eyebrow">White-Hat Hacking</span>
        <h2>Test with permission.</h2>
        <p>
          Practice reconnaissance, validation, reporting, and remediation in a lab
          that keeps ethics and authorization at the center.
        </p>
        <div class="mini-grid">
          ${securityWorkflow
            .map(
              (item) => `
                <article>
                  <span>${item.label}</span>
                  <strong>${item.value}</strong>
                  <small>${item.status}</small>
                </article>
              `
            )
            .join("")}
        </div>
      </div>
    </section>

    <section class="lab-strip" aria-label="Lab pipeline">
      <div class="lab-node">
        <span>01</span>
        <strong>Encrypt</strong>
      </div>
      <div class="lab-line"></div>
      <div class="lab-node">
        <span>02</span>
        <strong>Verify</strong>
      </div>
      <div class="lab-line"></div>
      <div class="lab-node">
        <span>03</span>
        <strong>Assess</strong>
      </div>
      <div class="lab-line"></div>
      <div class="lab-node">
        <span>04</span>
        <strong>Harden</strong>
      </div>
    </section>

    <section class="checklist" id="ethics">
      <div>
        <span class="eyebrow">Rules of Engagement</span>
        <h2>Keep the work ethical</h2>
      </div>
      <ol>
        ${engagementRules.map((rule) => `<li>${rule}</li>`).join("")}
      </ol>
    </section>
  </main>
`;
