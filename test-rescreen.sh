#!/bin/bash
# test-rescreen.sh - Simple test script for rescreen

# Test if rescreen has the correct version flag
test_version() {
  echo "Testing --version flag..."
  output=$(./rescreen --version)
  if [[ "$output" == *"rescreen version"* ]]; then
    echo "✅ Version flag works correctly"
    return 0
  else
    echo "❌ Version flag test failed"
    return 1
  fi
}

# Test if rescreen can list ports (mocked)
test_port_listing() {
  echo "Testing port listing with mock data..."
  # Create a temporary mock to override the get_ports function
  cat > test-mock.sh <<EOF
#!/bin/bash
# Mock the get_ports function
get_ports() {
  echo "/dev/tty.usbmodem1234"
  echo "/dev/tty.usbserial5678"
}
EOF
  
  # Make script source our mock
  cp rescreen rescreen-test
  sed -i '' '9i\
source ./test-mock.sh
' rescreen-test
  
  # Run with parameter to just show ports and exit for testing
  chmod +x rescreen-test
  output=$(echo "Exit" | ./rescreen-test)
  
  if [[ "$output" == *"/dev/tty.usbmodem1234"* && "$output" == *"/dev/tty.usbserial5678"* ]]; then
    echo "✅ Port listing works correctly"
    rm rescreen-test test-mock.sh
    return 0
  else
    echo "❌ Port listing test failed"
    rm rescreen-test test-mock.sh
    return 1
  fi
}

# Run tests
echo "Running tests for rescreen..."
test_version
test_port_listing

echo "All tests completed!"
