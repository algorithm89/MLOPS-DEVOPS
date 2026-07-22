export const cryptoTopics = [
  {
    label: "AES-256",
    value: "Symmetric",
    status: "Fast data protection"
  },
  {
    label: "RSA / ECC",
    value: "Asymmetric",
    status: "Key exchange and identity"
  },
  {
    label: "SHA-256",
    value: "Hashing",
    status: "Integrity checks"
  }
];

export const learningPaths = [
  {
    title: "White-Hat Mindset",
    eyebrow: "Ethics first",
    image: "/resources/images/place1.png",
    description:
      "Learn how defenders think: scope, permission, impact, documentation, and responsible reporting."
  },
  {
    title: "Cryptography Basics",
    eyebrow: "Keys and hashes",
    image: "/resources/images/place2.png",
    description:
      "Understand encryption, decryption, hashes, and why strong key handling protects real systems."
  },
  {
    title: "Secure Systems",
    eyebrow: "Practice safely",
    image: "/resources/images/place3.png",
    description:
      "Connect the concepts to labs, network defense, secure deployment, and verification workflows."
  }
];

export const securityWorkflow = [
  {
    label: "Recon",
    value: "Scope first",
    status: "Only authorized targets"
  },
  {
    label: "Validate",
    value: "Low noise",
    status: "Confirm the finding"
  },
  {
    label: "Report",
    value: "Fix path",
    status: "Evidence and remediation"
  }
];

export const engagementRules = [
  "Work only on systems you own or have written permission to test",
  "Document scope, timestamps, impact, and proof clearly",
  "Prefer safe validation over aggressive exploitation",
  "Report findings with practical remediation steps"
];

export const terminalLines = [
  { command: "$ verify --hash artifact.zip" },
  { result: "sha256 match: integrity confirmed", tone: "success" },
  { command: "$ scan --scope lab-network" },
  { result: "finding: exposed test service on 8080", tone: "warning" },
  { command: "$ report --severity low --owner infra" },
  { result: "report queued with remediation notes", tone: "success" }
];
