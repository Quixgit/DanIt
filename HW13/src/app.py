from flask import Flask, request, jsonify
import csv
import os

app = Flask(__name__)
CSV_FILE = 'students.csv'

# Ініціалізувати CSV-файл заголовками, якщо його не існує
if not os.path.exists(CSV_FILE):
    with open(CSV_FILE, mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(['id', 'first_name', 'last_name', 'age'])

def read_students():
    with open(CSV_FILE, mode='r') as file:
        reader = csv.DictReader(file)
        return list(reader)

def write_students(students):
    with open(CSV_FILE, mode='w', newline='') as file:
        writer = csv.DictWriter(file, fieldnames=['id', 'first_name', 'last_name', 'age'])
        writer.writeheader()
        writer.writerows(students)

@app.route('/students', methods=['GET'])
def get_students():
    students = read_students()
    return jsonify(students), 200

@app.route('/students/<int:student_id>', methods=['GET'])
def get_student_by_id(student_id):
    students = read_students()
    student = next((s for s in students if int(s['id']) == student_id), None)
    if student:
        return jsonify(student), 200
    return jsonify({'error': 'Student not found'}), 404

@app.route('/students/last_name/<string:last_name>', methods=['GET'])
def get_students_by_last_name(last_name):
    students = read_students()
    matching_students = [s for s in students if s['last_name'].lower() == last_name.lower()]
    if matching_students:
        return jsonify(matching_students), 200
    return jsonify({'error': 'Last name not found'}), 404

@app.route('/students', methods=['POST'])
def create_student():
    data = request.json
    if not data or 'first_name' not in data or 'last_name' not in data or 'age' not in data:
        return jsonify({'error': 'Missing fields'}), 400

    students = read_students()
    new_id = max(int(s['id']) for s in students) + 1 if students else 1
    student = {
        'id': new_id,
        'first_name': data['first_name'],
        'last_name': data['last_name'],
        'age': data['age']
    }
    students.append(student)
    write_students(students)
    return jsonify(student), 201

@app.route('/students/<int:student_id>', methods=['PUT'])
def update_student(student_id):
    data = request.json
    if not data or 'first_name' not in data or 'last_name' not in data or 'age' not in data:
        return jsonify({'error': 'Missing fields'}), 400

    students = read_students()
    student = next((s for s in students if int(s['id']) == student_id), None)
    if student:
        student['first_name'] = data['first_name']
        student['last_name'] = data['last_name']
        student['age'] = data['age']
        write_students(students)
        return jsonify(student), 200
    return jsonify({'error': 'Student not found'}), 404

@app.route('/students/<int:student_id>', methods=['PATCH'])
def update_student_age(student_id):
    data = request.json
    if not data or 'age' not in data:
        return jsonify({'error': 'Missing fields'}), 400

    students = read_students()
    student = next((s for s in students if int(s['id']) == student_id), None)
    if student:
        student['age'] = data['age']
        write_students(students)
        return jsonify(student), 200
    return jsonify({'error': 'Student not found'}), 404

@app.route('/students/<int:student_id>', methods=['DELETE'])
def delete_student(student_id):
    students = read_students()
    student = next((s for s in students if int(s['id']) == student_id), None)
    if student:
        students.remove(student)
        write_students(students)
        return jsonify({'message': 'Student deleted successfully'}), 200
    return jsonify({'error': 'Student not found'}), 404

if __name__ == '__main__':
    app.run(debug=True)