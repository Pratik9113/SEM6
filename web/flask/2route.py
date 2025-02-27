from flask import Flask  
app = Flask(__name__)  
@app.route('/home')  
def home():  
    return "Hello, this is our first flask application ";  
  
if __name__ =="__main__":  
    app.run(debug = True)