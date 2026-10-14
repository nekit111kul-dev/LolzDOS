#!/usr/bin/env python3
"""Tiny local web server: python3 serve.py [port]"""
import http.server, socketserver, sys, os, mimetypes
os.chdir(os.path.dirname(os.path.abspath(__file__)))
mimetypes.add_type("application/wasm", ".wasm")
mimetypes.add_type("application/zip", ".jsdos")
port = int(sys.argv[1]) if len(sys.argv) > 1 else 8000
class H(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header("Cache-Control", "no-cache")
        super().end_headers()
socketserver.TCPServer.allow_reuse_address = True
with socketserver.TCPServer(("", port), H) as s:
    print(f"LolzDOS: http://localhost:{port}/   (Ctrl+C to stop)")
    s.serve_forever()
