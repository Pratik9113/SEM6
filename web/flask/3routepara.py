from flask import Flask  
app = Flask(__name__)  
@app.route('/product/<name>')
def get_product(name):
  return "The product is " + str(name)
  
if __name__ =="__main__":  
    app.run(debug = True)




