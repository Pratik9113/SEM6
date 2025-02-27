from flask import Flask 
app=Flask(__name__)
@app.route('/')   #root decorator

def hello():     #view function
    return "Welcome to Flask tutorial"



if __name__=="__main__":
    app.run()
    # app.run(debug=True)