from flask import Flask, render_template

app = Flask(__name__)

app.secret_key = 'votre_clé_secrète'



#################################################################

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/a_propos')
def a_propos():
    return render_template('/page/a_propos.html')

@app.route('/service')
def service():
    return render_template('/page/service.html')

@app.route('/achete_maison')
def achete_maison():
    return render_template('/page/achete_maison.html')

@app.route('/loue_maison')
def loue_maison():
    return render_template('/page/loue_maison.html')

@app.route('/contacte')
def contacte():
    return render_template('/page/contacte.html')

############################################################################

#### profile ###

@app.route('/profile_user')
def profile_user():
    return render_template('/profile/profile_user.html')


##### formulaire #############################

######## location ###########

@app.route('/ajou_loue_maison')
def add_loue_maison():
    return render_template('/formulaire/location/ajout_loue_maison.html')

@app.route('/modifier_loue_maison')
def modifier_loue_maison():
    return render_template('/formulaire/location/modifier_loue_maison.html')

@app.route('/supprimer_loue_maison')
def supprimer_loue_maison():
    return

@app.route('/profile_loue_maison')
def profile_loue_maison():
    return render_template('/profile/profile_loue_maison.html')

######## fini location ###########
######## maison ###########

@app.route('/ajout_achete_maison')
def add_achete_maison():
    return render_template('/formulaire/maison/ajout_achete_maison.html')

@app.route('/modifier_achete_maison')
def modifier_achete_maison():
    return render_template('/formulaire/maison/modifier_achete_maison.html')

@app.route('/supprimer_achete_maison')
def supprimer_achete_maison():
    return 

@app.route('/profile_achete_maison')
def profile_achete_maison():
    return render_template('/profile/profile_achete_maison.html')

######## fini maison ###########


##### servisse ############

@app.route('/ajout_service')
def add_service():
    return render_template('/formulaire/servisse/ajout_service.html')

@app.route('/modifier_service')
def modifier_service():
    return render_template('/formulaire/servisse/modifier_service.html')

@app.route('/supprimer_service')
def supprimer_service():
    return 

#####################################################################################

if __name__ == '__main__':
    app.run(debug=True)