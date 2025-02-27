from flask import *  
app = Flask(__name__) 
 
 
@app.route('/setcookie')
def setcookie():
    resp = make_response("The Cookie has been Set")
    resp.set_cookie('ClassName','D15A')
    return resp
 
@app.route('/getcookie')
def getcookie():
    result = request.cookies.get('ClassName')
    return f"The name is : {result}"
 
if __name__ == '__main__':  
   app.run(debug = True)   




   