from flask import Flask, jsonify, request
from flask_cors import CORS
import mysql.connector

app = Flask(__name__)
CORS(app)

def connect_db():
    return mysql.connector.connect(
        host="192.168.1.100", #Canviar al nom del contenidor docker
        user="root",
        password="Educem00.",
        database="hospital-projecte"
    )

@app.route('/areas', methods=['GET'])
def get_areas():
    db = connect_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute("SELECT * FROM AREA")
    areas = cursor.fetchall()
    db.close()

    for a in areas:
        if isinstance(a['Horari'], (str, type(None))):
            continue
        a['Horari'] = str(a['Horari'])

    return jsonify(areas)

@app.route('/areas', methods=['POST'])
def create_area():
    data = request.get_json()
    db = connect_db()
    cursor = db.cursor()
    try:
        cursor.execute("""
            INSERT INTO AREA (Codi, Nom, Capacitat, Horari, CIF_Hospital)
            VALUES (%s, %s, %s, %s, %s)
        """, (data['Codi'], data['Nom'], data['Capacitat'], data['Horari'], data['CIF_Hospital']))
        db.commit()
        return jsonify({'message': 'Àrea afegida correctament'}), 201
    except Exception as e:
        db.rollback()
        print("Error al inserir l'àrea:", e) 
        return jsonify({'error': str(e)}), 500
    finally:
        db.close()

@app.route('/hospitals', methods=['POST'])
def create_hospital():
    data = request.get_json()
    db = connect_db()
    cursor = db.cursor()
    cursor.execute("""
        INSERT INTO HOSPITAL (CIF, Nom, Ubicacio)
        VALUES (%s, %s, %s)
    """, (data['CIF'], data['Nom'], data['Ubicacio']))
    db.commit()
    db.close()
    return jsonify({'message': 'Hospital afegit correctament'}), 201

@app.route('/hospitals', methods=['GET'])
def get_hospitals():
    db = connect_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute("SELECT CIF, Nom, Ubicacio FROM HOSPITAL")
    hospitals = cursor.fetchall()
    db.close()
    return jsonify(hospitals)

@app.route('/patients', methods=['GET'])
def get_patients():
    db = connect_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute("SELECT * FROM PACIENT")
    patients = cursor.fetchall()
    db.close()
    return jsonify(patients)

@app.route('/patients', methods=['POST'])
def create_patient():
    data = request.get_json()
    db = connect_db()
    cursor = db.cursor()
    
    try:
        cursor.execute("""
            INSERT INTO PACIENT (ID, Nom, Cognoms, DataNaixement, Telefono, Correu)
            VALUES (%s, %s, %s, %s, %s, %s)
        """, (
            data['ID'], 
            data['Nom'], 
            data['Cognoms'], 
            data['DataNaixement'], 
            data['Telefono'],
            data['Correu']
        ))

        if 'Antecedents' in data and isinstance(data['Antecedents'], list):
            for antecedent in data['Antecedents']:
                cursor.execute("""
                    INSERT INTO PACIENT_ANTECEDENTS (Antecedents, ID_Pacient)
                    VALUES (%s, %s)
                """, (antecedent, data['ID']))

        db.commit()
        return jsonify({'message': 'Pacient creat correctament'}), 201

    except Exception as e:
        db.rollback()
        print("Error al inserir el pacient:", e)
        return jsonify({'error': str(e)}), 500

    finally:
        db.close()


