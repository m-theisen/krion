from http.server import HTTPServer, BaseHTTPRequestHandler

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        try:
            with open("/etc/app/app.conf", "r") as f:
                data = f.read()
            self.send_response(200)
            self.send_header("Content-Type", "application/json")
            self.end_headers()
            self.wfile.write(data.encode())
        except Exception as e:
            self.send_response(500)
            self.send_header("Content-Type", "text/plain")
            self.end_headers()
            self.wfile.write(f"500 Internal Server Error: {str(e)}\n".encode())

if __name__ == "__main__":
    # Listens on port 5000 as appuser
    server = HTTPServer(("127.0.0.1", 5000), Handler)
    server.serve_forever()
