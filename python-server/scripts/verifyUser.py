import pytesseract
from PIL import Image
import requests
from io import BytesIO
from deepface import DeepFace
import cv2
import numpy as np
import difflib

pytesseract.pytesseract.tesseract_cmd = r'C:\Program Files\Tesseract-OCR\tesseract.exe'

def is_similar(a, b, threshold=0.6):
    return difflib.SequenceMatcher(None, a, b).ratio() > threshold

def checkIfIDisValid(image_url):
    try:
        response = requests.get(image_url)
        img = Image.open(BytesIO(response.content))

        text = pytesseract.image_to_string(img)
        target_text1 = "PHINMA EDUCATION"
        target_text2 = "MAKING LIVES BETTER THROUGH EDUCATION"
        
        for line in text.splitlines():
            if is_similar(line, target_text1):
                return "Valid ID"

            if is_similar(line, target_text2):
                return "Valid ID"
            
        return "Invalid ID"
    except Exception as e:
        return "Invalid ID"

def isBlurry(image_url):
    try:
        response = requests.get(image_url)
        img = Image.open(BytesIO(response.content))
        if img is None:
            return "Image is not found"
        
        img = img.convert('L') 
        img_np = np.array(img)  

        laplacian_var = cv2.Laplacian(img_np, cv2.CV_64F).var()
        return "Image is blurry" if laplacian_var < 20 else "Image is good"
    except Exception as e:
        print(e)
        return "Image is blurry"

def detectFaceFromImage(image_url):
    try:
        response = requests.get(image_url)
        img = Image.open(BytesIO(response.content))

        img = cv2.cvtColor(np.array(img), cv2.COLOR_RGB2BGR)

        if img is None:
            return "Image not found"
    
        DeepFace.analyze(img_path=image_url, actions=['gender'], enforce_detection=True)
        return "Face detected!"
    except Exception as e:
        return "Face not found!"
    
def isMatching(face, id):
    try:
        faceResponse = requests.get(face)
        idResponse = requests.get(id)
        
        faceImg = Image.open(BytesIO(faceResponse.content))
        idImg = Image.open(BytesIO(idResponse.content))
        
        if faceImg is None:
            return "Face image not found", False
        
        if idImg is None:
            return "ID image not found", False
        
        result = DeepFace.verify(img1_path=face, img2_path=id, model_name='Facenet', distance_metric='cosine')

        return result, True
    except Exception as e:
        return f"Error during verification: {str(e)}", False