@app.route('/staff', methods=['GET'])
def get_staff():
    db = connect_db()
    cursor = db.cursor(dictionary=True)

    cursor.execute("""
        SELECT p.Codi, p.Nom, p.Cognoms, p.Salari, p.DataContracte, p.Telefono, p.Correu, p.CIF_Hospital,
               m.Especialitat,
               GROUP_CONCAT(mc.Certificats) AS Certificats
        FROM PERSONAL p
        JOIN MEDIC m ON p.Codi = m.Codi_Personal
        LEFT JOIN MEDIC_CERTIFICATS mc ON p.Codi = mc.Codi_Personal
        GROUP BY p.Codi
    """)
    medics = cursor.fetchall()

    cursor.execute("""
        SELECT p.Codi, p.Nom, p.Cognoms, p.Salari, p.DataContracte, p.Telefono, p.Correu, p.CIF_Hospital,
               n.Departament,
               GROUP_CONCAT(nt.Tasques) AS Tasques
        FROM PERSONAL p
        JOIN NO_MEDIC n ON p.Codi = n.Codi_Personal
        LEFT JOIN NO_MEDIC_TASQUES nt ON p.Codi = nt.Codi_Personal
        GROUP BY p.Codi
    """)
    no_medics = cursor.fetchall()

    db.close()

    return jsonify({
        'medics': medics,
        'no_medics': no_medics
    })

@app.route('/appointments', methods=['GET'])
def get_appointments():
    db = connect_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute("SELECT * FROM VISITA")  # O com es digui la taula de visites
    visites = cursor.fetchall()
    db.close()
    return jsonify(visites)


@app.route('/appointments', methods=['POST'])
def create_appointment():
    data = request.get_json()
    db = connect_db()
    cursor = db.cursor()
    try:
        cursor.execute("""
            INSERT INTO VISITA (ID_Pacient, Codi_Area, CIF_Hospital, DataHora_Inici, DataHora_Final)
            VALUES (%s, %s, %s, %s, %s)
        """, (
            data['ID_Pacient'],
            data['Codi_Area'],
            data['CIF_Hospital'],
            data['DataHora_Inici'],
            data['DataHora_Final']
        ))
        
        db.commit()
        return jsonify({'message': 'Visita registrada correctament'}), 201
    except Exception as e:
        db.rollback()
        print("Error al inserir la visita:", e)
        return jsonify({'error': str(e)}), 500
    finally:
        db.close()

@app.route('/staff', methods=['POST'])
def create_staff():
    data = request.get_json()
    db = connect_db()
    cursor = db.cursor()

    try:
        cursor.execute("""
            INSERT INTO PERSONAL (Codi, Nom, Cognoms, Salari, DataContracte, Telefono, Correu, CIF_Hospital)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
        """, (
            data['Codi'], data['Nom'], data['Cognoms'], data['Salari'],
            data['DataContracte'], data['Telefono'], data['Correu'], data['CIF_Hospital']
        ))

        if data['Tipus'] == 'medic':
            cursor.execute("""
                INSERT INTO MEDIC (Codi_Personal, Especialitat)
                VALUES (%s, %s)
            """, (data['Codi'], data['Especialitat']))
            
            if 'Certificats' in data and isinstance(data['Certificats'], list):
                for certificat in data['Certificats']:
                    cursor.execute("""
                        INSERT INTO MEDIC_CERTIFICATS (Certificats, Codi_Personal)
                        VALUES (%s, %s)
                    """, (certificat.strip(), data['Codi']))

        elif data['Tipus'] == 'no_medic':
            cursor.execute("""
                INSERT INTO NO_MEDIC (Codi_Personal, Departament)
                VALUES (%s, %s)
            """, (data['Codi'], data['Departament']))

            if 'Tasques' in data and isinstance(data['Tasques'], list):
                for tasca in data['Tasques']:
                    cursor.execute("""
                        INSERT INTO NO_MEDIC_TASQUES (Tasques, Codi_Personal)
                        VALUES (%s, %s)
                    """, (tasca.strip(), data['Codi']))
        else:
            db.rollback()
            db.close()
            return jsonify({'error': 'Tipus de personal no vàlid'}), 400

        db.commit()
        return jsonify({'message': 'Personal afegit correctament'}), 201

    except Exception as e:
        db.rollback()
        print("Error al inserir el personal:", e)
        return jsonify({'error': str(e)}), 500

    finally:
        db.close()

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)