from flask import Flask  
app = Flask(__name__)  
def about():  
    return "This is about page, welcome to flask";  
app.add_url_rule("/about","hi",about)  
if __name__ =="__main__":  
    app.run(debug = True)  