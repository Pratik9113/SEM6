from flask import *  
app = Flask(__name__)  
@app.route('/admin')  
def admin():  
    return 'This is admin page'  
@app.route('/librarian')  
def librarian():  
    return 'This is librarian page'  
@app.route('/student')  
def student():  
    return 'This is student page'  
@app.route('/user/<name>')  
def user(name):  
    if name == 'admin':  
        return redirect(url_for('admin'))  
    if name == 'librarian':  
        return redirect(url_for('librarian'))  
    if name == 'student':  
        return redirect(url_for('student'))  
if __name__ =='__main__':  
    app.run(debug = True) 