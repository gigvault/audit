.PHONY: build test lint docker run-local clean

build:
	go build -o bin/audit ./cmd/audit

test:
	go test ./... -v

lint:
	golangci-lint run ./...

docker:
	docker build -t gigvault/audit:local .

run-local: docker
	../infra/scripts/deploy-local.sh audit

clean:
	rm -rf bin/
	go clean
