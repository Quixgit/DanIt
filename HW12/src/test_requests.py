import requests

BASE_URL = "http://127.0.0.1:5000/students"

def log_result(action, response):
    result = f"{action} - Status: {response.status_code}\nResponse: {response.text}\n"
    print(result)
    with open("results.txt", "a") as f:
        f.write(result)

# 1. Отримати всіх існуючих студентів (GET)
response = requests.get(BASE_URL)
log_result("GET all students", response)

# 2. Створіть трьох учнів (POST)
students = [
    {"first_name": "Oleksii", "last_name": "Shcherbyna", "age": 22},
    {"first_name": "Eugenia", "last_name": "Zinoveva", "age": 20},
    {"first_name": "Alice", "last_name": "Kabanchuk", "age": 23}
]

for student in students:
    response = requests.post(BASE_URL, json=student)
    log_result("POST create student", response)

# 3. Отримати інформацію про всіх існуючих студентів (GET)
response = requests.get(BASE_URL)
log_result("GET all students after creation", response)

# 4. Оновити вік другого учня (PATCH)
second_student_id = 2  
response = requests.patch(f"{BASE_URL}/{second_student_id}", json={"age": 21})
log_result("PATCH update age of second student", response)

# 5. Отримати інформацію про другого студента (GET)
response = requests.get(f"{BASE_URL}/{second_student_id}")
log_result("GET second student", response)

# 6. Оновити ім'я, прізвище та вік третього учня (PUT)
third_student_id = 3  
updated_student = {
    "first_name": "Alice123",
    "last_name": "Kabanchuk123",
    "age": 24
}
response = requests.put(f"{BASE_URL}/{third_student_id}", json=updated_student)
log_result("PUT update third student", response)

# 7. Retrieve information about the third student (GET)
response = requests.get(f"{BASE_URL}/{third_student_id}")
log_result("GET third student", response)

# 8. Отримати всіх існуючих студентів (GET)
response = requests.get(BASE_URL)
log_result("GET all students after updates", response)

# 9. Видалити першого користувача (DELETE)
first_student_id = 1 
response = requests.delete(f"{BASE_URL}/{first_student_id}")
log_result("DELETE first student", response)

# 10. Отримати всіх існуючих студентів (GET)
response = requests.get(BASE_URL)
log_result("GET all students after deletion", response)