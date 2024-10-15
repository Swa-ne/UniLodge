import pytesseract
from PIL import Image
import requests
from io import BytesIO
from deepface import DeepFace
import cv2
import numpy as np

def extractInformationFromID(image_url):
    response = requests.get(image_url)
    img = Image.open(BytesIO(response.content))

    text = pytesseract.image_to_string(img)

    print("Extracted Text:")
    print(text)

def isBlurry(image_url):
    response = requests.get(image_url)
    img = Image.open(BytesIO(response.content))
    if img is None:
        return "Image is not found"
    
    img = img.convert('L') 
    img_np = np.array(img)  

    laplacian_var = cv2.Laplacian(img_np, cv2.CV_64F).var()
    print(laplacian_var)
    return "Image is blurry" if laplacian_var < 40 else "Image is good"

def detectFaceFromImage(image_url):
    # Download the image
    response = requests.get(image_url)
    img = Image.open(BytesIO(response.content))

    # Convert the image to a format that OpenCV can use (NumPy array)
    img = cv2.cvtColor(np.array(img), cv2.COLOR_RGB2BGR)

    if img is None:
        return "Image not found"
    
    try:
        DeepFace.analyze(img_path=image_url, actions=['gender'], enforce_detection=True)
        return "Face detected!"
    except Exception as e:
        return "Face not found!"
    
def isMatching(face, id):
    faceResponse = requests.get(face)
    idResponse = requests.get(id)
    
    faceImg = Image.open(BytesIO(faceResponse.content))
    idImg = Image.open(BytesIO(idResponse.content))
    
    if faceImg is None:
        return "Face image not found"
    
    if idImg is None:
        return "ID image not found"
    
    # Convert PIL images to NumPy arrays
    faceImg_np = np.array(faceImg)
    idImg_np = np.array(idImg)
    
    # Verify using DeepFace
    try:
        result = DeepFace.verify(img1_path=faceImg_np, img2_path=idImg_np, model_name='VGG-Face', distance_metric='cosine')
        return result
    except Exception as e:
        return f"Error during verification: {str(e)}"
