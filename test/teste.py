#Instalar dependencias
#pip install opencv-python
#pip install pytesseract

#from PIL import Image

import pytesseract
import cv2

#Colocar caminho da imagem
imagem = cv2.imread("D:\Documentos\Projeto\Imagens Teste\modelo-cupom-fiscal-tradicional.png")
#Utilizar o "r" pra nao bugar na hora de ler o caminho
caminho = r"D:\Program Files\Tesseract-OCR"

pytesseract.pytesseract.tesseract_cmd = caminho + r"\tesseract.exe"
texto = pytesseract.image_to_string(imagem)

print(texto)