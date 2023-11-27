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

######## maison ###########
@app.route('/mise_en_vente_maison')
def add_mise_en_vente_maison():
    return render_template('/formulaire/ajoute/mise_en_vente_maison.html')


@app.route('/modifier_mise_en_vente_maison')
def modifier_mise_en_vente_maison():
    return render_template('/formulaire/modifier/modifier_mise_en_vente_maison.html')

@app.route('/supprimer_mise_en_vente_maison')
def supprimer_mise_en_vente_maison():
    return

@app.route('/profile_maison_en_vente')
def profile_maison_en_vente():
    return render_template('/profile/profile_maison.html')

#### loue_maison ###################

@app.route('/mise_en_location')
def mise_en_location():
    return render_template('/formulaire/ajoute/mise_en_location.html')

@app.route('/profile_location')
def profile_location():
    return render_template('/profile/profile_location.html')

@app.route('/modifier_mise_en_location')
def modifier_mise_en_location():
    return render_template('/formulaire/modifier/modifier_mise_en_location.html')

@app.route('/supprimer_mise_en_location')
def supprimer_mise_en_location():
    return 

######## service  ###########

@app.route('/ajout_service')
def add_service():
    return render_template('/formulaire/ajoute/ajout_service.html')

@app.route('/modifier_service')
def modifier_service():
    return render_template('/formulaire/modifier/modifier_service.html')

@app.route('/supprimer_service')
def supprimer_service():
    return render_template('service.html')

if __name__ == '__main__':
    app.run(debug=True)