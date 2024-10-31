import os.path
from flask import *
import pymysql
from werkzeug.utils import secure_filename

app=Flask(__name__)

try:
    con = pymysql.connect(host='localhost', port=3306, user='root', password='root', db='account', charset='utf8')
    cmd = con.cursor()
    print("db connected")
except pymysql.Error as e:
    print("Error connecting to MySQL:", e)


@app.route('/updateemployee', methods=['POST'])
def updateemployee():
    if request.method == 'POST':
        try:
            data = request.get_json()

            name = data.get('name')
            email = data.get('email')
            phone_number = data.get('phonenumber')
            dob = data.get('dob')
            age = data.get('age')
            gender = data.get('gender')
            country = data.get('country')
            address = data.get('address')
            pincode = data.get('pincode')
            print(data)

            # Print data for debugging purposes
            print(f"Name: {name}")
            print(f"Email: {email}")
            print(f"Phone Number: {phone_number}")
            print(f"DOB: {dob}")
            print(f"Age: {age}")
            print(f"Gender: {gender}")
            print(f"Country: {country}")
            print(f"Address: {address}")
            print(f"Pincode: {pincode}")

            cmd.execute("""
                UPDATE register
                SET name = %s, dateofbirth = %s, age = %s, gender = %s, country = %s, address = %s, pincode = %s, phonenumber = %s
                WHERE username = %s
            """, (name, dob, age, gender, country, address, pincode, phone_number, email))

            con.commit()

            response = {'status': 'success', 'message': 'Updated'}

        except Exception as e:
            print(e)
            response = {'status': 'failed', 'message': str(e)}

        return jsonify(response)

@app.route('/fetchemployees', methods=['GET'])
def fetchemployees():
    try:
        cmd.execute("SELECT name,username,dateofbirth,age,gender,country,address,pincode,phonenumber,profile_pic FROM register")
        rows = cmd.fetchall()
        details = [{'name': row[0],'email': row[1],'dob':row[2],'age':row[3],'gender':row[4],
                  'country':row[5],'address':row[6],'pincode':row[7],'phonenumber':row[8],
                  'imagePath': f"/static/images/{row[9]}"} for row in rows]
        response = {'status': 'success', 'details': details}
    except Exception as e:
        print(e)
        response = {'status': 'error', 'message': 'An error occurred while fetching names.'}

    return jsonify(response)

@app.route('/updatesalary', methods=['POST'])
def updatesalary():
    try:
        data = request.get_json()
        email = data.get('email')
        new_salary = data.get('salary')
        cmd.execute("""
            UPDATE salary
            SET salary = %s
            WHERE email = %s
        """, (new_salary, email))
        con.commit()
        response = {'status': 'success', 'message': 'Salary updated successfully.'}
    except Exception as e:
        print(e)
        response = {'status': 'error', 'message': 'An error occurred while updating the salary.'}
    return jsonify(response)


@app.route('/fetchsalary', methods=['GET'])
def fetchsalary():
    try:
        cmd.execute("""
            SELECT r.name, r.username, r.profile_pic, s.salary 
            FROM register r
            INNER JOIN salary s ON r.username = s.email
        """)
        rows = cmd.fetchall()
        details = [{'name': row[0] or '', 'email': row[1] or '', 'imagePath': f"/static/images/{row[2]}" or '', 'salary': row[3] or '0'} for row in rows]
        response = {'status': 'success', 'details': details}
    except Exception as e:
        print(e)
        response = {'status': 'error', 'message': 'An error occurred while fetching salary details.'}
    return jsonify(response)



    return jsonify(response)

@app.route('/fetchnames', methods=['GET'])
def fetchnames():
    try:
        cmd.execute("SELECT name,username, profile_pic FROM register")
        rows = cmd.fetchall()
        names = [{'name': row[0],'email': row[1], 'imagePath': f"/static/images/{row[2]}"} for row in rows]
        response = {'status': 'success', 'names': names}
    except Exception as e:
        print(e)
        response = {'status': 'error', 'message': 'An error occurred while fetching names.'}

    return jsonify(response)



@app.route('/fetchlocation', methods=['GET'])
def fetchlocation():
    email = request.args.get('email')
    try:
        cmd.execute("SELECT date,time, latitude, longitude FROM location WHERE email=%s", (email,))
        rows = cmd.fetchall()
        print(rows)
        locations = [{'date': row[0],'time': row[1], 'latitude': row[2], 'longitude': row[3]} for row in rows]
        response = {'status': 'success', 'locations': locations}
    except Exception as e:
        print(e)
        response = {'status': 'error', 'message': str(e)}

    return jsonify(response)


@app.route('/logout', methods=['POST', 'GET'])
def logout():
    email = request.args.get('email')
    cmd.execute("UPDATE login SET status=%s WHERE uname=%s", ("offline", email))
    con.commit()
    return "ok"

