node_modules: pnpm-lock.yaml
	pnpm install
	@touch node_modules

.PHONY: deps
deps: node_modules

.PHONY: lint
lint: .venv
	uv run --frozen tomllint *.toml

.PHONY: lint-fix
lint-fix: .venv
	uv run --frozen tomllint *.toml

.PHONY: test
test: node_modules

.PHONY: build
build: node_modules

.PHONY: publish
publish: node_modules
	pnpm publish --no-git-checks

.PHONY: update
update: update-js update-py update-actions

.PHONY: update-js
update-js: node_modules
	pnpm exec updates -u -f package.json
	rm -rf node_modules pnpm-lock.yaml
	pnpm install
	@touch node_modules

.PHONY: update-actions
update-actions: node_modules
	pnpm exec updates -u -M actions

.PHONY: patch minor major
patch minor major: node_modules lint test
	pnpm exec versions -R $@ package.json

.venv: uv.lock
	uv sync
	@touch .venv

.PHONY: update-py
update-py: node_modules
	pnpm exec updates -u -f pyproject.toml
	uv lock --upgrade
	uv sync
	@touch .venv
