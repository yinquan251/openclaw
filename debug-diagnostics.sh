#!/bin/bash
echo "=== OpenClaw Debug Diagnostics ==="
echo ""

echo "1. Current directory:"
pwd
echo ""

echo "2. Checking dist/index.js and source map:"
ls -lh dist/index.js* 2>&1 || echo "Files not found!"
echo ""

echo "3. Checking if index.js.map exists and has content:"
if [ -f dist/index.js.map ]; then
    echo "✓ dist/index.js.map exists ($(wc -c < dist/index.js.map) bytes)"
    
    echo ""
    echo "4. Checking source map content:"
    node -e "
    const map = JSON.parse(require('fs').readFileSync('dist/index.js.map', 'utf8'));
    console.log('Total sources:', map.sources.length);
    console.log('Has commands/agents:', map.sources.filter(s => s.includes('commands/agents')).length);
    console.log('Has shared:', map.sources.filter(s => s.includes('shared')).length);
    console.log('');
    console.log('First 10 source paths:');
    map.sources.slice(0, 10).forEach(s => console.log('  ' + s));
    "
else
    echo "✗ dist/index.js.map NOT FOUND - source maps not generated!"
fi
echo ""

echo "5. Checking .vscode configuration:"
if [ -f .vscode/launch.json ]; then
    echo "✓ .vscode/launch.json exists"
    grep -A 2 '"program"' .vscode/launch.json
else
    echo "✗ .vscode/launch.json NOT FOUND"
fi
echo ""

echo "6. Checking tsdown.config.ts for sourcemap setting:"
grep -A 3 "entry.*index.ts" tsdown.config.ts
echo ""

echo "7. VS Code workspace folder should be:"
echo "   /home/ocal_dmin/Workspace/openclaw"
echo ""

echo "=== End Diagnostics ==="
