
from flask import Flask, render_template

app = Flask(__name__)

@app.route("/")
def home():
    return render_template("index.html")

@app.route("/menu")
def menu():
    items = [
        {"name": "Espresso", "price": "₹130"},
        {"name": "Cappuccino", "price": "₹180"},
        {"name": "Latte", "price": "₹200"},
        {"name": "Mocha", "price": "₹220"}
    ]
    return render_template("menu.html", items=items)

@app.route("/about")
def about():
    return render_template("about.html")

@app.route("/health")
def health():
    return {"status": "ok"}

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=3000)
