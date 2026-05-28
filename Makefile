node_modules: pnpm-lock.yaml
	pnpm install
	@touch node_modules

.venv: uv.lock
	uv sync
	@touch .venv

.PHONY: deps
deps: node_modules

.PHONY: lint
lint: lint-toml

.PHONY: lint-toml
lint-toml: .venv
	uv run --frozen tomllint *.toml

.PHONY: test
test:
	exit 0

.PHONY: update
update: update-js update-actions

.PHONY: update-js
update-js: node_modules
	pnpm exec updates -u -f package.json
	rm -rf node_modules pnpm-lock.yaml
	pnpm install
	@touch node_modules

.PHONY: publish
publish: node_modules
	pnpm publish --no-git-checks

.PHONY: patch minor major
patch minor major: node_modules lint test
	pnpm exec versions -R $@ package.json

.PHONY: update-actions
update-actions: node_modules
	pnpm exec updates -u -M actions
