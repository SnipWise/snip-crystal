# SNIP Crystal

> A project for learning Rust based on the SNIP project: https://github.com/SnipWise/snip

## Prerequisites

- [Docker](https://www.docker.com/get-started/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [Docker Model Runner](https://docs.docker.com/ai/model-runner/)
- [VSCode](https://code.visualstudio.com/)

## Setup

### Git Clone the Repository

```
git clone https://github.com/SnipWise/snip-crystal.git
```

### Install the VSCode Extension

```bash
code --install-extension swise-extension-0.0.1.vsix
```
> Source code available at: https://github.com/SnipWise/swise

### Run the Snip Server

```bash
docker compose -f .snip/compose.yml up -d
```
> The snip server is listening on port `3500` by default.

### Access the VSCode extension Interface

- Cmd+Shift+P (Mac) or Ctrl+Shift+P (Windows/Linux)
- Type `Open Swise` and hit Enter

You should now be able to interact with the Snip Rustlang project using the VSCode extension:

![swise](.snip/assets/swise.png)

![swise](.snip/assets/example.png)

### Start the Crystal playground

```bash
docker compose -f .snip/compose.yml exec playground bash
```

### Stopping the Snip Server

```bash
docker compose -f .snip/compose.yml down
```