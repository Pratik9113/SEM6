from flask import *  
app = Flask(__name__)  
@app.route('/login1',methods = ['GET'])  
def login():  
      uname=request.args.get('uname')  
      password=request.args.get('pass')  
      if uname=="Ping" and password=="pong":  
          return "Welcome %s" %uname    
           
if __name__ == '__main__':  
   app.run(debug = True)  