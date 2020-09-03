# Code a HTTP Server here...
from http.server import HTTPServer, SimpleHTTPRequestHandler


def main():
    httpd = HTTPServer(("", 8000), SimpleHTTPRequestHandler)
    httpd.serve_forever()


if __name__ == "__main__":
    main()
