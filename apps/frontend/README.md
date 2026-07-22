# Frontend App

Vite-powered frontend for the cryptography and white-hat security lab.

## Structure

```text
.
|-- public/
|   `-- resources/
|       `-- images/
|-- src/
|   |-- resources/
|   |   `-- content.js
|   |-- main.js
|   `-- styles.css
|-- Dockerfile
|-- index.html
|-- package.json
`-- package-lock.json
```

## Local Development

Install dependencies:

```powershell
npm.cmd install
```

Run the dev server:

```powershell
npm.cmd run dev
```

Open:

```text
http://localhost:5173
```

## Production Build

```powershell
npm.cmd run build
```

## Local Docker Test

Build the image:

```powershell
docker build -t azure-terraform-lab-frontend .
```

Run it locally:

```powershell
docker run --rm -p 8080:80 azure-terraform-lab-frontend
```

Open:

```text
http://localhost:8080
```