@app.route('/login', methods=['POST', 'GET'])
def login():
    email = request.args.get('email')
    password = request.args.get('password')
    print("Email : ",email)
    print("Password : ",password)
    cmd.execute("SELECT * FROM login WHERE uname = %s and password =%s", (str(email),str(password)))
    s = cmd.fetchone()
    if s:
        cmd.execute("UPDATE login SET status=%s WHERE uname=%s", ("online", email))
        con.commit()
        lid = s[0]
        usertype = s[4]
        print(s)
        status="success"
        # row_headers = [x[0] for x in cmd.description]
        json_data = [{'status':status,'lid': lid, 'usertype': usertype}]
        return jsonify(json_data)
    else:
        status = "failed"
        json_data = [{'status': status}]
        return jsonify(json_data)


@app.route('/register', methods=['POST'])
def register():
    if request.method == 'POST':
        try:
            name = request.form['name']
            username = request.form['username']
            password = request.form['password']
            date_of_birth = request.form['date_of_birth']
            age = request.form['age']
            gender = request.form['gender']
            country = request.form['country']
            address = request.form['address']
            pincode = request.form['pincode']
            phone_number = request.form['phone_number']
            profile_pic = request.files['img']




            cmd.execute("SELECT username FROM register WHERE username=%s", (username,))
            res = cmd.fetchone()

            if res is None or res[0] != username:
                cmd.execute("INSERT INTO login (uname, password, usertype) VALUES (%s, %s, 'user')", (username, password,))
                login_id = cmd.lastrowid
                con.commit()
                cmd.execute("INSERT INTO salary (email, name) VALUES (%s, %s)",
                            (username, name,))
                con.commit()
                profile_pic_filename = secure_filename(f"{login_id}.jpg")
                profile_pic_path = os.path.join('./static/images/',profile_pic_filename)
                profile_pic.save(profile_pic_path)

                cmd.execute(
                    "INSERT INTO register (name, username, dateofbirth, age, gender, country, address, pincode, phonenumber, loginid, profile_pic) "
                    "VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)",
                    (name, username, date_of_birth, age, gender, country, address, pincode, phone_number, login_id, profile_pic_filename)
                )
                con.commit()
                response = {'status': 'success', 'message': 'Registered'}
            else:
                print("Already registered")
                response = {'status': 'failed', 'message': 'Already registered'}

        except Exception as e:
            print(e)
            response = {'status': 'failed', 'message': str(e)}

        return jsonify(response)

@app.route('/forget', methods=['POST'])
def forget():
    email = request.args.get('email')
    print(email)
    try:
        cmd.execute("SELECT uname FROM login WHERE uname=%s", (email,))
        res = cmd.fetchone()
        if res is not None:
            response = {'status': 'success', 'message': 'OTP send to register mobile number'}
        else:
            print("Not registered email")
            response = {'status': 'failed', 'message': 'Not registered email'}

    except Exception as e:
        print(e)
        response = {'status': 'failed', 'message': str(e)}

    return jsonify(response)

@app.route('/otp', methods=['POST'])
def otp():
    email = request.args.get('email')
    otp=request.args.get('otp')
    print(email)
    print(otp)
    try:
        cmd.execute("SELECT uname FROM login WHERE uname=%s and otp=%s", (email,otp))
        res = cmd.fetchone()
        if res is not None:
            response = {'status': 'success'}
        else:
            print("failed")
            response = {'status': 'failed'}

    except Exception as e:
        print(e)
        response = {'status': 'failed', 'message': str(e)}

    return jsonify(response)

@app.route('/new_password', methods=['POST'])
def new_password():
    email = request.args.get('email')
    newpassword=request.args.get('newpassword')
    print(email)
    print(newpassword)
    try:
        cmd.execute("UPDATE login SET password=%s WHERE uname=%s", (newpassword, email))
        con.commit()
        response = {'status': 'success'}
    except Exception as e:
        print(e)
        response = {'status': 'failed', 'message': str(e)}

    return jsonify(response)


@app.route('/latloc', methods=['POST', 'GET'])
def latloc():
    email = request.args.get('email')
    lat = request.args.get('lat')
    lng = request.args.get('lng')
    print(email, lat, lng)

    try:
        sql = "INSERT INTO location (latitude, longitude, email, date, time) VALUES (%s, %s, %s, CURDATE(), CURTIME())"
        cmd.execute(sql, (lat, lng, email))
        con.commit()
        response = {'status': 'success'}
    except Exception as e:
        print(e)
        response = {'status': 'failed', 'message': str(e)}

    return jsonify(response)


if __name__ == "__main__":
    app.run(port=5000, host='0.0.0.0')