from flask import *  
app = Flask(__name__)  
@app.route('/user/<uname>')  
def message(uname):  
      
      #    return "<html><body><h1>Welcome to Flask</h1></body></html>" 
      return render_template('message.html') 
      # return render_template('message1.html',name=uname)
if __name__ == '__main__':  
   app.run(debug = True)  
