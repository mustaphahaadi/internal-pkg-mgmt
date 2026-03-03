# scripts/test-phase1.sh
docker exec web-server dnf install --enablerepo=yum_local -y wget
docker exec web-server wget --version && echo "✅ PASS" || echo "❌ FAIL"
