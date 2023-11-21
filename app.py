from flask import Flask, render_template

app = Flask(__name__)

app.secret_key = 'votre_clé_secrète'




#################################################################

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/a_propos')
def a_propos():
    return render_template('a_propos.html')

@app.route('/a_propos')
def service():
    return render_template('service.html')

@app.route('/achete_maison')
def achete_maison():
    return render_template('achete_maison.html')

@app.route('/loue_maison')
def loue_maison():
    return render_template('loue_maison.html')

@app.route('/contacte')
def contacte():
    return render_template('contacte.html')

@app.route('/profile_user')
def profile_user():
    return render_template('profile_user.html')

############################################################################

##### formulaire #############################


@app.route('/ajou_loue_maison')
def add_loue_maison():
    return render_template('add_loue_maison.html')

@app.route('/modifier_loue_maison')
def modifier_loue_maison():
    return render_template('modifier_loue_maison.html')

@app.route('/ajout_loue_maison')
def modifier_achete_maison():
    return render_template('add_achete_maison.html')

@app.route('/modifier_loue_maison')
def modifier_achete_maison():
    return render_template('modifier_achete_maison.html')

@app.route('/ajout_service')
def add_service():
    return render_template('add_service.html')

@app.route('/modifier_service')
def modifier_service():
    return render_template('modifier_service.html')



#####################################################################################

##### supprimer ############


@app.route('/a_propos')
def supprimer_service():
    return render_template('service.html')

@app.route('/achete_maison')
def supprimer_achete_maison():
    return render_template('achete_maison.html')

@app.route('/loue_maison')
def supprimer_loue_maison():
    return render_template('loue_maison.html')


if __name__ == '__main__':
    app.run(debug=True)