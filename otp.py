import requests
import random
import time

# Constants
FAST2SMS_API_KEY = 'R8cyZ2vTXOsHu7YfPKNF5treIlCA4EM1ox9Bz3qmk0SLVWUnpdtJ3j9odT0gZAi1FeYMnSfDhmpBaP4U'  # Replace with your Fast2SMS API key
PHONE_NUMBER = '??????????'  # Replace with your phone number
OTP_VALID_DURATION = 60  # OTP valid for 60 seconds

# Globals
otp_code = None
otp_time = None

# Function to send OTP
def send_otp(phone_number):
    global otp_code, otp_time
    otp_code = random.randint(100000, 999999)  # Generate a 6-digit OTP
    otp_time = time.time()

    url = "https://www.fast2sms.com/dev/bulkV2"
    headers = {
        'authorization': FAST2SMS_API_KEY,
        'Content-Type': "application/x-www-form-urlencoded",
    }
    payload = f"sender_id=FSTSMS&message=Your OTP is {otp_code}&language=english&route=p&numbers={phone_number}"

    response = requests.request("POST", url, data=payload, headers=headers)
    if response.status_code == 200:
        print("OTP sent successfully!")
    else:
        print("Failed to send OTP. Error:", response.json())

# Function to verify OTP
def verify_otp(entered_otp):
    current_time = time.time()
    if otp_code is None:
        return "Please send an OTP first."
    if current_time - otp_time > OTP_VALID_DURATION:
        return "OTP expired. Please request a new one."
    if str(otp_code) == entered_otp:
        return "OTP is correct!"
    else:
        return "Incorrect OTP. Please try again."

# Main program flow
def otp_authentication():
    print("Welcome to the OTP-based User Authentication System")

    # Step 1: Send OTP
    send_otp(PHONE_NUMBER)

    # Step 2: Prompt user for OTP input
    entered_otp = input("Enter the OTP you received on your phone: ")

    # Step 3: Validate OTP
    result = verify_otp(entered_otp)
    print(result)

# Run the OTP authentication flow
otp_authentication()
