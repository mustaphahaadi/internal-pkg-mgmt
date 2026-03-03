up:
    docker-compose up --build -d

down:
    docker-compose down

test:
    bash scripts/test-phase1.sh

add-pkg:
    bash scripts/add-package.sh $(PKG)

logs:
    docker-compose logs -f
